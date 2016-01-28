//
//  RemonteesViewController.h
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemonteesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    NSArray *remonteesLaFoux;
    NSArray *remonteesPraLoup;
    NSArray *remonteesLeSeignus;
    NSArray *ouvertureLaFoux;
    NSArray *ouverturePraLoup;
    NSArray *ouvertureLeSeignus;
    NSArray *fermetureLaFoux;
    NSArray *fermeturePraLoup;
    NSArray *fermetureLeSeignus;
}

@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)actualiser:(id)sender;

@end
