//
//  GraphsViewController.m
//  PistusApp
//
//  Created by Lucie on 13/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "GraphsViewController.h"
#import "GeolocalisationManager.h"
#import "GraphTableViewCell.h"

@interface GraphsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GraphsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Ajustement de la barre de navigation en haut et configuration des icones
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
    _boutonSatellite = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,33)];
    if(![[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
    }
    else if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
    [_boutonSatellite addTarget:self action:@selector(trackChange)
               forControlEvents:UIControlEventTouchUpInside];
    
    // Ajustement de la tableView
    [_tableView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-114)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView reloadData];
}

-(void) viewDidLayoutSubviews {
    // Redimensionnement du bouton de la barre d'onglets
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)trackChange
{
    if(![[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
        if(![[GeolocalisationManager sharedInstance] beginTrack])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Permission refusée"
                                  message:@"L'application ne peut pas accéder à votre localisation car vous ne lui avez pas donné l'autorisation. Si ce n'est pas volontaire, vérifiez vos réglages !" delegate:self
                                  cancelButtonTitle:@"J'ai compris" otherButtonTitles:nil];
            [alert show];
            [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
            [[GeolocalisationManager sharedInstance] endTrack];
        }
    }
    else if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
        [[GeolocalisationManager sharedInstance] endTrack];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    
    GraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
    }
    [cell configUI:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([UIScreen mainScreen].bounds.size.height<600){
        if(section==0)
            return 85;
        else
            return 70;
    }
    else{
        if(section==0)
            return 80;
        else
            return 65;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 60);
    UIView *header = [[UIView alloc] initWithFrame:frame];
    
    UILabel *label;
    if([UIScreen mainScreen].bounds.size.height<600){
        if(section==0){
            label = [[UILabel alloc]initWithFrame:CGRectMake(105, 35, [UIScreen mainScreen].bounds.size.width -100, 25)];
        }
        else{
            label = [[UILabel alloc]initWithFrame:CGRectMake(105, 20, [UIScreen mainScreen].bounds.size.width -100, 25)];
        }
        label.font = [UIFont boldSystemFontOfSize:22];
    }
    else{
        if(section==0){
            label = [[UILabel alloc]initWithFrame:CGRectMake(112, 38, [UIScreen mainScreen].bounds.size.width -100, 25)];
        }
        else{
            label = [[UILabel alloc]initWithFrame:CGRectMake(112, 23, [UIScreen mainScreen].bounds.size.width -100, 25)];
        }
        label.font = [UIFont boldSystemFontOfSize:25];
    }
    
    switch(section){
        case 0:
            label.text = @"Vitesse moyenne";
            break;
        case 1:
            label.text = @"Distance à ski";
            break;
        case 2:
            label.text = @"Temps de ski";
            break;
    }
    label.textAlignment = NSTextAlignmentLeft;
    [header addSubview:label];
    
    NSString *nomImage;
    switch (section) {
        case 0:
            nomImage = @"speedometer.png";
            break;
        case 1:
            nomImage = @"distance.png";
            break;
        case 2:
            nomImage = @"temps.png";
            break;
    }
    UIImageView *icone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nomImage]];
    if([UIScreen mainScreen].bounds.size.height<600){
        if(section==0){
            [icone setFrame:CGRectMake(28,20,55,55)];
        }
        else{
            [icone setFrame:CGRectMake(28,5,55,55)];
        }
    }
    else{
        if(section==0){
            [icone setFrame:CGRectMake(32,20,60,60)];
        }
        else{
            [icone setFrame:CGRectMake(32,5,60,60)];
        }
    }
    

    [header addSubview:icone];

    return header;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



@end
