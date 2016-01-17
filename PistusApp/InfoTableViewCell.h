//
//  InfoTableViewCell.h
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell

- (void) configUIWithTitle:(NSString*)titre date:(NSDate*)date HTML:(NSString*)html;

@end
