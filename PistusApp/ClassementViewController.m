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
    _scrollView.contentSize= CGSizeMake([UIScreen mainScreen].bounds.size.width, 1040);
    [_scrollView setScrollEnabled:YES];
    
    // Repositionnement des éléments sur la vue en fonction de la taille de l'écran
    float hauteur = [UIScreen mainScreen].bounds.size.height;
    if(hauteur<600)
    {
        [_iconeVitesse setFrame:CGRectMake(25, 20, 60, 60)];
        [_titreVitesse setFrame:CGRectMake(101,43,210,21)];
        [_classementVitesse  setFrame:CGRectMake(33, 91, 165, 21)];
        [_g1Vitesse setFrame:CGRectMake(48, 123, 190, 21)];
        [_g2Vitesse setFrame:CGRectMake(48, 149, 190, 21)];
        [_g3Vitesse setFrame:CGRectMake(48, 175, 190, 21)];
        [_g4Vitesse setFrame:CGRectMake(48, 201, 190, 21)];
        [_g5Vitesse setFrame:CGRectMake(48, 227, 190, 21)];
        [_v1Vitesse setFrame:CGRectMake(243, 123, 73, 21)];
        [_v2Vitesse setFrame:CGRectMake(243, 149, 73, 21)];
        [_v3Vitesse setFrame:CGRectMake(243, 175, 73, 21)];
        [_v4Vitesse setFrame:CGRectMake(243, 201, 73, 21)];
        [_v5Vitesse setFrame:CGRectMake(243, 227, 73, 21)];
        [_titreVitesse setFont:[UIFont systemFontOfSize:23]];
        [_classementVitesse setFont:[UIFont systemFontOfSize:16]];
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
        [_g1Altitude setFrame:CGRectMake(48, 368, 190, 21)];
        [_g2Altitude setFrame:CGRectMake(48, 394, 190, 21)];
        [_g3Altitude setFrame:CGRectMake(48, 420, 190, 21)];
        [_g4Altitude setFrame:CGRectMake(48, 446, 190, 21)];
        [_g5Altitude setFrame:CGRectMake(48, 472, 190, 21)];
        [_v1Altitude setFrame:CGRectMake(243, 368, 73, 21)];
        [_v2Altitude setFrame:CGRectMake(243, 394, 73, 21)];
        [_v3Altitude setFrame:CGRectMake(243, 420, 73, 21)];
        [_v4Altitude setFrame:CGRectMake(243, 446, 73, 21)];
        [_v5Altitude setFrame:CGRectMake(243, 472, 73, 21)];
        [_titreAltitude setFont:[UIFont systemFontOfSize:23]];
        [_classementAltitude setFont:[UIFont systemFontOfSize:16]];
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
        [_g1Distance setFrame:CGRectMake(48, 613, 190, 21)];
        [_g2Distance setFrame:CGRectMake(48, 639, 190, 21)];
        [_g3Distance setFrame:CGRectMake(48, 665, 190, 21)];
        [_g4Distance setFrame:CGRectMake(48, 691, 190, 21)];
        [_g5Distance setFrame:CGRectMake(48,717, 190, 21)];
        [_v1Distance setFrame:CGRectMake(243, 613, 73, 21)];
        [_v2Distance setFrame:CGRectMake(243, 639, 73, 21)];
        [_v3Distance setFrame:CGRectMake(243, 665, 73, 21)];
        [_v4Distance setFrame:CGRectMake(243, 691, 73, 21)];
        [_v5Distance setFrame:CGRectMake(243, 717, 73, 21)];
        [_titreDistance setFont:[UIFont systemFontOfSize:23]];
        [_classementDistance setFont:[UIFont systemFontOfSize:16]];
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
        [_g1Temps setFrame:CGRectMake(48, 858, 190, 21)];
        [_g2Temps setFrame:CGRectMake(48, 884, 190, 21)];
        [_g3Temps setFrame:CGRectMake(48, 910, 190, 21)];
        [_g4Temps setFrame:CGRectMake(48, 936, 190, 21)];
        [_g5Temps setFrame:CGRectMake(48, 962, 190, 21)];
        [_v1Temps setFrame:CGRectMake(243, 858, 73, 21)];
        [_v2Temps setFrame:CGRectMake(243, 884, 73, 21)];
        [_v3Temps setFrame:CGRectMake(243, 910, 73, 21)];
        [_v4Temps setFrame:CGRectMake(243, 936, 73, 21)];
        [_v5Temps setFrame:CGRectMake(243, 962, 73, 21)];
        [_titreTemps setFont:[UIFont systemFontOfSize:23]];
        [_classementTemps setFont:[UIFont systemFontOfSize:16]];
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
        [_classementDistance setFrame:CGRectMake(41, 603, 165, 21)];
        [_g1Distance setFrame:CGRectMake(56, 635, 214, 21)];
        [_g2Distance setFrame:CGRectMake(56, 661, 214, 21)];
        [_g3Distance setFrame:CGRectMake(56, 687, 214, 21)];
        [_g4Distance setFrame:CGRectMake(56, 713, 214, 21)];
        [_g5Distance setFrame:CGRectMake(56, 739, 214, 21)];
        [_v1Distance setFrame:CGRectMake(278, 635, 75, 21)];
        [_v2Distance setFrame:CGRectMake(278, 661, 75, 21)];
        [_v3Distance setFrame:CGRectMake(278, 687, 75, 21)];
        [_v4Distance setFrame:CGRectMake(278, 713, 75, 21)];
        [_v5Distance setFrame:CGRectMake(278, 739, 75, 21)];
        
        [_iconeTemps setFrame:CGRectMake(32, 785, 63, 63)];
        [_titreTemps setFrame:CGRectMake(116,808,226,21)];
        [_classementTemps setFrame:CGRectMake(41, 859, 165, 21)];
        [_g1Temps setFrame:CGRectMake(56, 891, 214, 21)];
        [_g2Temps setFrame:CGRectMake(56, 917, 214, 21)];
        [_g3Temps setFrame:CGRectMake(56, 943, 214, 21)];
        [_g4Temps setFrame:CGRectMake(56, 969, 214, 21)];
        [_g5Temps setFrame:CGRectMake(56, 995, 214, 21)];
        [_v1Temps setFrame:CGRectMake(278, 891, 75, 21)];
        [_v2Temps setFrame:CGRectMake(278, 917, 75, 21)];
        [_v3Temps setFrame:CGRectMake(278, 943, 75, 21)];
        [_v4Temps setFrame:CGRectMake(278, 969, 75, 21)];
        [_v5Temps setFrame:CGRectMake(278, 995, 75, 21)];
        
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

@end
