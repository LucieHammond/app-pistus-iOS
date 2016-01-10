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

@end

static GeolocalisationManager* sharedInstance=nil;

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.vitesseMax=0;
        sharedInstance.altitudeMax=0;
        sharedInstance.deniveleTotal=0;
        sharedInstance.tempsDeSki=0;
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
    _pisteProche=nil;
    if(dateDebutSki!=nil)
        _tempsDeSki+=[[NSDate date] timeIntervalSinceDate:dateDebutSki];
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
    CLLocation *lastLocation = locations.lastObject;
    double latitude = lastLocation.coordinate.latitude;
    double longitude = lastLocation.coordinate.longitude;
    
    // On vérifie si l'utilisateur se trouve bien sur le domaine skiable de la station
    if(latitude > 44.21 && latitude < 44.37 && longitude > 6.53 && longitude < 6.63)
    {
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
        
        if(nbPositionsStockees == 0 && _pisteProche==nil)
        {
            NSLog(@"Pas d'infos de localisation");
            // On cherche dans toute la bdd
            query = [NSString stringWithFormat:@"select min(12363216100*ecartLat*ecartLat+12203620900*ecartLong*ecartLong),id_piste,numero,x,y,latitude,longitude from (select abs(latitude-%f) as ecartLat, abs(longitude-%f) as ecartLong,id_piste,numero,x,y,latitude,longitude from points where ecartLat < 0.0009 and ecartLong < 0.0009);",latitude,longitude];
            
            // 1er cas : utilisateur à plus de 100m de n'importe quelle piste
            if([self.dbManager loadDataFromDB:query].count==0)
            {
                _distanceStation = -1;
                _pisteProche = nil;
                NSString *newQuery = @"DELETE FROM maPosition";
                [self.dbManager executeQuery:newQuery];
                NSLog(@"1.1");
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
                    _dernierX = [array[0][3] integerValue];
                    _dernierY = [array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    dernierNumero = [array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    NSDate *date = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:date];
                    
                    // On met à jour les statistiques
                    if(lastLocation.speed>_vitesseMax)
                        _vitesseMax=lastLocation.speed;
                    if(lastLocation.altitude>_altitudeMax)
                        _altitudeMax=lastLocation.altitude;
                    dateDebutSki = date;
                    derniereAltitude = lastLocation.altitude;
                    
                    // On ajoute finalement la position trouvée à la table
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    NSLog(@"1.2");
                }
                // 3eme cas : l'utilisateur est entre 20m et 100m d'un point référencé
                else
                {
                    // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                    query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                    _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                    _dernierePiste = array[0][1];
                    _distanceStation = distance;
                    NSLog(@"1.3");
                }
            }
        }
        else
        {
            // Cas où on a déjà des infos sur la position précédente
            NSLog(@"Info sur position et nombre d'entrées : %d",nbPositionsStockees);
            
            // Si la table maPosition contient 5 entrées recentes qui correspondent à la même piste
            NSString *query = [NSString stringWithFormat:@"select count(*) from maPosition where id_piste = '%@'",_dernierePiste];
            int nbPositionsPiste = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]intValue];
            if(nbPositionsPiste == 5 && _pisteProche == nil)
            {
                double distance = 0;
                NSArray *array = nil;
                CLLocation *pointPiste;
                BOOL defaultRecherche = false;
                BOOL localisable;
                
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
                        NSString *newQuery = @"DELETE FROM maPosition";
                        [self.dbManager executeQuery:newQuery];
                        NSLog(@"2.1");
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
                            // Dans ce cas, on ne permet pas de statistiquer mais on garde une trace de la piste la plus proche et de la distance à cette piste, sans changer le repère de place sur la carte
                            query = [NSString stringWithFormat:@"select nom from pistes where id = '%@'",array[0][1]];
                            _pisteProche = [self.dbManager loadDataFromDB:query][0][0];
                            _dernierePiste = array[0][1];
                            _distanceStation = distance;
                            _tempsDeSki+=[lastLocation.timestamp timeIntervalSinceDate:dateDebutSki];
                            localisable=false;
                            NSLog(@"2.3");
                        }
                    }
                }
                
                if(localisable)
                {
                    // A ce stade, on a obtenu un array qui représente le point de localisation voulu, quelle que soit le parcours réalisé dans le code ci-dessus. On met à jour la position avec l'array
                    _dernierX = [array[0][3] integerValue];
                    _dernierY = [array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    dernierNumero = [array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    NSDate *date = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:date];
                    
                    // On met à jour les statistiques
                    if(lastLocation.speed>_vitesseMax)
                        _vitesseMax=lastLocation.speed;
                    if(lastLocation.altitude>_altitudeMax)
                        _altitudeMax=lastLocation.altitude;
                    if(lastLocation.altitude<derniereAltitude)
                        _deniveleTotal+=(derniereAltitude-lastLocation.altitude);
                    derniereAltitude=lastLocation.altitude;
                    
                    // On ajoute finalement la position trouvée à la table maPosition
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    
                    // Comme la table est déjà pleine (5 positions), on retire la plus ancienne
                    query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                    [self.dbManager executeQuery:query];
                    NSLog(@"2.2");
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
                        NSString *newQuery = @"DELETE FROM maPosition";
                        [self.dbManager executeQuery:newQuery];
                        NSLog(@"3.1");
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
                            _distanceStation = distance;
                            localisable=false;
                            NSLog(@"3.3");
                            if(dateDebutSki!=nil)
                                _tempsDeSki+=[lastLocation.timestamp timeIntervalSinceDate:dateDebutSki];
                        }
                    }
                }
                if(localisable)
                {
                    // A ce stade, on a obtenu un array qui représente le point de localisation voulu, quelle que soit le parcours réalisé dans le code ci-dessus. On met à jour la position avec l'array
                    _dernierX = [array[0][3] integerValue];
                    _dernierY = [array[0][4] integerValue];
                    _pisteProche=nil;
                    _distanceStation=0;
                    _dernierePiste = array[0][1];
                    dernierNumero = [array[0][2] integerValue];
                    
                    // On mémorise la date à laquelle la position a été atteinte.
                    NSDate *date = lastLocation.timestamp;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateString = [df stringFromDate:date];
                    
                    // On met à jour les statistiques
                    if(lastLocation.speed>_vitesseMax)
                        _vitesseMax=lastLocation.speed;
                    if(lastLocation.altitude>_altitudeMax)
                        _altitudeMax=lastLocation.altitude;
                    if(lastLocation.altitude<derniereAltitude)
                        _deniveleTotal+=(derniereAltitude-lastLocation.altitude);
                    derniereAltitude=lastLocation.altitude;
                    if(dateDebutSki==nil)
                        dateDebutSki=date;
                    
                    // On ajoute finalement la position trouvée à la table maPosition
                    query = [NSString stringWithFormat:@"INSERT INTO maPosition(date,latitude,longitude,altitude,id_piste,numero,vitesse) VALUES ('%@',%f,%f,%f,'%@',%@,%f);",dateString,latitude,longitude,lastLocation.altitude,array[0][1],array[0][2],lastLocation.speed];
                    [self.dbManager executeQuery:query];
                    
                    // Si la table est déjà pleine (5 positions), on retire la plus ancienne
                    if(nbPositionsStockees==5)
                    {
                        query = [NSString stringWithFormat:@"DELETE FROM maPosition where date in (select min(date) from maPosition)"];
                        [self.dbManager executeQuery:query];
                    }
                    NSLog(@"3.2");
                }
            }
        }
    }
    else
    {
        /* Dans le cas où l'utilisateur ne se trouve pas sur la station, on affiche la distance
         qui le sépare de la résidence */
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
