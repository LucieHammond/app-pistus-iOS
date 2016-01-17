//
//  InfosGlobalesViewController.m
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "InfosGlobalesViewController.h"
#import "GeolocalisationManager.h"
#import "InfoTableViewCell.h"

@interface InfosGlobalesViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSMutableArray *sectionOpen;
@property (nonatomic,strong) NSArray *infosHTML;
@property (nonatomic,strong) NSArray *titreInfos;

@end

@implementation InfosGlobalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    hauteurSection = 0;
    
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
    
    // Initialisation de sectionOpen : au départ aucune section n'est ouverte
    _sectionOpen = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",nil];
    
    [self remplirInfos];
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_sectionOpen[section] isEqual:@"1"]){
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 3;
                break;
            case 2:
                return 6;
                break;
            case 3:
                return 4;
                break;
            case 4:
                return 3;
                break;
            case 5:
                return 2;
                break;
            default:
                return 0;
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
    }
    NSString *titre = _titreInfos[indexPath.section][indexPath.row];
    NSString *html = _infosHTML[indexPath.section][indexPath.row];
    hauteurSection = [cell configUIWithTitle:titre date:nil HTML:html];
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hauteurSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 52);
    UIView *header = [[UIView alloc] initWithFrame:frame];
    header.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width -40, 50)];
    label.font = [UIFont systemFontOfSize:17];
    switch(section){
        case 0:
            label.text = @"Programme de la semaine";
            break;
        case 1:
            label.text = @"Infos pratiques";
            break;
        case 2:
            label.text = @"Présentation des activités";
            break;
        case 3:
            label.text = @"Procédure en cas d'accident";
            break;
        case 4:
            label.text = @"Conseils, avertissements, risques";
            break;
        case 5:
            label.text = @"Quelques règles à respecter";
            break;
    }
    [header addSubview:label];
    
    NSString *nomImage;
    if([_sectionOpen[section] isEqualToString:@"0"]) {
        nomImage = @"flecheDroite.png";
    }
    else{
        nomImage = @"flecheBas.png";
    }
    UIButton *fleche = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-33,15,20,20)];
    [fleche setImage:[UIImage imageNamed:nomImage] forState:UIControlStateNormal];
    if([_sectionOpen[section] isEqualToString:@"0"]) {
        [fleche addTarget:self action:@selector(deployer:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [fleche addTarget:self action:@selector(reduire:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    switch (section) {
        case 0:
            fleche1=fleche;
            break;
        case 1:
            fleche2=fleche;
            break;
        case 2:
            fleche3=fleche;
            break;
        case 3:
            fleche4=fleche;
            break;
        case 4:
            fleche5=fleche;
            break;
        case 5:
            fleche6=fleche;
            break;
    }
    [header addSubview:fleche];
    
    UIView *delimiteur = [[UIView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width , 2)];
    delimiteur.backgroundColor = [UIColor grayColor];
    [header addSubview:delimiteur];
    
    return header;
}

-(void) deployer:(UIButton*)fleche{
    if(fleche==fleche1)
        _sectionOpen[0]=@"1";
    else if(fleche==fleche2)
        _sectionOpen[1]=@"1";
    else if(fleche==fleche3)
        _sectionOpen[2]=@"1";
    else if(fleche==fleche4)
        _sectionOpen[3]=@"1";
    else if(fleche==fleche5)
        _sectionOpen[4]=@"1";
    else if(fleche==fleche6)
        _sectionOpen[5]=@"1";
    [_tableView reloadData];
}

-(void) reduire:(UIButton*)fleche{
    if(fleche==fleche1)
        _sectionOpen[0]=@"0";
    else if(fleche==fleche2)
        _sectionOpen[1]=@"0";
    else if(fleche==fleche3)
        _sectionOpen[2]=@"0";
    else if(fleche==fleche4)
        _sectionOpen[3]=@"0";
    else if(fleche==fleche5)
        _sectionOpen[4]=@"0";
    else if(fleche==fleche6)
        _sectionOpen[5]=@"0";
    [_tableView reloadData];
}

-(void) remplirInfos{
    _titreInfos = @[@[@"Planning du 5 au 12 mars 2016"],@[@"Domaine skiable",@"Alimentation",@"Hébergement"],@[@"Bar de Glace",@"Yooner",@"Big Air Bag",@"Slalom",@"Luge sur rails",@"Patinoire"],@[@"Accident sur les pistes",@"Accident en hors piste",@"Premiers soins médicaux",@"Tarifs des secours"],@[@"Conseils et astuces de skieurs",@"Les risques en montagne",@"Consommation d'alcool"],@[@"Bonne conduite sur les pistes",@"Respect des biens et des personnes"]];
    NSString *planning = @"";
    NSString *skier =
    @"<body style = \"font-size:13px\">"
    "   <b>Skier :</b> <br  />"
    "Sache que ton forfait couvre le domaine des Sybelles en entier, pas seulement St‐Sorlin ! Donc n’hésite pas à en profiter, ça fait beaucoup de pistes ! <br  />"
    "<br  />"
    "    <b>Manger :</b> <br  />"
    "Tous les matins, le Piston Ski organise une livraison de baguettes, pains au chocolat et croissants à l’accueil entre 7h45 et 8h30 précises ! Ne manque pas ton petit déjeuner ! Ta commande sera reconduite d’un jour sur l’autre si tu ne précises rien. Si tu veux changer, signale-le un matin au staff lors de la distribution, cela prendra effet le lendemain. <br  />"
    "La baguette, le croissant et le pain au chocolat sont tous facturés 0,95€. Nous te demanderons de régler la boulangerie de toute la semaine le vendredi soir 13 mars, par chèque. <br  />"
    "Si le contenu des packs bouffe ne te suffit pas, il y a un Sherpa en bas de la résidence, en face de l’office de tourisme. <br  />"
    "Réductions sur présentation du bracelet Odyssée: -10% sur les cartes du Self du Chalet du moulin, du Barock et du Choucas, entre autres. <br  />"
    "<br />"
    "<body />";
    NSString *manger = @"";
    NSString *dormir= @"";
    NSString *barDeGlace = @"";
    NSString *yooner = @"";
    NSString *bigAirBag = @"";
    NSString *slalom = @"";
    NSString *lugeSurRail = @"";
    NSString *patinoire = @"";
    NSString *accidentsPistes = @"";
    NSString *accidentsHP = @"";
    NSString *soinsMedicaux = @"";
    NSString *tarifsSecours = @"";
    NSString *conseils = @"";
    NSString *risques = @"";
    NSString *alcool = @"";
    NSString *reglesPistes= @"";
    NSString *reglesRez = @"";
    _infosHTML = @[@[planning],@[skier,manger,dormir],@[barDeGlace,yooner,bigAirBag,slalom,lugeSurRail,patinoire],@[accidentsPistes,accidentsHP,soinsMedicaux,tarifsSecours],@[conseils,risques,alcool],@[reglesPistes,reglesRez]];
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
