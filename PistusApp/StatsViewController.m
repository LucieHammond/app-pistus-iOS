//
//  StatsViewController.m
//  PistusApp
//
//  Created by Lucie on 11/01/2016.
//  Copyright (c) 2016 Lucie. All rights reserved.
//

#import "StatsViewController.h"
#import "GeolocalisationManager.h"

@interface StatsViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    GeolocalisationManager *gm = [GeolocalisationManager sharedInstance];
    
    // Affichage des valeurs des statistiques
        // Vitesse
    if(gm.vitesseActuelle!=-1)
        _vitesseActuelle.text = [NSString stringWithFormat:@"Vitesse actuelle : %.2f km/h",gm.vitesseActuelle*3.6];
    else
        _vitesseActuelle.text = [NSString stringWithFormat:@"Vitesse actuelle : --"];
    _vitesseMax.text = [NSString stringWithFormat:@"Vitesse maximale : %.2f km/h",gm.vitesseMax*3.6];
    if(gm.totalPositions==0)
        _vitesseMoy.text = [NSString stringWithFormat:@"Vitesse moyenne : 0.00 km/h"];
    else
        _vitesseMoy.text = [NSString stringWithFormat:@"Vitesse moyenne : %.2f km/h",gm.vitesseCumulee*3.6/gm.totalPositions];
    
        // Altitude
    if(gm.altitudeActuelle!=-1)
        _altitudeActuelle.text = [NSString stringWithFormat:@"Altitude actuelle : %.f m",gm.altitudeActuelle];
    else
        _altitudeActuelle.text = [NSString stringWithFormat:@"Altitude actuelle : --"];
    if(gm.altitudeMin==5000)
        _altitudeMin.text = [NSString stringWithFormat:@"Altitude minimale : --"];
    else
        _altitudeMin.text = [NSString stringWithFormat:@"Altitude minimale : %.f m",gm.altitudeMin];
    if(gm.altitudeMax==0)
        _altitudeMax.text = [NSString stringWithFormat:@"Altitude maximale : --"];
    else
        _altitudeMax.text = [NSString stringWithFormat:@"Altitude maximale : %.f m",gm.altitudeMax];
    
        // Distance
    _distanceSki.text = [NSString stringWithFormat:@"Distance à ski : %.f m",gm.distanceSki];
    _distanceTot.text = [NSString stringWithFormat:@"Distance totale : %.f m",gm.distanceTot];
    _denivele.text = [NSString stringWithFormat:@"Dénivelé de descente : %.f m",gm.deniveleTotal];
    
        // Temps à ski
    int heure = floor(gm.tempsDeSki/3600);
    int minute = floor((gm.tempsDeSki-heure*3600)/60);
    float seconde = gm.tempsDeSki-heure*3600-minute*60;
    _tempsSki.text = [NSString stringWithFormat:@"Temps de ski : %d h %d min %.f s",heure,minute,seconde];
}

-(void) viewDidLayoutSubviews
{
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
    _scrollView.contentSize= CGSizeMake([UIScreen mainScreen].bounds.size.width, 680);
    [_scrollView setScrollEnabled:YES];
    
    // Repositionnement de l'affichage des statistiques de temps (pas la place dans IB)
    [_iconeTemps setFrame:CGRectMake(32, 555, 66, 66)];
    [_titreTemps setFrame:CGRectMake(117, 576, 115, 34)];
    [_tempsSki setFrame:CGRectMake(47, 634, 230, 21)];
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

@end