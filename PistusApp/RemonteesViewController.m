//
//  RemonteesViewController.m
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "RemonteesViewController.h"
#import "GeolocalisationManager.h"

@interface RemonteesViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation RemonteesViewController

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
    
    // On initialise les tableaux avec tous les noms de pistes
    remonteesLaFoux = @[@"TS AIGUILLE",@"TS CHAUVETS",@"TK CROUS I",@"TK CROUS II",@"TC LA CHAUP",@"TSD LA CHAUP",@"TK LA TARDEE",@"TS MARIN PASCAL",@"TS OBSERVATOIRE",@"TK PLAINES",@"TK PLATEAU I",@"TK PLATEAU II",@"TS PONT DE L'ABRAU",@"TS POURET",@"TK SIGNAL",@"TK UBAC",@"TS UBAGUETS",@"TELECORDE VERDON",@"TS VESCAL"];
    remonteesPraLoup = @[@"TS AGNELIERS",@"TK BABY",@"TK BELIERE",@"TSD BERGERIES",@"TAPIS-NEIGE CLAPIERS",@"TELEMIX CLAPPE", @"TC COSTEBELLE",@"TK COURTIL I",@"TK COURTIL II",@"TK GIMETTE",@"TK LAC I",@"TK LAC II",@"TC MOLANES",@"TSD6 PEGUIEOU",@"TS QUARTIERS",@"TAPIS-NEIGE SERRE",@"TK SESTRIERES",@"TAPIS-NEIGE SORBIERS",@"TK STADE"];
    remonteesLeSeignus = @[@"TK AUTAPIE I",@"TK AUTAPIE II",@"TSD6 CLOS BERTRAND",@"TS FONT FREDE",@"TS GROS TAPY",@"TC GUINAND",@"TK HONORE CAIRE",@"TK PRE DE LA PORTE"];
    
    // Ajustement de la tableView
    [_tableView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-114)];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 19;
            break;
        case 1:
            return 19;
            break;
        case 2:
            return 8;
            break;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"idCellRemontee";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"idCellRemontee" owner:nil options:nil] firstObject];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = remonteesLaFoux[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = remonteesPraLoup[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = remonteesLeSeignus[indexPath.row];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 32)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
