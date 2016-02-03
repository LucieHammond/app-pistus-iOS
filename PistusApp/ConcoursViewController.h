//
//  ConcoursViewController.h
//  PistusApp
//
//  Created by Lucie on 22/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConcoursViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
- (IBAction)actualiser:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
