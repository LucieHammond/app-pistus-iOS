//
//  ConcoursViewController.m
//  PistusApp
//
//  Created by Lucie on 22/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "ConcoursViewController.h"
#import "GeolocalisationManager.h"
#import "DataManager.h"

@interface ConcoursViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSMutableDictionary *contests;

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
    
    //Getting data
    _contests = [DataManager getData:@"contest"];
    
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
    return [_contests[@"data"] count] + 1;
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
    
    // Remise à 0 de la cellule
    for (UIView *v in [cell subviews])
    {
        if(v.class == UILabel.class || v.class == UIImageView.class)
            [v removeFromSuperview];
    }
    
    cell.backgroundColor = [[UIColor alloc] initWithRed:224/225 green:237/225 blue:252/225 alpha:1];
    
    if(indexPath.section < [_contests[@"data"] count])
    {
        // Créer et placer les imaes
        UIImageView *flecheOr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-or.png"]];
        [flecheOr setFrame:CGRectMake(30,15,45,45)];
        [cell addSubview:flecheOr];
        UIImageView *flecheVermeil = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-vermeil.png"]];
        [flecheVermeil setFrame:CGRectMake(30,68,45,45)];
        [cell addSubview:flecheVermeil];
        UIImageView *flecheArgent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-argent.png"]];
        [flecheArgent setFrame:CGRectMake(30,121,45,45)];
        [cell addSubview:flecheArgent];
        UIImageView *flecheBronze = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fleche-bronze.png"]];
        [flecheBronze setFrame:CGRectMake(30,174,45,45)];
        [cell addSubview:flecheBronze];
        
        // Créer et placer les labels
        NSArray *podium = _contests[@"data"][indexPath.section][@"podium"];
        UILabel *gagnant1 = [[UILabel alloc]initWithFrame:CGRectMake(95, 25, 205, 25)];
        UILabel *gagnant2 = [[UILabel alloc]initWithFrame:CGRectMake(95, 78, 205, 25)];
        UILabel *gagnant3 = [[UILabel alloc]initWithFrame:CGRectMake(95, 131, 205, 25)];
        UILabel *gagnant4 = [[UILabel alloc]initWithFrame:CGRectMake(95, 185, 205, 25)];
        [gagnant1 setFont:[UIFont systemFontOfSize:20]];
        [gagnant2 setFont:[UIFont systemFontOfSize:20]];
        [gagnant3 setFont:[UIFont systemFontOfSize:20]];
        [gagnant4 setFont:[UIFont systemFontOfSize:20]];
        gagnant1.text = @"";
        gagnant2.text = @"";
        gagnant3.text = @"";
        gagnant4.text = @"";
        
        NSLog(@"%@", [podium[0] class]);

        if(![podium[0] isEqual:[NSNull null]] && [podium[0] objectForKey:@"fullName"]) {
            gagnant1.text = podium[0][@"fullName"];
        }
        if(![podium[1] isEqual:[NSNull null]] && [podium[1] objectForKey:@"fullName"]) {
            gagnant2.text = podium[1][@"fullName"];
        }
        if(![podium[2] isEqual:[NSNull null]] && [podium[2] objectForKey:@"fullName"]) {
            gagnant3.text = podium[2][@"fullName"];
        }
        if(![podium[3] isEqual:[NSNull null]] && [podium[3] objectForKey:@"fullName"]) {
            gagnant4.text = podium[3][@"fullName"];
        }
        [cell addSubview:gagnant1];
        [cell addSubview:gagnant2];
        [cell addSubview:gagnant3];
        [cell addSubview:gagnant4];
    }
    else
    {
        UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(37, 15, 140, 60)];
        [score setFont:[UIFont boldSystemFontOfSize:18]];
        score.numberOfLines = 2;
        //TODO
        score.text = @"Score de votre\nappartement :";
        score.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:score];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  < [_contests[@"data"] count])
        return 235;
    else
        return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([UIScreen mainScreen].bounds.size.height<600){
        if(section==0)
            return 45;
        else
            return 25;
    }
    else{
        if(section==0)
            return 50;
        else
            return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label;
    if(section ==0)
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, [UIScreen mainScreen].bounds.size.width, 40)];
    else
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, -13, [UIScreen mainScreen].bounds.size.width, 40)];
    label.textColor = [[UIColor alloc] initWithRed:0.2 green:0.4 blue:0.6 alpha:1];
    
    if([UIScreen mainScreen].bounds.size.height<600){
        label.font = [UIFont boldSystemFontOfSize:22];
    }
    else{
        label.font = [UIFont boldSystemFontOfSize:25];
    }
    
    if (section  < [_contests[@"data"] count]) {
        label.text =_contests[@"data"][section][@"name"];
    }
    else {
        label.text = @"Tours d'appartements";
    }

    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    return view;
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
