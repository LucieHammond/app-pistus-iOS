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
#import "APIManager.h"
#import "CarteViewController.h"

@interface GeolocalisationManager ()

@property (nonatomic,strong) DBManager *dbManager;

@end

static GeolocalisationManager* sharedInstance=nil;

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.vitesseActuelle=-1;
        sharedInstance.altitudeActuelle=-1;
        sharedInstance.vitesseMax=0;
        sharedInstance.altitudeMax=0;
        sharedInstance.altitudeMin=5000;
        sharedInstance.totalPositions=0;
        sharedInstance.vitesseCumulee=0;
        sharedInstance.distanceSki=0;
        sharedInstance.distanceTot=0;
        sharedInstance.deniveleTotal=0;
        sharedInstance.tempsDeSki=0;
        sharedInstance.enStation=false;
        sharedInstance.erreurLocalisation= false;
        
        NSDateComponents *composants = [[NSDateComponents alloc] init];
        [composants setYear:2016];
        [composants setMonth:3];
        [composants setDay:5];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:composants];
        sharedInstance.derniereDate=date;
        
        sharedInstance.station = @[@"routeresidence",@"routeprincipale",@"routesecondaire",@"routehaute",@"routeparking",@"centreville",@"patinoire",@"residence",@"residencegauche",@"residencedroite"];
        
        sharedInstance.joursFinis=[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
                                   [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
                                   [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
        sharedInstance.tabVitesseCumulee=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],nil];
        sharedInstance.tabNbPositions=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],nil];
        sharedInstance.tabDistance=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],nil];
        sharedInstance.tabTemps=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],
                                          [NSNumber numberWithFloat:-1],[NSNumber numberWithFloat:-1],nil];
        sharedInstance.utilisateursSuivis = [[NSMutableArray alloc]init];
    }
    return sharedInstance;
}

+(void)setSharedInstance:(GeolocalisationManager*)gm
{
    NSLog(@"%d", gm.trackAccept);
    sharedInstance = gm;
}

