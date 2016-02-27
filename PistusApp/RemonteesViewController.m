//
//  RemonteesViewController.m
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "RemonteesViewController.h"
#import "GeolocalisationManager.h"
#import "DBManager.h"
#import "DataManager.h"
#import "HorairesViewController.h"

@interface RemonteesViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSMutableDictionary *apiLifts;
@property (nonatomic,strong) DBManager *dbManager;

@end

@implementation RemonteesViewController

- (void) viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
}

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
    
    // Redimensionnement du bouton de la barre d'onglets
    UIImage *image = [UIImage imageNamed:@"remontee.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(42,35),NO,3);
    [image drawInRect:CGRectMake(0,0,42,35)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setImage:newImage];
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setImageInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    // Redimensionnement des autres boutons de la barre d'onglets
    UIImage *image2 = [UIImage imageNamed:@"pistes.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(39,39),NO,3);
    [image2 drawInRect:CGRectMake(0,0,39,39)];
    UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem] setImage:newImage2];
    [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem]  setImageInsets:UIEdgeInsetsMake(0,-2,0,2)];
    
    
    self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
    
    
    NSString *queryLF = [NSString stringWithFormat:@"SELECT id, name, type, opening, closing FROM remonteesSimple WHERE domain='LF' ORDER BY name"];
    NSArray *remonteesLF = [[self.dbManager loadDataFromDB:queryLF] copy];
    
    NSString *queryPL = [NSString stringWithFormat:@"SELECT id, name, type, opening, closing FROM remonteesSimple WHERE domain='PL' ORDER BY name"];
    NSArray *remonteesPL = [[self.dbManager loadDataFromDB:queryPL] copy];
    
    NSString *queryLS = [NSString stringWithFormat:@"SELECT id, name, type, opening, closing FROM remonteesSimple WHERE domain='LS' ORDER BY name"];
    NSArray *remonteesLS = [[self.dbManager loadDataFromDB:queryLS] copy];
    
    remontees = [NSArray arrayWithObjects:remonteesLF, remonteesPL, remonteesLS, nil];

    //Getting data
    // On initialise un icone de chargement
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loader.center = self.view.center;
    [self.view addSubview:loader];
    [loader startAnimating];
    
    [DataManager getData:@"lift" completion:^(NSMutableDictionary *dict) {
        _apiLifts = dict;
        
        [loader performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
        [loader performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        
        closedLifts = [[NSMutableArray alloc] init];
        comments = [[NSMutableDictionary alloc] init];
        NSInteger i;
        for (i=0;i < [_apiLifts[@"data"] count]; i++) {
            if ([[_apiLifts[@"data"][i] objectForKey:@"status"]boolValue] == NO) {
                NSString *name = _apiLifts[@"data"][i][@"name"];
                NSString *comment = _apiLifts[@"data"][i][@"comment"];
                
                [closedLifts addObject:name];
                [comments setObject:comment forKey:name];
                NSLog(@"%@", comments);
            }
        }
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    
    
    // Ajustement de la tableView
    [_tableView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-114)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView reloadData];
    
    self.navigationController.navigationBarHidden = YES;
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
    NSLog(@"Coucou");
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
    return [remontees count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [remontees[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"idCellRemontee";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"idCellRemontee" owner:nil options:nil] firstObject];
    }
    NSString *ouverture;
    NSString *fermeture;
    
    NSString *idLift = remontees[indexPath.section][indexPath.row][0];
    NSString *type = remontees[indexPath.section][indexPath.row][2];
    NSString *name = remontees[indexPath.section][indexPath.row][1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", type, name];
    ouverture = remontees[indexPath.section][indexPath.row][3];
    fermeture = remontees[indexPath.section][indexPath.row][4];
    
    // On s'occupe du feu de couleur et du sous titre
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateActuelle = [NSDate date];
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:dateActuelle];
    ouverture = [NSString stringWithFormat:@"%ld-%ld-%ld %@",(long)[composants year],(long)[composants month],(long)[composants day],ouverture];
    fermeture = [NSString stringWithFormat:@"%ld-%ld-%ld %@",(long)[composants year],(long)[composants month],(long)[composants day],fermeture];
    NSDate *heureOuverture = [df dateFromString:ouverture];
    NSDate *heureFermeture = [df dateFromString:fermeture];
    
    NSString *nomImage;
    
    if([closedLifts containsObject:idLift]) {
        cell.detailTextLabel.text = comments[idLift];
        nomImage = @"feuRouge.png";
    }
    else {
        BOOL ouvert;
        if([dateActuelle compare: heureOuverture]== NSOrderedAscending)
        {
            ouvert = 0;
            NSTimeInterval intervalle = [heureOuverture timeIntervalSinceNow];
            int heure = (int) intervalle/3600;
            int minute = (int) (intervalle - heure*3600)/60;
            if(heure!=0)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Ouverture dans %ih %imin",heure,minute];
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Ouverture dans %imin",minute];
        }
        else if([dateActuelle compare: heureFermeture]==NSOrderedDescending)
        {
            ouvert = 0;
            NSTimeInterval intervalle = [heureOuverture timeIntervalSinceNow]+86400;
            int heure = (int) intervalle/3600;
            int minute = (int) (intervalle - heure*3600)/60;
            if(heure!=0)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Ouverture dans %ih %imin",heure,minute];
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Ouverture dans %imin",minute];
        }
        else
        {
            ouvert = 1;
            NSTimeInterval intervalle = [heureFermeture timeIntervalSinceNow];
            int heure = (int) intervalle/3600;
            int minute = (int) (intervalle - heure*3600)/60;
            if(heure!=0)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Fermeture dans %ih %imin",heure,minute];
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Fermeture dans %imin",minute];
        }
        nomImage = ouvert?@"feuVert.png":@"feuOrange.png";
    }

    
    UIImageView *feu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nomImage]];
    [feu setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55,16,15,15)];
    [cell addSubview:feu];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:23];
    label.textColor = [UIColor colorWithRed:50.0/255.0 green:93.0/255.0 blue:171.0/255.0 alpha:1];
    switch(section){
        case 0:
            label.text = @"Val d'Allos La Foux";
            break;
        case 1:
            label.text = @"Pra Loup";
            break;
        case 2:
            label.text = @"Val d'Allos Le Seignus";
            break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        HorairesViewController *horairesVC = (HorairesViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        
        horairesVC.titreText = [remontees[indexPath.section] objectAtIndex:indexPath.row][1];
        horairesVC.ouvertureText = [remontees[indexPath.section] objectAtIndex:indexPath.row][3];
        horairesVC.fermetureText = [remontees[indexPath.section] objectAtIndex:indexPath.row][4];

        horairesVC.typeIcone = [remontees[indexPath.section] objectAtIndex:indexPath.row][2];
        
        NSString *idLift = remontees[indexPath.section][indexPath.row][0];
        if([closedLifts containsObject:idLift]) {
            NSLog(@"bite");
            horairesVC.statutText = comments[idLift];
        }
        else{
            horairesVC.statutText = @"En fonctionnement";
        }
    }
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
