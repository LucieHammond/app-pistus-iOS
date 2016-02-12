//
//  MainViewController.m
//  PistusApp
//
//  Created by Lucie on 03/11/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "MainViewController.h"
#import "GeolocalisationManager.h"
#import "CarteViewController.h"

@interface MainViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) viewDidLayoutSubviews {
    
    //Choix de l'image suivant la taille de l'écran
    NSString *image;
    float hauteur = [UIScreen mainScreen].bounds.size.height;
    if(hauteur<500)
        image = @"accueil_4.jpg";
    else if(hauteur<600)
        image = @"accueil_5.jpg";
    else if(hauteur<700)
        image = @"accueil_6.jpg";
    else
        image = @"accueil_6Plus.jpg";
    
    //Placement de l'image en fond d'écran
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    [_fondEcran setFrame:screenSize];
    [_fondEcran setImage:[UIImage imageNamed:image]];
    
    //Ajustement et ajout de la barre de navigation en haut
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    _boutonSatellite = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,33)];
    if(![[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
    }
    else if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:    UIControlStateNormal];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
    [_boutonSatellite addTarget:self action:@selector(trackChange)
               forControlEvents:UIControlEventTouchUpInside];
    
    //Préparation pour repositionnement des icones (qui sont des boutons)
    [_carte setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_infos setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_stats setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_concours setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_horaires setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    //Positionnement des icones en fonction de la taille de l'écran
    if(hauteur<500){
        [_carte setFrame:CGRectMake(27,72,116,108)];
        [_infos setFrame:CGRectMake(178,94,108,69)];
        [_stats setFrame:CGRectMake(43,208,85,89)];
        [_concours setFrame:CGRectMake(172,205,119,95)];
        [_horaires setFrame:CGRectMake(40,347,91,91)];
        [_txtCarte setFrame:CGRectMake(57,169,56,21)];
        [_txtInfos setFrame:CGRectMake(168,169,127,21)];
        [_txtStats setFrame:CGRectMake(33,305,105,21)];
        [_txtConcours setFrame:CGRectMake(183,305,96,21)];
        [_txtHoraires setFrame:CGRectMake(40,441,91,21)];
        
    }
    else if(hauteur<600){
        [_carte setFrame:CGRectMake(27,92,116,108)];
        [_infos setFrame:CGRectMake(178,114,108,69)];
        [_stats setFrame:CGRectMake(43,247,85,89)];
        [_concours setFrame:CGRectMake(172,244,119,95)];
        [_horaires setFrame:CGRectMake(40,405,91,91)];
        [_txtCarte setFrame:CGRectMake(57,189,56,21)];
        [_txtInfos setFrame:CGRectMake(168,189,127,21)];
        [_txtStats setFrame:CGRectMake(33,344,105,21)];
        [_txtConcours setFrame:CGRectMake(183,344,96,21)];
        [_txtHoraires setFrame:CGRectMake(40,499,91,21)];
    }

    else if(hauteur<700){
        [_carte setFrame:CGRectMake(32,97,136,126)];
        [_infos setFrame:CGRectMake(209,123,126,81)];
        [_stats setFrame:CGRectMake(50,282,100,104)];
        [_concours setFrame:CGRectMake(202,278,140,111)];
        [_horaires setFrame:CGRectMake(47,471,107,107)];
        [_txtCarte setFrame:CGRectMake(72,211,56,21)];
        [_txtInfos setFrame:CGRectMake(209,211,127,21)];
        [_txtStats setFrame:CGRectMake(48,397,105,21)];
        [_txtConcours setFrame:CGRectMake(224,397,96,21)];
        [_txtHoraires setFrame:CGRectMake(55,583,91,21)];
    }

    else{
        [_carte setFrame:CGRectMake(33,102,160,149)];
        [_infos setFrame:CGRectMake(237,132,149,95)];
        [_stats setFrame:CGRectMake(55,315,117,122)];
        [_concours setFrame:CGRectMake(230,311,163,130)];
        [_horaires setFrame:CGRectMake(51,533,125,125)];
        [_txtCarte setFrame:CGRectMake(85,237,56,21)];
        [_txtInfos setFrame:CGRectMake(248,237,127,21)];
        [_txtStats setFrame:CGRectMake(61,453,105,21)];
        [_txtConcours setFrame:CGRectMake(263,453,96,21)];
        [_txtHoraires setFrame:CGRectMake(68,668,91,21)];
    }
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

     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
