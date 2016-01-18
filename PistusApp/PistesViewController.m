//
//  PistesViewController.m
//  PistusApp
//
//  Created by Lucie on 18/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "PistesViewController.h"
#import "GeolocalisationManager.h"
#import "CustomTableViewCell.h"

@interface PistesViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation PistesViewController

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
    
    pistesLaFoux = @[@"Crocus",@"Escargot",@"Gentianes",@"Séolane",@"Alpages",@"Bleuets",@"Chardons",@"Chemin de l'abrau",@"Chemin de plaines",@"Coucous",@"Eterlou",@"Forêt",@"Grand duc",@"Lièvre blanc",@"Myrtilles", @"Quartz",@"Renard", @"Roche aux fées",@"Trans-amazonnienne",@"Agneaux",@"Aigle",@"Arnica",@"Boardercross rouge",@"Chamois", @"Coqs", @"Digitale", @"Ecureuils", @"Edelweiss", @"Fouines",@"Jonquilles",@"Lagopèdes",@"Marmottes",@"Perdrix",@"Serge Gousseault",@"Sources du Verdon",@"Tétras",@"3 Evéchés",@"Buse",@"Couloir",@"Génépy",@"Snow Park (Aiguille)",@"Snow Park (la Chaup)",@"Verdon Express"];
    pistesPraLoup = @[@"Baby",@"Bélière",@"Boardercross vert",@"Clapiers",@"Le Y",@"Sestrières",@"Sorbiers",@"Bergeries", @"Boardercross bleu",@"Cabane du berger",@"Chemin du Bull",@"Clappe",@"Clots",@"Garcine",@"Liaison Costebelle",@"Liaison Lac",@"Liaison Péguieou",@"Marmottes",@"Péguieou",@"Sestières",@"Boardercross rouge", @"Bois", @"Bretelle", @"Chemin des agneliers", @"Colinot",@"Combe air France",@"Costebelle",@"Dalle", @"Fau", @"Fraises", @"Gimette", @"Grande rouge", @"Honoré Bonnet", @"Lac", @"Langail",@"Loups", @"Quartiers", @"Serre de l'homme",@"Stade C.Pascal",@"La Noire", @"Séolane", @"Surf",@"Snow Park"];
    pistesLeSeignus = @[@"L'Adret",@"Stade de neige",@"Champons",@"Crêtes",@"Dahut",@"Font Frede",@"Granges",@"Lys",@"Mélèzes",@"Valdemars",@"Boardercross rouge",@"Gros tapy",@"La Serre",@"Les Vallons",@"Pré long",@"Stade",@"Valcibière",@"Combe Lacroix",@"Goulet",@"La Clappe",@"L'Abreuvoir",@"Thune"];
    couleurs = @[@[@"v",@"v",@"v",@"v",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"r",@"r",@"r",@"br",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"n",@"n",@"n",@"n",@"s",@"s",@"l"],@[@"v",@"v",@"bv",@"v",@"v",@"v",@"v",@"b",@"bb",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"br",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"r",@"n",@"n",@"n",@"s"],@[@"v",@"v",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"b",@"br",@"r",@"r",@"r",@"r",@"r",@"r",@"n",@"n",@"n",@"n",@"n"]];
    
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
            return 43;
            break;
        case 1:
            return 43;
            break;
        case 2:
            return 22;
            break;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"idCellPiste";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"idCellPiste" owner:nil options:nil] firstObject];
    }
    NSString *nomPiste;
    switch (indexPath.section) {
        case 0:
            nomPiste = pistesLaFoux[indexPath.row];
            break;
        case 1:
            nomPiste = pistesPraLoup[indexPath.row];
            break;
        case 2:
            nomPiste = pistesLeSeignus[indexPath.row];
            break;
    }
    
    NSString *nomImage;
    NSString *idImage = couleurs[indexPath.section][indexPath.row];
    if([idImage isEqual:@"v"]){
        nomImage = @"pisteVerte.png";
    }
    else if([idImage isEqual:@"b"]){
        nomImage = @"pisteBleue.png";
    }
    else if([idImage isEqual:@"r"]){
        nomImage = @"pisteRouge.png";
    }
    else if([idImage isEqual:@"n"]){
        nomImage = @"pisteNoire.png";
    }
    else if([idImage isEqual:@"bv"]){
        nomImage = @"boardercrossVert.png";
    }
    else if([idImage isEqual:@"bb"]){
        nomImage = @"boardercrossBleu.png";
    }
    else if([idImage isEqual:@"br"]){
        nomImage = @"boardercrossRouge.png";
    }
    else if([idImage isEqual:@"s"]){
        nomImage = @"snowpark.png";
    }
    else if([idImage isEqual:@"l"]){
        nomImage = @"luge.png";
    }
    
    [cell configUIWithTexte:nomPiste image:nomImage etat:1];
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
