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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
- (IBAction)deconnection:(id)sender;

//Icones
@property (weak, nonatomic) IBOutlet UIButton *carte;
@property (weak, nonatomic) IBOutlet UIButton *infos;
@property (weak, nonatomic) IBOutlet UIButton *stats;
@property (weak, nonatomic) IBOutlet UIButton *concours;
@property (weak, nonatomic) IBOutlet UIButton *horaires;
@property (weak, nonatomic) IBOutlet UILabel *txtCarte;
@property (weak, nonatomic) IBOutlet UILabel *txtInfos;
@property (weak, nonatomic) IBOutlet UILabel *txtStats;
@property (weak, nonatomic) IBOutlet UILabel *txtConcours;
@property (weak, nonatomic) IBOutlet UILabel *txtHoraires;

@end
