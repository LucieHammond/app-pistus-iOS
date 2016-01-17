//
//  InfoTableViewCell.h
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
{
    UILabel *texte;
    UILabel *titreLabel;
    UIView *delimiteur;
    UILabel *dateLabel;
}

- (int) configUIWithTitle:(NSString*)titre date:(NSString *)date HTML:(NSString*)html;

@end
