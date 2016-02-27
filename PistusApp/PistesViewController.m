//
//  PistesViewController.m
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "PistesViewController.h"
#import "GeolocalisationManager.h"
#import "DBManager.h"
#import "DataManager.h"
#import "CustomTableViewCell.h"

@interface PistesViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSMutableDictionary *apiSlopes;
@property (nonatomic,strong) DBManager *dbManager;


@end

@implementation PistesViewController

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
    
    self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];

    
    NSString *queryLF = [NSString stringWithFormat:@"SELECT id, name, type FROM pistesSimple WHERE domain='LF' ORDER BY CASE type WHEN 'verte' THEN 1 WHEN 'bverte' THEN 1 WHEN 'bleue' THEN 2 WHEN 'bbleue' THEN 2 WHEN 'rouge' THEN 3 WHEN 'brouge' THEN 3 WHEN 'noire' THEN 4 WHEN 'bnoire' THEN 4 WHEN 'snowpark' THEN 5 WHEN 'luge' THEN 6 END "];
    NSArray *pistesLF = [[self.dbManager loadDataFromDB:queryLF] copy];
    
    NSString *queryPL = [NSString stringWithFormat:@"SELECT id, name, type FROM pistesSimple WHERE domain='PL' ORDER BY CASE type WHEN 'verte' THEN 1 WHEN 'bverte' THEN 1 WHEN 'bleue' THEN 2 WHEN 'bbleue' THEN 2 WHEN 'rouge' THEN 3 WHEN 'brouge' THEN 3 WHEN 'noire' THEN 4 WHEN 'bnoire' THEN 4 WHEN 'snowpark' THEN 5 WHEN 'luge' THEN 6 END "];
    NSArray *pistesPL = [[self.dbManager loadDataFromDB:queryPL] copy];
    
    NSString *queryLS = [NSString stringWithFormat:@"SELECT id, name, type FROM pistesSimple WHERE domain='LS' ORDER BY CASE type WHEN 'verte' THEN 1 WHEN 'bverte' THEN 1 WHEN 'bleue' THEN 2 WHEN 'bbleue' THEN 2 WHEN 'rouge' THEN 3 WHEN 'brouge' THEN 3 WHEN 'noire' THEN 4 WHEN 'bnoire' THEN 4 WHEN 'snowpark' THEN 5 WHEN 'luge' THEN 6 END "];
    NSArray *pistesLS = [[self.dbManager loadDataFromDB:queryLS] copy];

    pistes = [NSArray arrayWithObjects:pistesLF, pistesPL, pistesLS, nil];
    
    //Getting data
    // On initialise un icone de chargement
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loader.center = self.view.center;
    [self.view addSubview:loader];
    [loader startAnimating];
    
    [DataManager getData:@"slope" completion:^(NSMutableDictionary *dict) {
        _apiSlopes = dict;
        
        [loader performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
        [loader performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        
        closedSlopes = [[NSMutableArray alloc] init];
        NSInteger i;
        for (i=0;i < [_apiSlopes[@"data"] count]; i++) {
            if ([[_apiSlopes[@"data"][i] objectForKey:@"status"]boolValue] == NO) {
                NSString *name = _apiSlopes[@"data"][i][@"name"];
                [closedSlopes addObject:name];
            }
        }
        
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];

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
    return [pistes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pistes[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"idCellPiste";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"idCellPiste" owner:nil options:nil] firstObject];
    }
    NSString *idPiste;
    NSString *nomPiste;
    NSString *nomImage;
    
    NSDictionary *imageFiles = @{ @"verte" : @"pisteVerte.png",
                                  @"bleue" : @"pisteBleue.png",
                                  @"rouge" : @"pisteRouge.png",
                                  @"noire" : @"pisteNoire.png",
                                  @"bverte" : @"boardercrossVert.png",
                                  @"bbleue" : @"boardercrossBleu.png",
                                  @"brouge" : @"boardercrossRouge.png",
                                  @"snowpark" : @"snowpark.png",
                                  @"luge" : @"luge.png",
                                  };
    
    idPiste =pistes[indexPath.section][indexPath.row][0];
    nomPiste = pistes[indexPath.section][indexPath.row][1];
    nomImage = imageFiles[pistes[indexPath.section][indexPath.row][2]];
    
    NSInteger etat = 1;
    
    if([closedSlopes containsObject:idPiste]) {
        etat = 0;
    }
    
    [cell configUIWithTexte:nomPiste image:nomImage etat:etat];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
