//
//  HorairesViewController.h
//  PistusApp
//
//  Created by Lucie on 19/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorairesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;

// Texte obtenu de la vue précédende
@property (weak, nonatomic) IBOutlet NSString *titreText;
@property (weak, nonatomic) IBOutlet NSString *ouvertureText;
@property (weak, nonatomic) IBOutlet NSString *fermetureText;
@property (weak, nonatomic) IBOutlet NSString *typeIcone;
@property (weak, nonatomic) IBOutlet NSString *statutText;

// Objects de la vue
@property (weak, nonatomic) IBOutlet UILabel *titre;
@property (weak, nonatomic) IBOutlet UIImageView *icone;
@property (weak, nonatomic) IBOutlet UILabel *statut;
@property (weak, nonatomic) IBOutlet UILabel *ouverture;
@property (weak, nonatomic) IBOutlet UILabel *fermeture;
@end