-(BOOL)beginTrack
{
    _trackAccept = YES;
    NSLog(@"begin Track");
    if ([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"track begun");
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // Les préférences par défaut sont peu précises et adaptés à un déplacement en car.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 700.0f;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.pausesLocationUpdatesAutomatically = true;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
            [locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        [locationManager startUpdatingLocation];
        
        // Toutes les 2 minutes, on envoie sa position au serveur (le timer continue même quand l'appli est en background)
        timerPosition = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(envoyerInfos) userInfo:nil repeats:YES];
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
    _altitudeActuelle=-1;
    _vitesseActuelle=-1;
    _pisteProche=nil;
    avantDerniereLoc = nil;
    _enStation = false;
    
    [locationManager stopUpdatingLocation];
    self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
    NSString *query = @"DELETE FROM maPosition";
    [self.dbManager executeQuery:query];
    
    if(dateDebutSki!=nil)
        _tempsDeSki+=MAX([[NSDate date] timeIntervalSinceDate:dateDebutSki],0);
    
    [timerPosition invalidate];
}

-(void)envoyerInfos
{
    if(dateDebutSki!=nil)
    {
        _tempsDeSki+= MAX([[NSDate date] timeIntervalSinceDate:dateDebutSki],0);
        dateDebutSki=[NSDate date];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromLastDate = [dateFormat stringFromDate:_derniereDate];
    //NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys: stringFromLastDate, @"lastPosUpdate", _vitesseMax, @"maxSpeed", _altitudeMax, @"altMax", _dernierX, @"mapPointX", _dernierY, @"mapPointY", _distanceSki, @"kmSki", _tempsDeSki, @"skiTime", nil];
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionary];
    [userData setObject:stringFromLastDate forKey:@"lastPosUpdate"];
    [userData setObject:[NSNumber numberWithDouble:_vitesseMax] forKey:@"maxSpeed"];
    [userData setObject:[NSNumber numberWithDouble:_altitudeMax] forKey:@"altMax"];
    [userData setObject:[NSNumber numberWithInt:_dernierX] forKey:@"mapPointX"];
    [userData setObject:[NSNumber numberWithInt:_dernierY] forKey:@"mapPointY"];
    [userData setObject:[NSNumber numberWithDouble:_distanceSki/1000] forKey:@"kmSki"];
    [userData setObject:[NSNumber numberWithDouble:_tempsDeSki] forKey:@"skiTime"];
    if(_dernierePiste!=nil){
        self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
        NSString *query = [NSString stringWithFormat:@"select nom from pistes where id='%@'",_dernierePiste];
        NSString *piste = [self.dbManager loadDataFromDB:query][0][0];
        [userData setObject:piste forKey:@"lastSlope"];
    }
        
    NSLog(@"Envoi données");
    [APIManager postToApi:@"http://apistus.via.ecp.fr/user/AUTH_KEY/update" :userData completion:nil];
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
    _erreurLocalisation=false;
    NSLog(@"Nombre localisations : %lu",(unsigned long)locations.count);
    CLLocation *lastLocation = locations.lastObject;
    double latitude = lastLocation.coordinate.latitude;
    double longitude = lastLocation.coordinate.longitude;
    
    // On vérifie si l'utilisateur se trouve bien sur le domaine skiable de la station
    if((latitude > 44.21 && latitude < 44.37 && longitude > 6.53 && longitude < 6.63) || (latitude > 48.76 && latitude < 48.77 && longitude > 2.28 && longitude < 2.30))
    {
        // On change les réglages par défauts pour les rendre plus précis
        if(locationManager.desiredAccuracy!=kCLLocationAccuracyBest)
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 5.0f;
            locationManager.pausesLocationUpdatesAutomatically = true;
            locationManager.activityType = CLActivityTypeFitness;
            goto marqueur;
        }
        
        // Si aucune position récente n'a été gardée, on cherche dans toute la bdd
        self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
        NSString *query = @"SELECT count(*) from maPosition;";
        int nbPositionsStockees = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]intValue];
        
        if(nbPositionsStockees == 0 && _pisteProche==nil)
        {
            NSLog(@"Pas d'infos antérieures de localisation");
            // On cherche dans toute la bdd
            query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
            
            // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
            if([self.dbManager loadDataFromDB:query].count==0)
            {
                _distanceStation = -1;
                _pisteProche = nil;
                NSString *newQuery = @"DELETE FROM maPosition";
                [self.dbManager executeQuery:newQuery];
                NSLog(@"A.1");
            }
            else
            {
                // On prend les infos sur le point le plus proche et on calcule la distance à ce point
                NSArray *array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                double distance = [lastLocation distanceFromLocation:pointPiste];
                
                // 2eme cas : si l'utilisateur est à moins de 20m d'un point référencé, on stocke les 5 dernières positions
                if(distance <= 20)
                {
                    // On met à jour les coordonnées à afficher sur la carte
                    _dernierX = (int)[array[0][3] integerValue];
                    _dernierY = (int)[array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    dernierNumero = (int)[array[0][2] integerValue];
                    if([_station containsObject:_dernierePiste])
                        _enStation = true;
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    _derniereDate = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:_derniereDate];
                    
                    // On met à jour les statistiques seulement si on est pas en station
                    if(!_enStation)
                    {
                        if(lastLocation.speed>=0)
                            _vitesseActuelle=lastLocation.speed;
                        if(lastLocation.speed>0)
                        {
                            _vitesseCumulee+=_vitesseActuelle;
                            _totalPositions++;
                        }
                        if(lastLocation.speed>_vitesseMax)
                            _vitesseMax=lastLocation.speed;
                        
                        if(lastLocation.altitude>_altitudeMax)
                            _altitudeMax=lastLocation.altitude;
                        else if(lastLocation.altitude<_altitudeMin)
                            _altitudeMin=lastLocation.altitude;
                        _altitudeActuelle = lastLocation.altitude;
                        dateDebutSki = _derniereDate;
                    }
                    
                    // On ajoute finalement la position trouvée à la table et on retient la position
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    NSLog(@"A.2");
                }
                // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                else
                {
                    // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                    query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                    _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                    _dernierePiste = array[0][1];
                    if([_station containsObject:_dernierePiste])
                        _enStation = true;
                    _distanceStation = distance;
                    NSLog(@"A.3");
                }
                avantDerniereLoc = lastLocation;
            }
        }
        else
        {
            // Cas où on a déjà des infos sur la position précédente
            //NSLog(@"Info sur position et nombre d'entrées : %d",nbPositionsStockees);
            
            // Si la table maPosition contient 5 entrées recentes qui correspondent à la même piste
            NSString *query = [NSString stringWithFormat:@"select count(*) from maPosition where id_piste = '%@'",_dernierePiste];
            int nbPositionsPiste = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]intValue];
            if(_enStation)
            {
                BOOL localisable=true;
                double distance=0;
                NSArray *array = nil;
                
                //On cherche le point parmi les pistes proches
                query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where (id_piste = '%@' or id_piste in (select suivante from proximite where precedente='%@')) and ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude,_dernierePiste,_dernierePiste];
                
                if([self.dbManager loadDataFromDB:query].count==0)
                    distance = 100;
                else
                {
                    // array prend ici aussi les caractéristiques du point trouvé
                    array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                    CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                    distance = [lastLocation distanceFromLocation:pointPiste];
                }
                if(distance<=20)
                {
                    // Si la distance est inférieure à 20m, c'est bon on garde le point trouvé
                }
                else
                {
                    //Cette section correspond à une recherche par défault
                    // On recherche partout le point le plus proche
                    query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
                    
                    // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
                    if([self.dbManager loadDataFromDB:query].count==0)
                    {
                        _distanceStation = -1;
                        _pisteProche = nil;
                        localisable=false;
                        _altitudeActuelle=-1;
                        _vitesseActuelle=-1;
                        NSString *newQuery = @"DELETE FROM maPosition";
                        [self.dbManager executeQuery:newQuery];
                        avantDerniereLoc = nil;
                        NSLog(@"D.1");
                    }
                    else
                    {
                        // On réinitialise array quel que soit le point trouvé
                        array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                        CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                        distance = [lastLocation distanceFromLocation:pointPiste];
                        
                        // 2eme cas : si l'utilisateur est à moins de 20m d'un point référencé, on stocke ses positions
                        if(distance <= 20)
                        {
                            // On laisse array comme il est redéfini
                        }
                        // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                        else
                        {
                            // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                            query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                            _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                            _dernierePiste = array[0][1];
                            if(![_station containsObject:_dernierePiste])
                                _enStation = false;
                            _distanceStation = distance;
                            localisable=false;
                            _altitudeActuelle=-1;
                            _vitesseActuelle=-1;
                            
                            _distanceTot+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                            avantDerniereLoc = lastLocation;
                            NSLog(@"D.3");
                        }
                    }
                }
                if(localisable)
                {
                    // A ce stade, on a obtenu un array qui représente le point de localisation voulu, quelle que soit le parcours réalisé dans le code ci-dessus. On met à jour la position avec l'array
                    _dernierX = (int)[array[0][3] integerValue];
                    _dernierY = (int)[array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    if(![_station containsObject:_dernierePiste])
                        _enStation = false;
                    dernierNumero = (int)[array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    _derniereDate = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:_derniereDate];
                    
                    // On met à jour les statistiques sauf si on est en station
                    if(!_enStation)
                    {
                        if(lastLocation.speed>=0)
                            _vitesseActuelle=lastLocation.speed;
                        if(lastLocation.speed>0)
                        {
                            _vitesseCumulee+=_vitesseActuelle;
                            _totalPositions++;
                        }
                        if(lastLocation.speed>_vitesseMax)
                            _vitesseMax=lastLocation.speed;
                        
                        if(lastLocation.altitude>_altitudeMax)
                            _altitudeMax=lastLocation.altitude;
                        else if(lastLocation.altitude<_altitudeMin)
                            _altitudeMin=lastLocation.altitude;
                        
                        if(lastLocation.altitude<_altitudeActuelle)
                            _deniveleTotal+=(_altitudeActuelle-lastLocation.altitude);
                        _altitudeActuelle=lastLocation.altitude;
                        dateDebutSki =_derniereDate;
                    }
                    else
                    {
                        _vitesseActuelle = -1;
                        _altitudeActuelle = -1;
                    }
                    _distanceTot+= MAX(0,[lastLocation distanceFromLocation:avantDerniereLoc]);
                    avantDerniereLoc = lastLocation;
                    
                    // On ajoute finalement la position trouvée à la table maPosition
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    
                    // Si la table est déjà pleine (5 positions), on retire la plus ancienne
                    if(nbPositionsStockees==5)
                    {
                        query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                        [self.dbManager executeQuery:query];
                    }
                    NSLog(@"D.2");
                }
            }
            else if(nbPositionsPiste == 5 && _pisteProche == nil)
            {
                double distance = 0;
                NSArray *array = nil;
                CLLocation *pointPiste;
                BOOL defaultRecherche = false;
                BOOL localisable = true;
                
                // On sépare deux cas : remontee et non remontee
                query = [NSString stringWithFormat:@"select est_remontee from pistes where id = '%@'",_dernierePiste];
                BOOL estRemontee = [[self.dbManager loadDataFromDB:query][0][0] boolValue];
                
                // Cas d'une piste quelconque
                if(estRemontee==false)
                {
                    // On cherche la position parmi les points de la derniere piste et des suivantes possibles
                    query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ((id_piste = '%@' and numero >=%d) or id_piste in (select suivante from proximite where precedente='%@')) and (numero<5 or id_piste not in (select id from pistes where est_remontee=1)) and ecartLat < 0.0009 and ecartLong < 0.0009)",latitude,longitude,_dernierePiste,dernierNumero,_dernierePiste];
                    if([self.dbManager loadDataFromDB:query].count==0)
                        distance = 100;
                    else
                    {
                        // Ici array prend les caractéristiques du point trouvé
                        array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                        pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                        distance = [lastLocation distanceFromLocation:pointPiste];
                    }
                    // Si le point le plus proche est sur la même piste qu'avant et que la distance à ce point est <=7m
                    if(distance <=7 && array[0][1]==_dernierePiste)
                    {
                        // On ne fait rien, on garde array comme il est
                    }
                    // Si le point le plus proche est sur l'une des pistes suivantes et que la distance à ce point est <=7m
                    else if(distance <=7 && array[0][1]!=_dernierePiste)
                    {
                        // On cherche le point le plus proche uniquement sur la piste
                        query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where id_piste = '%@' and numero >=%d and ecartLat < 0.0009 and ecartLong < 0.0009)",latitude,longitude,_dernierePiste,dernierNumero];
                        if([self.dbManager loadDataFromDB:query].count==0)
                        {
                            // On ne fait rien, on garde array comme il est
                        }
                        else
                        {
                            // Ici on définit un nouvel array qui prend les caractéristiques du nouveau point trouvé
                            NSArray *newArray = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                            CLLocation *newPointPiste = [[CLLocation alloc]initWithLatitude:[newArray[0][5] doubleValue] longitude:[newArray[0][6] doubleValue]];
                            double newDistance = [lastLocation distanceFromLocation:newPointPiste];
                            double differencePosition = [newPointPiste distanceFromLocation:pointPiste];
                            
                            // Si la différence entre les position des deux points trouvés est <=2,5m on privilégie la piste à condition que la distance totale avec le nouveau point sur la piste reste <=7m
                            if(newDistance <=7 && differencePosition<=2.5)
                            {
                                // On redéfinit array
                                array = newArray;
                            }
                            // Sinon on ne fait rien et on laisse array comme il est
                        }
                    }
                    // Si le point le plus proche trouvé est à plus de 7m
                    else
                    {
                        // On cherche le point dans toutes les pistes proches (les precedentes des suivantes et les suivantes des precedentes)
                        query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where (id_piste in (select precedente from proximite where suivante in(select suivante from proximite where precedente='%@')) or id_piste in (select suivante from proximite where precedente in (select precedente from proximite where suivante = '%@'))) and ecartLat < 0.0009 and ecartLong < 0.0009)",latitude,longitude,_dernierePiste, _dernierePiste];
                        double newDistance=0;
                        double differencePosition=0;
                        NSArray *newArray;
                        if([self.dbManager loadDataFromDB:query].count==0)
                            newDistance = 100;
                        else
                        {
                            // Ici on crée un nouvel array qui prend les caractéristiques du nouveau point trouvé
                            newArray = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                            CLLocation *newPointPiste = [[CLLocation alloc]initWithLatitude:[newArray[0][5] doubleValue] longitude:[newArray[0][6] doubleValue]];
                            newDistance = [lastLocation distanceFromLocation:newPointPiste];
                            differencePosition = [pointPiste distanceFromLocation:newPointPiste];
                        }
                        // Si la nouvelle distance est plus plus petite que la distance précédemment trouvée avec un écart supérieur à 2,5m et est aussi <=20m
                        if(newDistance<distance && differencePosition>=2.5 && newDistance <=20)
                        {
                            // On met à jour l'array
                            array = newArray;
                        }
                        else if(((newDistance<distance && differencePosition<=2.5) || (newDistance>=distance)) && distance <=20)
                        {
                            // A voir, à priori on ne fait rien et on garde l'array comme il est au départ
                        }
                        // Si les deux distances sont supérieures à 20m ou si elles sont rapprochées autour de 20m avec nd<20<d
                        else
                        {
                            defaultRecherche=true;
                        }
                    }
                }
                // Dans le cas d'une remontee mecanique
                else if(estRemontee==true)
                {
                    // Si on se trouve encore loin de l'arrivée, on cherche le point suivant uniquement sur la même remontée mecanique, puisqu'il n'est pas possible de sortir d'une remontee mecanique en cours de route (sauf teleski mais on suppose que le centralien moyen ne tombe pas du teleski)
                    query = [NSString stringWithFormat:@"select longueur from pistes where id = '%@'",_dernierePiste];
                    int longueur = [[self.dbManager loadDataFromDB:query][0][0] intValue];
                    if(dernierNumero < longueur -5)
                    {
                        query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where id_piste = '%@' and numero >=%d and ecartLat < 0.0009 and ecartLong < 0.0009)",latitude,longitude,_dernierePiste,dernierNumero];
                        if([self.dbManager loadDataFromDB:query].count==0)
                            distance = 100; // 100 est une valeur grande qui tient lieu de l'infini
                        else
                        {
                            // Ici array prend les caractéristiques du point trouvé
                            array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                            pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                            distance = [lastLocation distanceFromLocation:pointPiste];
                        }
                    }
                    else
                    {
                        query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ((id_piste = '%@' and numero >=%d) or id_piste in (select suivante from proximite where precedente='%@')) and ecartLat < 0.0009 and ecartLong < 0.0009)",latitude,longitude,_dernierePiste,dernierNumero,_dernierePiste];
                        if([self.dbManager loadDataFromDB:query].count==0)
                            distance = 100;
                        else
                        {
                            // array prend ici aussi les caractéristiques du point trouvé
                            array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                            pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                            distance = [lastLocation distanceFromLocation:pointPiste];
                        }
                    }
                    // Si la distance est <=15m c'est bon, sinon on cherche partout
                    if(distance>15)
                    {
                        defaultRecherche=true;
                    }
                }
                
                // Implémentation de la recherche par défaut dans le cas où aucun point convenable n'a été trouvé (c'est le même pour les pistes et les remontees)
                if(defaultRecherche)
                {
                    // On recherche partout le point le plus proche
                    query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
                    
                    // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
                    if([self.dbManager loadDataFromDB:query].count==0)
                    {
                        _distanceStation = -1;
                        _pisteProche = nil;
                        localisable=false;
                        _altitudeActuelle=-1;
                        _vitesseActuelle=-1;
                        if(dateDebutSki!=nil)
                            _tempsDeSki+=MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                        dateDebutSki=nil;
                        NSString *newQuery = @"DELETE FROM maPosition";
                        [self.dbManager executeQuery:newQuery];
                        avantDerniereLoc=nil;
                        NSLog(@"B.1");
                    }
                    else
                    {
                        // On réinitialise array quel que soit le point trouvé
                        array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                        pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                        distance = [lastLocation distanceFromLocation:pointPiste];
                        
                        // 2eme cas : si l'utilisateur est à moins de 20m d'un point référencé, on stocke ses positions
                        if(distance <= 20)
                        {
                            // On laisse array comme il est redéfini
                        }
                        // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                        else
                        {
                            // Dans ce cas, on ne permet pas de localiser precidement la personner mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                            query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                            _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                            _dernierePiste = array[0][1];
                            if([_station containsObject:_dernierePiste])
                                _enStation = true;
                            _distanceStation = distance;
                            if(dateDebutSki!=nil)
                                _tempsDeSki+=MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                            dateDebutSki=nil;
                            localisable=false;
                            _altitudeActuelle=-1;
                            _vitesseActuelle=-1;
                        
                            _distanceTot+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                            avantDerniereLoc = lastLocation;
                            NSLog(@"B.3");
                        }
                    }
                }
                
                if(localisable)
                {
                    // A ce stade, on a obtenu un array qui représente le point de localisation voulu, quelle que soit le parcours réalisé dans le code ci-dessus. On met à jour la position avec l'array
                    _dernierX = (int)[array[0][3] integerValue];
                    _dernierY = (int)[array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    if([_station containsObject:_dernierePiste])
                        _enStation = true;
                    dernierNumero = (int)[array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    _derniereDate = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:_derniereDate];
                    
                    // On met à jour les statistiques seulement si on est pas en station
                    if(!_enStation)
                    {
                        if(lastLocation.speed>=0)
                            _vitesseActuelle=lastLocation.speed;
                        if(lastLocation.speed>0)
                        {
                            _vitesseCumulee+=_vitesseActuelle;
                            _totalPositions++;
                        }
                        if(lastLocation.speed>_vitesseMax)
                            _vitesseMax=lastLocation.speed;
                        
                        if(lastLocation.altitude>_altitudeMax)
                            _altitudeMax=lastLocation.altitude;
                        else if(lastLocation.altitude<_altitudeMin)
                            _altitudeMin=lastLocation.altitude;
                        
                        if(lastLocation.altitude<_altitudeActuelle)
                            _deniveleTotal+=(_altitudeActuelle-lastLocation.altitude);
                        _altitudeActuelle=lastLocation.altitude;
                    }
                    else
                    {
                        _vitesseActuelle = -1;
                        _altitudeActuelle = -1;
                        if(dateDebutSki!=nil)
                            _tempsDeSki+=MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                        dateDebutSki=nil;
                    }
                    _distanceSki+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                    _distanceTot+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                    avantDerniereLoc = lastLocation;
                    
                    // On ajoute finalement la position trouvée à la table maPosition
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    
                    // Comme la table est déjà pleine (5 positions), on retire la plus ancienne
                    query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                    [self.dbManager executeQuery:query];
                    NSLog(@"B.2");
                }
            }
            /*Enfin, dans le cas où on ne peut pas être sûr de se trouver sur une piste (moins de 5 positions récentes sur cette piste, utilisateur à plus de 20m de celle ci ...), on utilise quand même l'indication sur la derniere piste pour optimiser la recherche mais sans trop de conditions*/
            else
            {
                BOOL localisable=true;
                double distance=0;
                NSArray *array = nil;
                
                //On cherche le point parmi les pistes proches
                query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where (id_piste = '%@' or id_piste in (select suivante from proximite where precedente='%@') or id_piste in (select precedente from proximite where suivante in(select suivante from proximite where precedente='%@')) or id_piste in (select suivante from proximite where precedente in (select precedente from proximite where suivante = '%@'))) and ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude,_dernierePiste,_dernierePiste,_dernierePiste,_dernierePiste];
                
                if([self.dbManager loadDataFromDB:query].count==0)
                    distance = 100;
                else
                {
                    // array prend ici aussi les caractéristiques du point trouvé
                    array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                    CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                    distance = [lastLocation distanceFromLocation:pointPiste];
                }
                if(distance<=20)
                {
                    // Si la distance est inférieure à 20m, c'est bon on garde le point trouvé
                }
                else
                {
                    //Cette section correspond à une recherche par défault
                    // On recherche partout le point le plus proche
                    query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
                    
                    // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
                    if([self.dbManager loadDataFromDB:query].count==0)
                    {
                        _distanceStation = -1;
                        _pisteProche = nil;
                        localisable=false;
                        _altitudeActuelle=-1;
                        _vitesseActuelle=-1;
                        if(dateDebutSki!=nil)
                            _tempsDeSki+= MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                        dateDebutSki=nil;
                        NSString *newQuery = @"DELETE FROM maPosition";
                        [self.dbManager executeQuery:newQuery];
                        avantDerniereLoc = nil;
                        NSLog(@"C.1");
                    }
                    else
                    {
                        // On réinitialise array quel que soit le point trouvé
                        array = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
                        CLLocation *pointPiste = [[CLLocation alloc]initWithLatitude:[array[0][5] doubleValue] longitude:[array[0][6] doubleValue]];
                        distance = [lastLocation distanceFromLocation:pointPiste];
                        
                        // 2eme cas : si l'utilisateur est à moins de 20m d'un point référencé, on stocke ses positions
                        if(distance <= 20)
                        {
                            // On laisse array comme il est redéfini
                        }
                        // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                        else
                        {
                            // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                            query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                            _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                            _dernierePiste = array[0][1];
                            if([_station containsObject:_dernierePiste])
                                _enStation = true;
                            _distanceStation = distance;
                            localisable=false;
                            _altitudeActuelle=-1;
                            _vitesseActuelle=-1;
                            if(dateDebutSki!=nil)
                                _tempsDeSki+= MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                            dateDebutSki=nil;
                            
                            _distanceTot+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                            avantDerniereLoc = lastLocation;
                            NSLog(@"C.3");
                        }
                    }
                }
                if(localisable)
                {
                    // A ce stade, on a obtenu un array qui représente le point de localisation voulu, quelle que soit le parcours réalisé dans le code ci-dessus. On met à jour la position avec l'array
                    _distanceTot+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                    if(_pisteProche==nil)
                        _distanceSki+= MAX([lastLocation distanceFromLocation:avantDerniereLoc],0);
                    avantDerniereLoc = lastLocation;
                    _dernierX = (int)[array[0][3] integerValue];
                    _dernierY = (int)[array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    if([_station containsObject:_dernierePiste])
                        _enStation = true;
                    dernierNumero = (int)[array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    _derniereDate = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:_derniereDate];  
                    
                    // On met à jour les statistiques sauf si on est en station
                    if(!_enStation)
                    {
                        if(lastLocation.speed>=0)
                            _vitesseActuelle=lastLocation.speed;
                        if(lastLocation.speed>0)
                        {
                            _vitesseCumulee+=_vitesseActuelle;
                            _totalPositions++;
                        }
                        if(lastLocation.speed>_vitesseMax)
                            _vitesseMax=lastLocation.speed;
                        
                        if(lastLocation.altitude>_altitudeMax)
                            _altitudeMax=lastLocation.altitude;
                        else if(lastLocation.altitude<_altitudeMin)
                            _altitudeMin=lastLocation.altitude;
                        
                        if(lastLocation.altitude<_altitudeActuelle)
                            _deniveleTotal+=(_altitudeActuelle-lastLocation.altitude);
                        _altitudeActuelle=lastLocation.altitude;
                        if(dateDebutSki==nil)
                            dateDebutSki=_derniereDate;
                    }
                    else
                    {
                        _vitesseActuelle = -1;
                        _altitudeActuelle = -1;
                        if(dateDebutSki!=nil)
                            _tempsDeSki+=MAX([lastLocation.timestamp timeIntervalSinceDate:dateDebutSki],0);
                        dateDebutSki=nil;
                    }
                    
                    // On ajoute finalement la position trouvée à la table maPosition
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    
                    // Si la table est déjà pleine (5 positions), on retire la plus ancienne
                    if(nbPositionsStockees==5)
                    {
                        query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                        [self.dbManager executeQuery:query];
                    }
                    NSLog(@"C.2");
                }
            }
        }
    }
    else
    {
        /* Dans le cas où l'utilisateur ne se trouve pas sur la station, on affiche la distance
         qui le sépare de la résidence */
        _pisteProche = nil;
        avantDerniereLoc=nil;
        _altitudeActuelle=-1;
        _vitesseActuelle=-1;
        
        CLLocation *residence = [[CLLocation alloc]initWithLatitude:44.292 longitude:6.565];
        _distanceStation = [lastLocation distanceFromLocation:residence];
        NSLog(@"4");
        
        // Si les réglages ont été changés, on remet ceux par défaut (plus économes en énergie)
        if(locationManager.desiredAccuracy!=kCLLocationAccuracyHundredMeters)
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            locationManager.distanceFilter = 700.0f;
            locationManager.pausesLocationUpdatesAutomatically = true;
            locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        }
    }
    
    marqueur:;
    // Si l'utilisateur est sur la carte ou sur les statistiques on update la vue automatiquement
    AppDelegate *tmpDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav= (UINavigationController*)tmpDelegate.window.rootViewController;
    NSLog(@"my nav : %@", nav.title);
    if ([nav.visibleViewController.title isEqual:@"Carte View Controller"])
    {
        NSLog(@"here");
        CarteViewController * CVcontroller = (CarteViewController*) nav.visibleViewController;
        [CVcontroller updateSelfPosition];
    }
    else if([nav.visibleViewController.title isEqual:@"Statistiques"])
    {
        NSLog(@"there");
        UITabBarController *tb = (UITabBarController *) nav.visibleViewController;
        if([tb.selectedViewController.title isEqual:@"Mes statistiques"])
            [tb.selectedViewController viewDidLoad];
    }
    NSLog(@"finished");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Erreur de localisation");
    _erreurLocalisation = true;
}

