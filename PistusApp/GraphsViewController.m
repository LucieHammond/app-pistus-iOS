//
//  GraphsViewController.m
//  PistusApp
//
//  Created by Lucie on 13/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "GraphsViewController.h"
#import "GeolocalisationManager.h"

@interface GraphsViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation GraphsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
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
}

-(void) viewDidLayoutSubviews {
    // Redimensionnement du bouton de la barre d'onglets
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