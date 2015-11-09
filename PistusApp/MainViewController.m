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
