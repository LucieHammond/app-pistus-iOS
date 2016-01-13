//
//  StatsViewController.h
//  PistusApp
//
//  Created by Lucie on 11/01/2016.
//  Copyright (c) 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconeTemps;
@property (weak, nonatomic) IBOutlet UILabel *titreTemps;
@property (weak, nonatomic) IBOutlet UITabBarItem *barItem;

// Statistiques
@property (weak, nonatomic) IBOutlet UILabel *vitesseActuelle;
@property (weak, nonatomic) IBOutlet UILabel *vitesseMax;
@property (weak, nonatomic) IBOutlet UILabel *vitesseMoy;
@property (weak, nonatomic) IBOutlet UILabel *altitudeActuelle;
@property (weak, nonatomic) IBOutlet UILabel *altitudeMin;
@property (weak, nonatomic) IBOutlet UILabel *altitudeMax;
@property (weak, nonatomic) IBOutlet UILabel *distanceSki;
@property (weak, nonatomic) IBOutlet UILabel *distanceTot;
@property (weak, nonatomic) IBOutlet UILabel *denivele;
@property (weak, nonatomic) IBOutlet UILabel *tempsSki;

@end
