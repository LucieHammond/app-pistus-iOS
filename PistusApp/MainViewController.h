//
//  MainViewController.h
//  PistusApp
//
//  Created by Lucie on 03/11/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fondEcran;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;

//Icones
@property (weak, nonatomic) IBOutlet UIButton *carte;
@property (weak, nonatomic) IBOutlet UIButton *infos;
@property (weak, nonatomic) IBOutlet UIButton *stats;
@property (weak, nonatomic) IBOutlet UIButton *troc;
@property (weak, nonatomic) IBOutlet UIButton *concours;
@property (weak, nonatomic) IBOutlet UIButton *meteo;
@property (weak, nonatomic) IBOutlet UIButton *horaires;
@property (weak, nonatomic) IBOutlet UIButton *contact;
@property (weak, nonatomic) IBOutlet UILabel *txtCarte;
@property (weak, nonatomic) IBOutlet UILabel *txtInfos;
@property (weak, nonatomic) IBOutlet UILabel *txtStats;
@property (weak, nonatomic) IBOutlet UILabel *txtConcours;
@property (weak, nonatomic) IBOutlet UILabel *txtMeteo;
@property (weak, nonatomic) IBOutlet UILabel *txtHoraires;
@property (weak, nonatomic) IBOutlet UILabel *txtTroc;
@property (weak, nonatomic) IBOutlet UILabel *txtContact;
@property (weak, nonatomic) IBOutlet UIButton *test;

@end
