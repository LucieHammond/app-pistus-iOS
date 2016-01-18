//
//  CustomTableViewCell.h
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
{
    // Pour les cellules d'information
    UILabel *texte;
    UILabel *titreLabel;
    UIView *delimiteur;
    UILabel *dateLabel;
    
    // Pour les cellules de pistes (et remontées)
    UILabel *label;
    UIImageView *image;
    UIImageView *ouverture;
}

- (int) configUIWithTitle:(NSString*)titre date:(NSString *)date HTML:(NSString*)html;

- (void) configUIWithTexte:(NSString *)nom image:(NSString *)nomImage etat:(BOOL)ouvert;

@end
