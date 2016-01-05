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
    [locationManager stopUpdatingLocation];
    self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
    NSString *query = @"DELETE FROM maPosition";
    [self.dbManager executeQuery:query];
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
        
        // On change les réglages par défauts pour les rendre plus précis
        if(locationManager.desiredAccuracy!=kCLLocationAccuracyBest)
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 2.0f;
            locationManager.pausesLocationUpdatesAutomatically = true;
            locationManager.activityType = CLActivityTypeFitness;
        }
        
        // Si aucune position récente n'a été gardée, on cherche dans toute la bdd
        self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
        NSString *query = @"SELECT count(*) from maPosition;";
        int nbPositionsStockees = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]intValue];
        if(nbPositionsStockees == 0)
        {
            query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
            // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
            if([self.dbManager loadDataFromDB:query].count==0)
            {
                NSLog(@"Impossible de vous localiser sur le domaine skiable");
                _distanceStation = -1;
                _pisteProche = nil;
                NSString *newQuery = @"DELETE FROM maPosition";
                [self.dbManager executeQuery:newQuery];
            }
            else
            {
                // On mémorise la date à laquelle la position a été atteinte.
                NSDate *date = lastLocation.timestamp;
                NSDateFormatter* df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSString *dateString = [df stringFromDate:date];
                
                NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                double distance = [lastLocation distanceFromLocation:pointPiste];
                
                // 2eme cas : si l'utilisateur est à moins de 20m d'un point référencé, on stocke les 15 dernières positions
                if(distance <= 20)
                {
                    // On met à jour les coordonnées à afficher sur la carte
                    _dernierX = [array[0][3] integerValue];
                    _dernierY = [array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    
                    // On ajoute finalement la position trouvée à la table
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                }
                // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                else
                {
                    // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                    NSLog(@"Un peu trop loin des pistes");
                    _pisteProche = array[0][1];
                    _distanceStation = distance;
                }
            }
        }
        else
        {
            // Cas où la table maPosition contient déjà des entrées récentes
            NSLog(@"Table modifiée nombre d'entrées : %d",nbPositionsStockees);
            
            // Si la table était déjà pleine (15 positions), on retire la plus ancienne
            if(nbPositionsStockees==15)
            {
                query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                [self.dbManager executeQuery:query];
            }
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
