//
//  ViewController.h
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    int translation;
    BOOL success;
}

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *mdp;
@property (weak, nonatomic) IBOutlet UIButton *valider;

- (IBAction)finDeSaisieID:(id)sender;
- (IBAction)finDeSaisieMDP:(id)sender;
- (IBAction)translationID:(id)sender;
- (IBAction)translationMDP:(id)sender;
- (IBAction)connection:(id)sender;
- (IBAction)deconnection:(id)sender;

@end

