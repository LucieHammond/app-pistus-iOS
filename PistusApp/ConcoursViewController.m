//
//  ConcoursViewController.m
//  PistusApp
//
//  Created by Lucie on 22/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "ConcoursViewController.h"
#import "GeolocalisationManager.h"

@interface ConcoursViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation ConcoursViewController

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
    
    // Configuration de la TableView
    [_tableView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-65)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView reloadData];
    
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
- (IBAction)actualiser:(id)sender {
    [self viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ActisViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ActisViewCell" owner:nil options:nil] firstObject];
    }
    cell.backgroundColor = [[UIColor alloc] initWithRed:224/225 green:237/225 blue:252/225 alpha:1];
    
    // Créer et placer les imaes
    UIImageView *flecheOr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-or.png"]];
    [flecheOr setFrame:CGRectMake(30,10,50,50)];
    [cell addSubview:flecheOr];
    UIImageView *flecheVermeil = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-vermeil.png"]];
    [flecheVermeil setFrame:CGRectMake(30,65,50,50)];
    [cell addSubview:flecheVermeil];
    UIImageView *flecheArgent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-argent.png"]];
    [flecheArgent setFrame:CGRectMake(30,120,50,50)];
    [cell addSubview:flecheArgent];
    UIImageView *flecheBronze = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-bronze.png"]];
    [flecheBronze setFrame:CGRectMake(30,175,50,50)];
    [cell addSubview:flecheBronze];
    
    // Créer et placer les labels
    NSString *nomGagnant = @"Enguerran Henniart";
    UILabel *gagnant1 = [[UILabel alloc]initWithFrame:CGRectMake(95, 22, 205, 25)];
    UILabel *gagnant2 = [[UILabel alloc]initWithFrame:CGRectMake(95, 77, 205, 25)];
    UILabel *gagnant3 = [[UILabel alloc]initWithFrame:CGRectMake(95, 132, 205, 25)];
    UILabel *gagnant4 = [[UILabel alloc]initWithFrame:CGRectMake(95, 187, 205, 25)];
    [gagnant1 setFont:[UIFont systemFontOfSize:20]];
    [gagnant2 setFont:[UIFont systemFontOfSize:20]];
    [gagnant3 setFont:[UIFont systemFontOfSize:20]];
    [gagnant4 setFont:[UIFont systemFontOfSize:20]];
    gagnant1.text = nomGagnant;
    gagnant2.text = nomGagnant;
    gagnant3.text = nomGagnant;
    gagnant4.text = nomGagnant;
    [cell addSubview:gagnant1];
    [cell addSubview:gagnant2];
    [cell addSubview:gagnant3];
    [cell addSubview:gagnant4];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([UIScreen mainScreen].bounds.size.height<600){
        if(section==0)
            return 45;
        else
            return 30;
    }
    else{
        if(section==0)
            return 50;
        else
            return 35;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    if([UIScreen mainScreen].bounds.size.height<600){
        label.font = [UIFont boldSystemFontOfSize:22];
    }
    else{
        label.font = [UIFont boldSystemFontOfSize:25];
    }
    
    switch(section){
        case 0:
            label.text = @"Yooner";
            break;
        case 1:
            label.text = @"Big Air Bag";
            break;
        case 2:
            label.text = @"Slalom";
            break;
        case 3:
            label.text = @"Curling Humain";
            break;
        case 4:
            label.text = @"Patinoire";
            break;
        case 5:
            label.text = @"Meilleure gamelle";
            break;
        case 6:
            label.text = @"Jeu de piste";
            break;
        case 7:
            label.text = @"Tours d'appartements";
            break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
