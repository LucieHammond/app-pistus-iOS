//
//  GraphTableViewCell.h
//  PistusApp
//
//  Created by Lucie on 16/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphTableViewCell : UITableViewCell
{
    float vitesse5;
    float vitesse6;
    float vitesse7;
    float vitesse8;
    float vitesse9;
    float vitesse10;
    float vitesse11;
    
    float distance5;
    float distance6;
    float distance7;
    float distance8;
    float distance9;
    float distance10;
    float distance11;
    
    float temps5;
    float temps6;
    float temps7;
    float temps8;
    float temps9;
    float temps10;
    float temps11;
}

- (void)configUI:(NSIndexPath *)indexPath;

@end
