//
//  RemonteesViewController.h
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemonteesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *remonteesLaFoux;
    NSArray *remonteesPraLoup;
    NSArray *remonteesLeSeignus;
}

@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)actualiser:(id)sender;

@end
