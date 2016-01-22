//
//  ClassementViewController.m
//  PistusApp
//
//  Created by Lucie on 13/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "ClassementViewController.h"
#import "GeolocalisationManager.h"

@interface ClassementViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation ClassementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    prenom = @"Jean-Michel";
    nom = @"Dupont";
    performance = 23.8;
    classement = 23;
    long int userId;
    
    NSString *query = [NSString stringWithFormat:@"select count(*) from AppUser where maxSpeed > all(select maxSpeed from AppUser where eleve_id = %lu);",userId];
    // ne pas oulier d'ajouter 1 au résultat de la requête
    _classementVitesse.text = [NSString stringWithFormat:@"Votre classement : %u",classement];
    query = @"select E.Nom, E.Prenom, A.maxSpeed, E.id from Eleve E join AppUser A on E.id = A.eleve_id where maxSpeed in (select max(maxSpeed) from AppUser";
    _g1Vitesse.text = [NSString stringWithFormat:@"1 - %@ %@ :",prenom,nom];
    _v1Vitesse.text = [NSString stringWithFormat:@"%.1f km/h",performance*3.6];
    long int id1;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.maxSpeed, E.id from Eleve E join AppUser A on E.id = A.eleve_id where maxSpeed in (select max(maxSpeed) from AppUser where eleve_id!=%lu) and E.id!=%lu);",id1,id1];
    _g2Vitesse.text = [NSString stringWithFormat:@"2 - %@ %@ :",prenom,nom];
    _v2Vitesse.text = [NSString stringWithFormat:@"%.1f km/h",performance*3.6];
    long int id2;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.maxSpeed, E.id from Eleve E join AppUser A on E.id = A.eleve_id where maxSpeed in (select max(maxSpeed) from AppUser where eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu);",id1,id1,id2,id2];
    _g3Vitesse.text = [NSString stringWithFormat:@"3 - %@ %@ :",prenom,nom];
    _v3Vitesse.text = [NSString stringWithFormat:@"%.1f km/h",performance*3.6];
    long int id3;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.maxSpeed, E.id from Eleve E join AppUser A on E.id = A.eleve_id where maxSpeed in (select max(maxSpeed) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3];
    _g4Vitesse.text = [NSString stringWithFormat:@"4 - %@ %@ :",prenom,nom];
    _v4Vitesse.text = [NSString stringWithFormat:@"%.1f km/h",performance*3.6];
    long int id4;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.maxSpeed from Eleve E join AppUser A on E.id = A.eleve_id where maxSpeed in (select max(maxSpeed) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu and E.id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3,id4,id4];
    _g5Vitesse.text = [NSString stringWithFormat:@"5 - %@ %@ :",prenom,nom];
    _v5Vitesse.text = [NSString stringWithFormat:@"%.1f km/h",performance*3.6];
    
    performance = 2460;
    query = [NSString stringWithFormat:@"select count(*) from AppUser where altMax > all(select altMax from AppUser where eleve_id = %lu);",userId];
    _classementAltitude.text = [NSString stringWithFormat:@"Votre classement : %u",classement];
    query = @"select E.Nom, E.Prenom, A.altMax, E.id from Eleve E join AppUser A on E.id = A.eleve_id where altMax in (select max(altMax) from AppUser";
    _g1Altitude.text = [NSString stringWithFormat:@"1 - %@ %@ :",prenom,nom];
    _v1Altitude.text = [NSString stringWithFormat:@"%.f m",performance];
    id1 = id1;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.altMax, E.id from Eleve E join AppUser A on E.id = A.eleve_id where altMax in (select max(altMax) from AppUser where eleve_id!=%lu) and E.id!=%lu);",id1,id1];
    _g2Altitude.text = [NSString stringWithFormat:@"2 - %@ %@ :",prenom,nom];
    _v2Altitude.text = [NSString stringWithFormat:@"%.f m",performance];
    id2 = id2;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.altMax, E.id from Eleve E join AppUser A on E.id = A.eleve_id where altMax in (select max(altMax) from AppUser where eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu);",id1,id1,id2,id2];
    _g3Altitude.text = [NSString stringWithFormat:@"3 - %@ %@ :",prenom,nom];
    _v3Altitude.text = [NSString stringWithFormat:@"%.f m",performance];
    id3 = id3;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.altMax, E.id from Eleve E join AppUser A on E.id = A.eleve_id where altMax in (select max(altMax) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3];
    _g4Altitude.text = [NSString stringWithFormat:@"4 - %@ %@ :",prenom,nom];
    _v4Altitude.text = [NSString stringWithFormat:@"%.f m",performance];
    id4 = id4;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.altMax from Eleve E join AppUser A on E.id = A.eleve_id where altMax in (select max(altMax) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu and E.id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3,id4,id4];
    _g5Altitude.text = [NSString stringWithFormat:@"5 - %@ %@ :",prenom,nom];
    _v5Altitude.text = [NSString stringWithFormat:@"%.f m",performance];
    
    performance = 4802;
    query = [NSString stringWithFormat:@"select count(*) from AppUser where kmSki > all(select kmSki from AppUser where eleve_id = %lu);",userId];
    _classementDistance.text = [NSString stringWithFormat:@"Votre classement : %u",classement];
    query = @"select E.Nom, E.Prenom, A.kmSki, E.id from Eleve E join AppUser A on E.id = A.eleve_id where kmSki in (select max(kmSki) from AppUser";
    _g1Distance.text = [NSString stringWithFormat:@"1 - %@ %@ :",prenom,nom];
    _v1Distance.text = [NSString stringWithFormat:@"%.1f km",performance];
    id1 = id1;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.kmSki, E.id from Eleve E join AppUser A on E.id = A.eleve_id where kmSki in (select max(kmSki) from AppUser where eleve_id!=%lu) and E.id!=%lu);",id1,id1];
    _g2Distance.text = [NSString stringWithFormat:@"2 - %@ %@ :",prenom,nom];
    _v2Distance.text = [NSString stringWithFormat:@"%.1f km",performance];
    id2 = id2;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.kmSki, E.id from Eleve E join AppUser A on E.id = A.eleve_id where kmSki in (select max(kmSki) from AppUser where eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu);",id1,id1,id2,id2];
    _g3Distance.text = [NSString stringWithFormat:@"3 - %@ %@ :",prenom,nom];
    _v3Distance.text = [NSString stringWithFormat:@"%.1f km",performance];
    id3 = id3;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.kmSki, E.id from Eleve E join AppUser A on E.id = A.eleve_id where kmSki in (select max(kmSki) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3];
    _g4Distance.text = [NSString stringWithFormat:@"4 - %@ %@ :",prenom,nom];
    _v4Distance.text = [NSString stringWithFormat:@"%.1f km",performance];
    id4 = id4;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.kmSki from Eleve E join AppUser A on E.id = A.eleve_id where kmSki in (select max(kmSki) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu and E.id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3,id4,id4];
    _g5Distance.text = [NSString stringWithFormat:@"5 - %@ %@ :",prenom,nom];
    _v5Distance.text = [NSString stringWithFormat:@"%.1f km",performance];
    
    performance = 177716;
    query = [NSString stringWithFormat:@"select count(*) from AppUser where skiTime > all(select skiTime from AppUser where eleve_id = %lu);",userId];
    _classementTemps.text = [NSString stringWithFormat:@"Votre classement : %u",classement];
    query = @"select E.Nom, E.Prenom, A.skiTime, E.id from Eleve E join AppUser A on E.id = A.eleve_id where skiTime in (select max(skiTime) from AppUser";
    _g1Temps.text = [NSString stringWithFormat:@"1 - %@ %@ :",prenom,nom];
    int heure = floor(performance/3600);
    float minute = (performance-heure*3600)/60;
    _v1Temps.text = [NSString stringWithFormat:@"%uh %.fmin",heure,minute];
    id1 = id1;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.skiTime, E.id from Eleve E join AppUser A on E.id = A.eleve_id where skiTime in (select max(skiTime) from AppUser where eleve_id!=%lu) and E.id!=%lu);",id1,id1];
    _g2Temps.text = [NSString stringWithFormat:@"2 - %@ %@ :",prenom,nom];
    heure = floor(performance/3600);
    minute = (performance-heure*3600)/60;
    _v2Temps.text = [NSString stringWithFormat:@"%uh %.fmin",heure,minute];
    id2 = id2;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.skiTime, E.id from Eleve E join AppUser A on E.id = A.eleve_id where skiTime in (select max(skiTime) from AppUser where eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu);",id1,id1,id2,id2];
    _g3Temps.text = [NSString stringWithFormat:@"3 - %@ %@ :",prenom,nom];
    heure = floor(performance/3600);
    minute = (performance-heure*3600)/60;
    _v3Temps.text = [NSString stringWithFormat:@"%uh %.fmin",heure,minute];
    id3 = id3;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.skiTime, E.id from Eleve E join AppUser A on E.id = A.eleve_id where skiTime in (select max(skiTime) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3];
    _g4Temps.text = [NSString stringWithFormat:@"4 - %@ %@ :",prenom,nom];
    heure = floor(performance/3600);
    minute = (performance-heure*3600)/60;
    _v4Temps.text = [NSString stringWithFormat:@"%uh %.fmin",heure,minute];
    id4 = id4;
    query = [NSString stringWithFormat:@"select E.Nom, E.Prenom, A.skiTime, E.id from Eleve E join AppUser A on E.id = A.eleve_id where skiTime in (select max(skiTime) from AppUser where eleve_id!=%lu and eleve_id!=%lu and eleve_id!=%lu and E.id!=%lu) and E.id!=%lu and E.id !=%lu and E.id !=%lu and E.id !=%lu);",id1,id1,id2,id2,id3,id3,id4,id4];
    _g5Temps.text = [NSString stringWithFormat:@"5 - %@ %@ :",prenom,nom];
    heure = floor(performance/3600);
    minute = (performance-heure*3600)/60;
    _v5Temps.text = [NSString stringWithFormat:@"%uh %.fmin",heure,minute];

}