- (void)locationManagerDidPausedLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)sauvegarderDonneesJour:(int)jour :(bool)definitivement
{
    _tabVitesseCumulee[jour] = [NSNumber numberWithFloat: _vitesseCumulee];
    _tabNbPositions[jour] = [NSNumber numberWithFloat:_totalPositions];
    _tabDistance[jour] = [NSNumber numberWithFloat:_distanceSki];
    _tabTemps[jour] = [NSNumber numberWithFloat:_tempsDeSki/3600];
    if(definitivement==true)
        _joursFinis[jour]=[NSNumber numberWithBool:true];
}
-(void)sauvegardeParTimer:(NSTimer*)timer
{
    NSDate *date = timer.fireDate;
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier components:(NSHourCalendarUnit|NSDayCalendarUnit) fromDate:date];
    if([composants hour]==12 || [composants hour] ==17)
    {
        [self sauvegarderDonneesJour:(int)[composants day]-5 :false];
    }
    else{
        [self sauvegarderDonneesJour:(int)[composants day]-5 :true];
    }
}

- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeDouble:_distanceStation forKey:@"distanceStation"];
    [coder encodeDouble:_vitesseActuelle forKey:@"vitesseActuelle"];
    [coder encodeDouble:_vitesseMax forKey: @"vitesseMax"];
    [coder encodeDouble:_vitesseCumulee forKey:@"vitesseCumulee"];
    [coder encodeInt:_totalPositions forKey:@"totalPositions"];
    [coder encodeDouble:_altitudeActuelle forKey:@"altitudeActuelle"];
    [coder encodeDouble:_altitudeMin forKey:@"altitudeMin"];
    [coder encodeDouble:_altitudeMax forKey:@"altitudeMax"];
    [coder encodeDouble:_distanceSki forKey:@"distanceSki"];
    [coder encodeDouble:_distanceTot forKey:@"distanceTot"];
    [coder encodeDouble:_deniveleTotal forKey:@"deniveleTotal"];
    [coder encodeDouble:_tempsDeSki forKey:@"tempsDeSki"];
    [coder encodeObject:_joursFinis forKey:@"joursFinis"];
    [coder encodeObject:_tabVitesseCumulee forKey:@"tabVitesseCumulee"];
    [coder encodeObject:_tabDistance forKey:@"tabDistance"];
    [coder encodeObject:_tabTemps forKey:@"tabTemps"];
    [coder encodeObject:_station forKey:@"station"];
    [coder encodeInt:_dernierX forKey:@"dernierX"];
    [coder encodeInt:_dernierY forKey:@"dernierY"];
    [coder encodeObject:_dernierePiste forKey:@"dernierePiste"];
    [coder encodeObject:_pisteProche forKey:@"pisteProche"];
    [coder encodeObject:_derniereDate forKey:@"derniereDate"];
    [coder encodeBool:_enStation forKey:@"enStation"];
    [coder encodeObject:_utilisateursSuivis forKey:@"utilisateursSuivis"];
    [coder encodeBool:_trackAccept forKey:@"trackAccept"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.distanceStation = [decoder decodeDoubleForKey:@"distanceStation"];
        self.vitesseActuelle = [decoder decodeDoubleForKey:@"vitesseActuelle"];
        self.vitesseMax = [decoder decodeDoubleForKey:@"vitesseMax"];
        self.vitesseCumulee = [decoder decodeDoubleForKey:@"vitesseCumulee"];
        self.totalPositions = [decoder decodeIntForKey:@"totalPositions"];
        self.altitudeActuelle = [decoder decodeDoubleForKey:@"altitudeActuelle"];
        self.altitudeMin = [decoder decodeDoubleForKey:@"altitudeMin"];
        self.altitudeMax = [decoder decodeDoubleForKey:@"altitudeMax"];
        self.distanceSki = [decoder decodeDoubleForKey:@"distanceSki"];
        self.distanceTot = [decoder decodeDoubleForKey:@"distanceTot"];
        self.deniveleTotal = [decoder decodeDoubleForKey:@"deniveleTotal"];
        self.tempsDeSki = [decoder decodeDoubleForKey:@"tempsDeSki"];
        self.joursFinis = [decoder decodeObjectForKey:@"joursFinis"];
        self.tabVitesseCumulee = [decoder decodeObjectForKey:@"tabVitesseCumulee"];
        self.tabDistance = [decoder decodeObjectForKey:@"tabDistance"];
        self.tabTemps = [decoder decodeObjectForKey:@"tabTemps"];
        self.station = [decoder decodeObjectForKey:@"station"];
        self.dernierX = [decoder decodeIntForKey:@"dernierX"];
        self.dernierY = [decoder decodeIntForKey:@"dernierY"];
        self.dernierePiste = [decoder decodeObjectForKey:@"dernierePiste"];
        self.pisteProche = [decoder decodeObjectForKey:@"pisteProche"];
        self.derniereDate = [decoder decodeObjectForKey:@"derniereDate"];
        self.enStation = [decoder decodeBoolForKey:@"enStation"];
        self.utilisateursSuivis = [decoder decodeObjectForKey:@"utilisateursSuivis"];
        self.trackAccept = [decoder decodeBoolForKey:@"trackAccept"];
    }
    return self;
}

@end
