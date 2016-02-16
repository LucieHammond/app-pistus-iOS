//
//  InfosGlobalesViewController.m
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "InfosGlobalesViewController.h"
#import "GeolocalisationManager.h"
#import "CustomTableViewCell.h"

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
                return 3;
                break;
            case 4:
                return 4;
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
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
            label.text = @"La sécurité en montagne";
            break;
        case 4:
            label.text = @"Procédure en cas d'accident";
            break;
        case 5:
            label.text = @"Bonne conduite sur la résidence";
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
    _titreInfos = @[@[@"Planning du 5 au 12 mars 2016"],@[@"Domaine skiable",@"Alimentation",@"Hébergement"],@[@"Bar de Glace",@"Yooner",@"Big Air Bag",@"Slalom",@"Luge sur rails",@"Patinoire"],@[@"Les risques des sports d'hiver",@"Quelques règles sur les pistes",@"Conseils et astuces de skieurs"],@[@"Accident sur les pistes",@"Accident en hors piste",@"Premiers soins médicaux",@"Tarifs des secours"],@[@"Respect des biens et des personnes",@"Consommation d'alcool"]];
    NSString *planning = @"";
    NSString *skier =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Ton forfait te sera remis à l’arrivée dans la station après la sortie des cars. Nous te recommandons de le garder précieusement : sans lui, tu ne pourras plus skier ! </br>"
    "</br>"
    "Sache que ce forfait couvre l’intégralité de l’Espace lumière, soit un domaine de 46 remontées mécaniques et 108 pistes qui s’étend sur trois stations :</br>"
    "<p style = \"text-align:left\">"
    "&nbsp;&nbsp; <b>•	&nbsp; Val d’Allos La Foux</b> (où se trouve notre résidence)</br>"
    "&nbsp;&nbsp; <b>•	&nbsp; Val d’Allos Le Seignus</b> (liaison gratuite par navettes possible depuis La Foux)</br>"
    "&nbsp;&nbsp; <b>•	&nbsp; Pra Loup </b>(liaison à ski au niveau du télésiège Agneliers)"
    "</p>"
    "<body />";
    NSString *manger = @"";
    NSString *dormir= @"";
    NSString *barDeGlace =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Véritable point de rassemblement des centraliens après une journée de ski bien remplie, le bar de glace sera l’occasion de te sustenter grâce aux patisseries, brioches, pain de mie, nutella, carembars et autres friandises servies sur un comptoir fait de neige tassée ! Tu pourras également te réchauffer grâce aux fameux vin chaud et chocolat chaud du Pistus, ou te désaltérer au gré de quelques verres de jus de fruit, le tout dans une ambiance très conviviale. Enfin, La Band’ à Joe viendra aussi apporter un peu d’animation et d’ambiance pendant ce goûter quotidien. </br>"
    "</br>"
    "<b>Quand ? : Tous les jours de 16h30 à 18h30</b></br>"
    "<b>Où ? : A proximité de la résidence Plein Sud</b></br>"
    "</br>"
    "<body />";
    NSString *yooner =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Bien que peu connue du grand public, cette activité sportive au nom un peu étrange est pourtant restée gravée dans la mémoire de tous les centraliens qui y ont participé. Le yooner est en fait d’une sorte de luge légère et facile d’utilisation dotée d’un amortisseur pour le confort et d’un patin pour tailler des courbes comme en ski. Avec une assise à 20 cm du sol, cet engin offre des sensations de glisse surprenantes. Tu auras le plaisir de découvrir (ou redécouvrir) cette activité bonne enfant mais aussi terriblement amusante en participant au Yooner contest, course à plusieurs organisée sur la piste du crocus ! </br>"
    "</br>"
    "<b>Quand ? : Mardi de 11h00 à 16h00</b></br>"
    "<b>Où ? : Piste Crocus, à côté du téléski Plateau (cf carte)</b></br>"
    "</br>"
    "<body />";
    NSString *bigAirBag =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Occasion rêvée de s’envoyer en l’air sans subir de conséquences, le Big Air Bag est un bon moyen d’expérimenter la glisse comme tu n’as jamais osé le faire ! Avec ce coussin d’air géant pour te réceptionner, tu pourras tenter sans crainte les sauts les plus périlleux, réaliser les figures les plus complexes, découvrir l'apesanteur, l'adrénaline, la liberté ! Que tu sois débutant ou confirmé, à ski ou à snowboard, le Big Air Bag t’assureras un maximum de sensations en toute sécurité ! </br>"
    "</br>"
    "<b>Quand ? : Indéterminé pour le moment</b></br>"
    "<b>Où ? : Piste Escargot à côté du téléski Plateau (cf carte)</b></br>"
    "</br>"
    "<body />";
    NSString *slalom =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Organisé par l’ESF de Val d’Allos, le slalom que nous vous proposons sera homologué et correspondra à un géant pour l’épreuve de flèche. Tu devras confirmer ta participation la veille afin de te voir attribuer un dossard et de pouvoir concourir. De plus, si tu as pris un cours d’entrainement au slalom en option, celui-ci auras lieu le matin de l’épreuve. Plusieurs lots seront à gagner à l’issue de la course et remis lors du direct NX ! </br>"
    "</br>"
    "<b>Quand ? : Mercredi à 14h00</b></br>"
    "<b>Où ? : Indéterminé pour le moment</b></br>"
    "</br>"
    "<body />";
    NSString *lugeSurRail =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Cette attraction inédite située en haut de la station La Foux ressemble un peu à un roller coaster à la différence qu’il est possible de moduler sa vitesse grâce à des freins latéraux. La piste de luge forme une boucle fermée de 995m comprenant une montée de 330m suivie d’une descente de 665m pour un temps de trajet total compris entre 4 et 7 minutes. Le parcours te réserve une série de virages en épingle, des accélérations toniques, un pont sur la route du Col et une vrille très aérienne, laissant un souvenir impérissable et un sentiment de très grande sécurité. Un tour gratuit te seras offert n’importe quand dans la semaine sur présentation de ton bracelet Pistus. </br>"
    "</br>"
    "<b>Quand ? : N’importe quand, sur présentation de ton bracelet Pistus (un seul tour)</b></br>"
    "<b>Où ? : A proximité du télésiège Marin Pascal, au pied du Col d’Allos (cf carte)</b></br>"
    "</br>"
    "<body />";
    NSString *patinoire =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Si toi aussi tu souhaites expérimenter la glisse sous toutes ses formes, nous t’invitons à passer un moment à la patinoire de Val d’Allos La Foux qui sera privatisée un soir de semaine. Située au cœur de la station, cette patinoire artificielle en plein air de 600m² est l’endroit idéal pour t’amuser avec tes potes en glissant sur la glace dans un décor de montagne. Les patins seront fournis sur place mais il faudra prévoir des vêtements chauds, des gants et un bonnet. </br>"
    "</br>"
    "<b>Quand ? : Lundi soir, de 17h00 à 21h00</b></br>"
    "<b>Où ? : Au centre de la station La Foux d’Allos (cf carte)</b></br>"
    "</br>"
    "<body />";
    NSString *accidentsPistes = @"";
    NSString *accidentsHP = @"";
    NSString *soinsMedicaux = @"";
    NSString *tarifsSecours = @"";
    NSString *conseils = @"";
    NSString *risques = @"";
    NSString *alcool = @"";
    NSString *reglesPistes= @"";
    NSString *reglesRez = @"";
    _infosHTML = @[@[planning],@[skier,manger,dormir],@[barDeGlace,yooner,bigAirBag,slalom,lugeSurRail,patinoire],@[risques,reglesPistes,conseils],@[accidentsPistes,accidentsHP,soinsMedicaux,tarifsSecours],@[reglesRez,alcool]];
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
