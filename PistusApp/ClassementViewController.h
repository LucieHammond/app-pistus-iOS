//
//  ClassementViewController.h
//  PistusApp
//
//  Created by Lucie on 13/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassementViewController : UIViewController
{
    NSString *prenom;
    NSString *nom;
    double performance;
    int classement;
}

@property (weak, nonatomic) IBOutlet UITabBarItem *barItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
- (IBAction)actualiser:(id)sender;

// Vitesse
@property (weak, nonatomic) IBOutlet UIImageView *iconeVitesse;
@property (weak, nonatomic) IBOutlet UILabel *titreVitesse;
@property (weak, nonatomic) IBOutlet UILabel *classementVitesse;
@property (weak, nonatomic) IBOutlet UILabel *g1Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *g2Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *g3Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *g4Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *g5Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *v1Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *v2Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *v3Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *v4Vitesse;
@property (weak, nonatomic) IBOutlet UILabel *v5Vitesse;

// Altitude
@property (weak, nonatomic) IBOutlet UIImageView *iconeAltitude;
@property (weak, nonatomic) IBOutlet UILabel *titreAltitude;
@property (weak, nonatomic) IBOutlet UILabel *classementAltitude;
@property (weak, nonatomic) IBOutlet UILabel *g1Altitude;
@property (weak, nonatomic) IBOutlet UILabel *g2Altitude;
@property (weak, nonatomic) IBOutlet UILabel *g3Altitude;
@property (weak, nonatomic) IBOutlet UILabel *g4Altitude;
@property (weak, nonatomic) IBOutlet UILabel *g5Altitude;
@property (weak, nonatomic) IBOutlet UILabel *v1Altitude;
@property (weak, nonatomic) IBOutlet UILabel *v2Altitude;
@property (weak, nonatomic) IBOutlet UILabel *v3Altitude;
@property (weak, nonatomic) IBOutlet UILabel *v4Altitude;
@property (weak, nonatomic) IBOutlet UILabel *v5Altitude;

// Distance
@property (weak, nonatomic) IBOutlet UIImageView *iconeDistance;
@property (weak, nonatomic) IBOutlet UILabel *titreDistance;
@property (weak, nonatomic) IBOutlet UILabel *classementDistance;
@property (weak, nonatomic) IBOutlet UILabel *g1Distance;
@property (weak, nonatomic) IBOutlet UILabel *g2Distance;
@property (weak, nonatomic) IBOutlet UILabel *g3Distance;
@property (weak, nonatomic) IBOutlet UILabel *g4Distance;
@property (weak, nonatomic) IBOutlet UILabel *g5Distance;
@property (weak, nonatomic) IBOutlet UILabel *v1Distance;
@property (weak, nonatomic) IBOutlet UILabel *v2Distance;
@property (weak, nonatomic) IBOutlet UILabel *v3Distance;
@property (weak, nonatomic) IBOutlet UILabel *v4Distance;
@property (weak, nonatomic) IBOutlet UILabel *v5Distance;

// Temps
@property (weak, nonatomic) IBOutlet UIImageView *iconeTemps;
@property (weak, nonatomic) IBOutlet UILabel *titreTemps;
@property (weak, nonatomic) IBOutlet UILabel *classementTemps;
@property (weak, nonatomic) IBOutlet UILabel *g1Temps;
@property (weak, nonatomic) IBOutlet UILabel *g2Temps;
@property (weak, nonatomic) IBOutlet UILabel *g3Temps;
@property (weak, nonatomic) IBOutlet UILabel *g4Temps;
@property (weak, nonatomic) IBOutlet UILabel *g5Temps;
@property (weak, nonatomic) IBOutlet UILabel *v1Temps;
@property (weak, nonatomic) IBOutlet UILabel *v2Temps;
@property (weak, nonatomic) IBOutlet UILabel *v3Temps;
@property (weak, nonatomic) IBOutlet UILabel *v4Temps;
@property (weak, nonatomic) IBOutlet UILabel *v5Temps;

@end














