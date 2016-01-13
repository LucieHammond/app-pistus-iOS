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
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    
    //Préparation pour repositionnement des icones (qui sont des boutons)
    [_carte setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_infos setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_stats setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_concours setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_meteo setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_horaires setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_troc setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_contact setTranslatesAutoresizingMaskIntoConstraints:YES];
    
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
        [_carte setFrame:CGRectMake(31,75,113,94)];
        [_infos setFrame:CGRectMake(179,97,108,53)];
        [_stats setFrame:CGRectMake(51,193,73,77)];
        [_concours setFrame:CGRectMake(178,192,112,82)];
        [_meteo setFrame:CGRectMake(44,320,83,87)];
        [_horaires setFrame:CGRectMake(182,320,99,86)];
        [_troc setFrame:CGRectMake(45,439,84,84)];
        [_contact setFrame:CGRectMake(185,436,92,92)];
        [_txtCarte setFrame:CGRectMake(59,154,56,21)];
        [_txtInfos setFrame:CGRectMake(172,154,127,21)];
        [_txtStats setFrame:CGRectMake(35,277,105,21)];
        [_txtConcours setFrame:CGRectMake(185,277,96,21)];
        [_txtMeteo setFrame:CGRectMake(48,409,78,21)];
        [_txtHoraires setFrame:CGRectMake(188,409,91,21)];
        [_txtTroc setFrame:CGRectMake(67,530,40,21)];
        [_txtContact setFrame:CGRectMake(206,530,58,21)];
    }

    else if(hauteur<700){
        [_carte setFrame:CGRectMake(36,88,132,110)];
        [_infos setFrame:CGRectMake(209,113,126,62)];
        [_stats setFrame:CGRectMake(60,226,85,90)];
        [_concours setFrame:CGRectMake(208,224,131,96)];
        [_meteo setFrame:CGRectMake(51,374,97,102)];
        [_horaires setFrame:CGRectMake(212,374,116,101)];
        [_troc setFrame:CGRectMake(53,514,98,98)];
        [_contact setFrame:CGRectMake(216,510,108,108)];
        [_txtCarte setFrame:CGRectMake(69,180,56,21)];
        [_txtInfos setFrame:CGRectMake(201,180,127,21)];
        [_txtStats setFrame:CGRectMake(41,324,105,21)];
        [_txtConcours setFrame:CGRectMake(216,324,96,21)];
        [_txtMeteo setFrame:CGRectMake(56,479,78,21)];
        [_txtHoraires setFrame:CGRectMake(220,479,91,21)];
        [_txtTroc setFrame:CGRectMake(78,620,40,21)];
        [_txtContact setFrame:CGRectMake(241,620,58,21)];
    }

    else{
        [_carte setFrame:CGRectMake(40,97,146,121)];
        [_infos setFrame:CGRectMake(230,125,139,68)];
        [_stats setFrame:CGRectMake(66,249,94,99)];
        [_concours setFrame:CGRectMake(230,247,144,106)];
        [_meteo setFrame:CGRectMake(57,413,107,112)];
        [_horaires setFrame:CGRectMake(234,413,128,111)];
        [_troc setFrame:CGRectMake(58,566,108,108)];
        [_contact setFrame:CGRectMake(239,562,119,119)];
        [_txtCarte setFrame:CGRectMake(76,198,56,21)];
        [_txtInfos setFrame:CGRectMake(222,199,127,21)];
        [_txtStats setFrame:CGRectMake(45,357,105,21)];
        [_txtConcours setFrame:CGRectMake(239,357,96,21)];
        [_txtMeteo setFrame:CGRectMake(62,528,78,21)];
        [_txtHoraires setFrame:CGRectMake(243,528,91,21)];
        [_txtTroc setFrame:CGRectMake(86,684,40,21)];
        [_txtContact setFrame:CGRectMake(266,684,58,21)];
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