-(void) viewDidLayoutSubviews{
    
    //Ajustement de la barre de navigation en haut et configuration des icones
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    _boutonSatellite = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,33)];
    if(![[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
    }
    else if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
    [_boutonSatellite addTarget:self action:@selector(trackChange)
               forControlEvents:UIControlEventTouchUpInside];
    
    // Ajustement du scrollView
    [_scrollView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-114)];
    [_scrollView setScrollEnabled:YES];
    
    // Repositionnement des éléments sur la vue en fonction de la taille de l'écran
    float hauteur = [UIScreen mainScreen].bounds.size.height;
    if(hauteur<600)
    {
        [_iconeVitesse setFrame:CGRectMake(25, 20, 60, 60)];
        [_titreVitesse setFrame:CGRectMake(101,43,210,21)];
        [_classementVitesse  setFrame:CGRectMake(33, 91, 165, 21)];
        [_g1Vitesse setFrame:CGRectMake(48, 123, 180, 21)];
        [_g2Vitesse setFrame:CGRectMake(48, 149, 180, 21)];
        [_g3Vitesse setFrame:CGRectMake(48, 175, 180, 21)];
        [_g4Vitesse setFrame:CGRectMake(48, 201, 180, 21)];
        [_g5Vitesse setFrame:CGRectMake(48, 227, 180, 21)];
        [_v1Vitesse setFrame:CGRectMake(233, 123, 76, 21)];
        [_v2Vitesse setFrame:CGRectMake(233, 149, 76, 21)];
        [_v3Vitesse setFrame:CGRectMake(233, 175, 76, 21)];
        [_v4Vitesse setFrame:CGRectMake(233, 201, 76, 21)];
        [_v5Vitesse setFrame:CGRectMake(233, 227, 76, 21)];
        [_titreVitesse setFont:[UIFont boldSystemFontOfSize:23]];
        [_classementVitesse setFont:[UIFont italicSystemFontOfSize:16]];
        [_g1Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_g2Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_g3Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_g4Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_g5Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_v1Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_v2Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_v3Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_v4Vitesse setFont:[UIFont systemFontOfSize:13]];
        [_v5Vitesse setFont:[UIFont systemFontOfSize:13]];
        
        [_iconeAltitude setFrame:CGRectMake(25, 265, 60, 60)];
        [_titreAltitude setFrame:CGRectMake(101,288,210,21)];
        [_classementAltitude  setFrame:CGRectMake(33, 336, 165, 21)];
        [_g1Altitude setFrame:CGRectMake(48, 368, 180, 21)];
        [_g2Altitude setFrame:CGRectMake(48, 394, 180, 21)];
        [_g3Altitude setFrame:CGRectMake(48, 420, 180, 21)];
        [_g4Altitude setFrame:CGRectMake(48, 446, 180, 21)];
        [_g5Altitude setFrame:CGRectMake(48, 472, 180, 21)];
        [_v1Altitude setFrame:CGRectMake(233, 368, 76, 21)];
        [_v2Altitude setFrame:CGRectMake(233, 394, 76, 21)];
        [_v3Altitude setFrame:CGRectMake(233, 420, 76, 21)];
        [_v4Altitude setFrame:CGRectMake(233, 446, 76, 21)];
        [_v5Altitude setFrame:CGRectMake(233, 472, 76, 21)];
        [_titreAltitude setFont:[UIFont boldSystemFontOfSize:23]];
        [_classementAltitude setFont:[UIFont italicSystemFontOfSize:16]];
        [_g1Altitude setFont:[UIFont systemFontOfSize:13]];
        [_g2Altitude setFont:[UIFont systemFontOfSize:13]];
        [_g3Altitude setFont:[UIFont systemFontOfSize:13]];
        [_g4Altitude setFont:[UIFont systemFontOfSize:13]];
        [_g5Altitude setFont:[UIFont systemFontOfSize:13]];
        [_v1Altitude setFont:[UIFont systemFontOfSize:13]];
        [_v2Altitude setFont:[UIFont systemFontOfSize:13]];
        [_v3Altitude setFont:[UIFont systemFontOfSize:13]];
        [_v4Altitude setFont:[UIFont systemFontOfSize:13]];
        [_v5Altitude setFont:[UIFont systemFontOfSize:13]];
        
        [_iconeDistance setFrame:CGRectMake(25, 510, 60, 60)];
        [_titreDistance setFrame:CGRectMake(101,533,210,21)];
        [_classementDistance  setFrame:CGRectMake(33, 581, 165, 21)];
        [_g1Distance setFrame:CGRectMake(48, 613, 180, 21)];
        [_g2Distance setFrame:CGRectMake(48, 639, 180, 21)];
        [_g3Distance setFrame:CGRectMake(48, 665, 180, 21)];
        [_g4Distance setFrame:CGRectMake(48, 691, 180, 21)];
        [_g5Distance setFrame:CGRectMake(48, 717, 180, 21)];
        [_v1Distance setFrame:CGRectMake(233, 613, 76, 21)];
        [_v2Distance setFrame:CGRectMake(233, 639, 76, 21)];
        [_v3Distance setFrame:CGRectMake(233, 665, 76, 21)];
        [_v4Distance setFrame:CGRectMake(233, 691, 76, 21)];
        [_v5Distance setFrame:CGRectMake(233, 717, 76, 21)];
        [_titreDistance setFont:[UIFont boldSystemFontOfSize:23]];
        [_classementDistance setFont:[UIFont italicSystemFontOfSize:16]];
        [_g1Distance setFont:[UIFont systemFontOfSize:13]];
        [_g2Distance setFont:[UIFont systemFontOfSize:13]];
        [_g3Distance setFont:[UIFont systemFontOfSize:13]];
        [_g4Distance setFont:[UIFont systemFontOfSize:13]];
        [_g5Distance setFont:[UIFont systemFontOfSize:13]];
        [_v1Distance setFont:[UIFont systemFontOfSize:13]];
        [_v2Distance setFont:[UIFont systemFontOfSize:13]];
        [_v3Distance setFont:[UIFont systemFontOfSize:13]];
        [_v4Distance setFont:[UIFont systemFontOfSize:13]];
        [_v5Distance setFont:[UIFont systemFontOfSize:13]];
        
        [_iconeTemps setFrame:CGRectMake(25, 755, 60, 60)];
        [_titreTemps setFrame:CGRectMake(101,778,210,21)];
        [_classementTemps  setFrame:CGRectMake(33, 826, 165, 21)];
        [_g1Temps setFrame:CGRectMake(48, 858, 180, 21)];
        [_g2Temps setFrame:CGRectMake(48, 884, 180, 21)];
        [_g3Temps setFrame:CGRectMake(48, 910, 180, 21)];
        [_g4Temps setFrame:CGRectMake(48, 936, 180, 21)];
        [_g5Temps setFrame:CGRectMake(48, 962, 180, 21)];
        [_v1Temps setFrame:CGRectMake(233, 858, 76, 21)];
        [_v2Temps setFrame:CGRectMake(233, 884, 76, 21)];
        [_v3Temps setFrame:CGRectMake(233, 910, 76, 21)];
        [_v4Temps setFrame:CGRectMake(233, 936, 76, 21)];
        [_v5Temps setFrame:CGRectMake(233, 962, 76, 21)];
        [_titreTemps setFont:[UIFont boldSystemFontOfSize:23]];
        [_classementTemps setFont:[UIFont italicSystemFontOfSize:16]];
        [_g1Temps setFont:[UIFont systemFontOfSize:13]];
        [_g2Temps setFont:[UIFont systemFontOfSize:13]];
        [_g3Temps setFont:[UIFont systemFontOfSize:13]];
        [_g4Temps setFont:[UIFont systemFontOfSize:13]];
        [_g5Temps setFont:[UIFont systemFontOfSize:13]];
        [_v1Temps setFont:[UIFont systemFontOfSize:13]];
        [_v2Temps setFont:[UIFont systemFontOfSize:13]];
        [_v3Temps setFont:[UIFont systemFontOfSize:13]];
        [_v4Temps setFont:[UIFont systemFontOfSize:13]];
        [_v5Temps setFont:[UIFont systemFontOfSize:13]];
        
        _scrollView.contentSize= CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
    }
    else
    {
        [_iconeDistance setFrame:CGRectMake(32, 529, 63, 63)];
        [_titreDistance setFrame:CGRectMake(116,552,226,21)];
        [_classementDistance setFrame:CGRectMake(41, 603, 203, 21)];
        [_g1Distance setFrame:CGRectMake(56, 635, 214, 21)];
        [_g2Distance setFrame:CGRectMake(56, 661, 214, 21)];
        [_g3Distance setFrame:CGRectMake(56, 687, 214, 21)];
        [_g4Distance setFrame:CGRectMake(56, 713, 214, 21)];
        [_g5Distance setFrame:CGRectMake(56, 739, 214, 21)];
        [_v1Distance setFrame:CGRectMake(273, 635, 75, 21)];
        [_v2Distance setFrame:CGRectMake(273, 661, 75, 21)];
        [_v3Distance setFrame:CGRectMake(273, 687, 75, 21)];
        [_v4Distance setFrame:CGRectMake(273, 713, 75, 21)];
        [_v5Distance setFrame:CGRectMake(273, 739, 75, 21)];
        
        [_iconeTemps setFrame:CGRectMake(32, 785, 63, 63)];
        [_titreTemps setFrame:CGRectMake(116,808,226,21)];
        [_classementTemps setFrame:CGRectMake(41, 859, 203, 21)];
        [_g1Temps setFrame:CGRectMake(56, 891, 214, 21)];
        [_g2Temps setFrame:CGRectMake(56, 917, 214, 21)];
        [_g3Temps setFrame:CGRectMake(56, 943, 214, 21)];
        [_g4Temps setFrame:CGRectMake(56, 969, 214, 21)];
        [_g5Temps setFrame:CGRectMake(56, 995, 214, 21)];
        [_v1Temps setFrame:CGRectMake(273, 891, 75, 21)];
        [_v2Temps setFrame:CGRectMake(273, 917, 75, 21)];
        [_v3Temps setFrame:CGRectMake(273, 943, 75, 21)];
        [_v4Temps setFrame:CGRectMake(273, 969, 75, 21)];
        [_v5Temps setFrame:CGRectMake(273, 995, 75, 21)];
        
        _scrollView.contentSize= CGSizeMake([UIScreen mainScreen].bounds.size.width, 1040);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)trackChange
{
    if(![[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
        if(![[GeolocalisationManager sharedInstance] beginTrack])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Permission refusée"
                                  message:@"L'application ne peut pas accéder à votre localisation car vous ne lui avez pas donné l'autorisation. Si ce n'est pas volontaire, vérifiez vos réglages !" delegate:self
                                  cancelButtonTitle:@"J'ai compris" otherButtonTitles:nil];
            [alert show];
            [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
            [[GeolocalisationManager sharedInstance] endTrack];
        }
    }
    else if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
        [[GeolocalisationManager sharedInstance] endTrack];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actualiser:(id)sender
{
    [self viewDidLoad];
}
@end
