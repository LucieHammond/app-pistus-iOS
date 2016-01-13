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
    if(hauteur<500)
    {
        
    }
    else if(hauteur<600)
    {
        
    }
    else if(hauteur<700)
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
    }
    else
    {
        
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
