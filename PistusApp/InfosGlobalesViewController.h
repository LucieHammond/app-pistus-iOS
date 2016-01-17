//
//  InfosGlobalesViewController.h
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfosGlobalesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIButton *fleche1;
    UIButton *fleche2;
    UIButton *fleche3;
    UIButton *fleche4;
    UIButton *fleche5;
    UIButton *fleche6;
    int hauteurSection;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
