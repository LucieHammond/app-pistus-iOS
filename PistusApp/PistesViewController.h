//
//  PistesViewController.h
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PistesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *pistesLaFoux;
    NSArray *pistesPraLoup;
    NSArray *pistesLeSeignus;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)actualiser:(id)sender;

@end
