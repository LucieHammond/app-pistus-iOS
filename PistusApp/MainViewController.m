//
//  MainViewController.m
//  PistusApp
//
//  Created by Lucie on 03/11/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
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
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 50)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    
    //Positionnement des icones en fonction de la taille de l'écran
    if(hauteur<500){
        [_carte setFrame:CGRectMake(42,75,108,90)];
        [_infos setFrame:CGRectMake(174,95,104,52)];
        [_stats setFrame:CGRectMake(22,197,69,71)];
        [_troc setFrame:CGRectMake(123,196,74,74)];
        [_concours setFrame:CGRectMake(212,194,107,77)];
        [_meteo setFrame:CGRectMake(20,332,72,74)];
        [_horaires setFrame:CGRectMake(117,330,90,78)];
        [_contact setFrame:CGRectMake(224,327,81,81)];
        [_txtCarte setFrame:CGRectMake(70,150,56,21)];
        [_txtInfos setFrame:CGRectMake(163,150,127,21)];
        [_txtStats setFrame:CGRectMake(4,277,105,21)];
        [_txtTroc setFrame:CGRectMake(139,277,40,21)];
        [_txtConcours setFrame:CGRectMake(217,277,96,21)];
        [_txtMeteo setFrame:CGRectMake(17,413,77,21)];
        [_txtHoraires setFrame:CGRectMake(117,413,91,21)];
        [_txtContact setFrame:CGRectMake(237,413,58,21)];
        
    }
    else if(hauteur<600){
        [_carte setFrame:CGRectMake(18,79,133,110)];
        [_infos setFrame:CGRectMake(173,98,126,63)];
        [_stats setFrame:CGRectMake(33,224,102,83)];
        [_concours setFrame:CGRectMake(162,215,149,101)];
        [_meteo setFrame:CGRectMake(30,343,361,89)];
        [_horaires setFrame:CGRectMake(169,356,135,99)];
    }

    else if(hauteur<700){
        [_carte setFrame:CGRectMake(18,71,133,110)];
        [_infos setFrame:CGRectMake(173,98,126,63)];
        [_stats setFrame:CGRectMake(33,211,102,83)];
        [_concours setFrame:CGRectMake(162,202,149,101)];
        [_meteo setFrame:CGRectMake(30,343,109,89)];
        [_horaires setFrame:CGRectMake(169,338,135,99)];
    }

    else{
        [_carte setFrame:CGRectMake(18,71,133,110)];
        [_infos setFrame:CGRectMake(173,98,126,63)];
        [_stats setFrame:CGRectMake(33,211,102,83)];
        [_concours setFrame:CGRectMake(162,202,149,101)];
        [_meteo setFrame:CGRectMake(30,343,109,89)];
        [_horaires setFrame:CGRectMake(169,338,135,99)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
