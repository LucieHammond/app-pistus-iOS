//
//  HorairesViewController.m
//  PistusApp
//
//  Created by Lucie on 19/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "HorairesViewController.h"

@interface HorairesViewController ()

@end

@implementation HorairesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Ajustement de la barre de navigation en haut et configuration des icones
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    
    _titre.text = _titreText;
    _ouverture.text = _ouvertureText;
    _fermeture.text = _fermetureText;
    
    // Définition de l'icone
    [_icone setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_typeIcone,@".png"]]];
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
