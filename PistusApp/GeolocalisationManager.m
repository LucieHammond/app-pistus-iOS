//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"
#import "AppDelegate.h"
#import "DBManager.h"

@interface GeolocalisationManager ()

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSArray *arrPeopleInfo;

@end

static GeolocalisationManager* sharedInstance=nil;

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

-(BOOL)beginTrack
{
    _trackAccept = true;
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // Les préférences par défaut sont peu précises et adaptés à un déplacement en car.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 700.0f;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        locationManager.pausesLocationUpdatesAutomatically = true;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [locationManager startUpdatingLocation];
        //timerPosition = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
        return true;
    }
    else
    {
        return false;
    }
}

-(void)endTrack
{
    _trackAccept = false;
    [timerPosition invalidate];
    [locationManager stopUpdatingLocation];
}

-(void)boucle
{
    NSLog(@"1");
}

-(BOOL)trackAccept
{
    return _trackAccept;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%d",locations.count);
    CLLocation *lastLocation = locations.lastObject;
    double latitude = lastLocation.coordinate.latitude;
    double longitude = lastLocation.coordinate.longitude;
    
    // On vérifie si l'utilisateur se trouve bien sur le domaine skiable de la station
    if(latitude > 44.21 && latitude < 44.37 && longitude > 6.53 && longitude < 6.63)
    {
        NSLog(@"Potentiellement localisable sur la carte");
        _distanceStation=0;
        
        // On change les réglages par défauts pour les rendre plus précis
        if(locationManager.desiredAccuracy!=kCLLocationAccuracyBest)
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 2.0f;
            locationManager.pausesLocationUpdatesAutomatically = true;
            locationManager.activityType = CLActivityTypeFitness;
        }
        
        // On stocke les 10 dernières positions dans la table maPosition de la bdd
        NSDate *date = lastLocation.timestamp;
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString *dateString = [df stringFromDate:date];
        
        // Si aucune position récente n'a été gardée, on cherche dans toute la bdd
        self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
        NSString *query = @"SELECT count(*) from maPosition;";
        int nbPositionsStockees = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]intValue];
        if(nbPositionsStockees == 0)
        {
            query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
            if([self.dbManager loadDataFromDB:query].count==0)
            {
                NSLog(@"Beaucoup trop loin des pistes");
            }
            else
            {
                NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                double distance = [lastLocation distanceFromLocation:pointPiste];
                
                if(distance <= 20)
                {
                    // On met à jour les coordonnées à afficher sur la carte
                    _dernierX = [array[0][3] integerValue];
                    _dernierY = [array[0][4] integerValue];
                    
                    // On ajoute finalement la position trouvée à la table
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES (%@,%f,%f,%f,%@,%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    //[self.dbManager executeQuery:query];
                }
                else
                {
                    NSLog(@"Un peu trop loin des pistes");
                }
            }
        }
        else
        {
            NSLog(@"Table modifiée nombre d'entrées : %d",nbPositionsStockees);
        }
    }
    else
    {
        /* Dans le cas où l'utilisateur ne se trouve pas sur la station, on affiche la distance
         que le sépare de la résidence */
        CLLocation *residence = [[CLLocation alloc]initWithLatitude:44.292 longitude:6.565];
        _distanceStation = [lastLocation distanceFromLocation:residence];
        NSLog(@"%f",_distanceStation);
    }
    
    // Si l'utilisateur est sur la carte, on update la vue automatiquement
    AppDelegate *tmpDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav= (UINavigationController*)tmpDelegate.window.rootViewController;
    if ([nav.visibleViewController.title isEqual:@"Carte View Controller"])
    {
        [nav.visibleViewController viewDidLoad];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Erreur de localisation");
}

- (void)locationManagerDidPausedLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

@end
