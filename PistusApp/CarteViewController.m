//
//  CarteViewController.m
//  PistusApp
//
//  Created by Lucie on 25/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "CarteViewController.h"
#import "DBManager.h"
#import "GeolocalisationManager.h"

@interface CarteViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) DBManager *dbManager;

@end

@implementation CarteViewController
{
    NSArray *participants;
    NSArray *resultatsRecherche;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainSegue"]) {
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _scrollView.delegate=self;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=8.0;
    _bulle.hidden=true;
    NSLog(@"View did load");

    // Afficher la barre de recherche
    _searchButton.target = self;
    _searchButton.action = @selector(afficherBarRecherche);
    
    //Ajustement du texte qui s'affiche en cas de localisation hors de la station
    _texteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
    _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
    [self.view insertSubview:_fondTexteDistance aboveSubview:_scrollView];
    [self.view insertSubview:_texteDistance aboveSubview:_fondTexteDistance];
    _texteDistance.text=@"";
    _fondTexteDistance.hidden=true;
    
    // Ajout du marqueur utilisateur
    if(marqueur !=nil){
        [marqueur removeFromSuperview];
        marqueur=nil;
    }
    marqueur = [[UIButton alloc] initWithFrame:CGRectMake(0,0,16,16)];
    [marqueur setImage:[UIImage imageNamed:@"marker2.png"] forState:UIControlStateNormal];
    [marqueur addTarget:self action:@selector(afficherDetailsPourMarqueur:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:marqueur aboveSubview:_scrollView];
    marqueur.hidden = true;
    
    // Initialisation du tableau Participants (à remplacer par une recherche dans la BDD ?)
    participants = @[@"Enguerran Henniart",@"Lucie Hammond",@"Tom Brendlé",@"Alexis Filipozzi",@"Martin Ramette",@"Maxime Reiz",@"Joris Mancini",@"Manon Leger",@"Hélène Chambrette",@"Solène Duchamp",@"Martin Guillier",@"Sofia Bonnetaud",@"Alphe Fournier",@"Raphaël Bizmut",@"Nicolas Vo Van",@"Maxime Gardet",@"Olivier Agier",@"Robin Schwob",@"Remi Schneider",@"Roxane Letournel"];
    
    if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        if([GeolocalisationManager sharedInstance].pisteProche!=nil)
        {
            double distance = [GeolocalisationManager sharedInstance].distanceStation;
            NSString *pisteProche = [GeolocalisationManager sharedInstance].pisteProche;
            if([GeolocalisationManager sharedInstance].enStation)
            {
                _texteDistance.text=[NSString stringWithFormat:@"%@%.2f%@%@",@"Impossible de vous localiser. \nVous vous trouvez à ",distance,@" m de la station La Foux d'Allos : ", pisteProche];
                [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+15, _texteDistance.frame.size.height-5)];
            }
            else
            {
                self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
                NSString *query = [NSString stringWithFormat:@"SELECT est_remontee from pistes where id = '%@';",[GeolocalisationManager sharedInstance].dernierePiste];
                BOOL remontee = [[[[self.dbManager loadDataFromDB:query] objectAtIndex:0] objectAtIndex:0]boolValue];
                if(!remontee)
                    _texteDistance.text=[NSString stringWithFormat:@"%@%.0f%@%@%@",@"Vous vous trouvez à ",distance,@"m de la piste la plus proche : ",pisteProche,@". Attention, la pratique du hors piste est à vos risques et périls"];
                else
                    _texteDistance.text=[NSString stringWithFormat:@"%@%.0f%@%@%@",@"Vous vous trouvez à ",distance,@"m de la remontee mécanique : ",pisteProche,@". Attention, la pratique du hors piste est à vos risques et périls"];
                [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+20, _texteDistance.frame.size.height+10)];
            }
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
            NSLog(@"piste proche");
        }
        else if([GeolocalisationManager sharedInstance].distanceStation>0)
        {
            double distance = [GeolocalisationManager sharedInstance].distanceStation/1000;
            _texteDistance.text=[NSString stringWithFormat:@"%@%.2f%@",@"Impossible de vous localiser sur la carte. \nVous vous trouvez à ",distance,@" km de la station Val d'Allos"];
            [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+15, _texteDistance.frame.size.height-5)];
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
            NSLog(@"très loin");
        }
        else if([GeolocalisationManager sharedInstance].distanceStation==-1)
        {
            _texteDistance.text=[NSString stringWithFormat:@"Impossible de vous localiser sur le domaine skiable. Vous vous trouvez à plus de 100m des pistes"];
            [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+20, _texteDistance.frame.size.height-5)];
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
            NSLog(@"plus de 100 m");
        }
        else
        {
            // Affichage du marqueur de position
            int x = [GeolocalisationManager sharedInstance].dernierX;
            int y = [GeolocalisationManager sharedInstance].dernierY;
            float X = _scrollView.contentSize.width/7452*x - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
            float Y = _scrollView.contentSize.height/3174*y - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
            marqueur.center = CGPointMake(X,Y);
            marqueur.hidden = false;
            NSLog(@"touché");
        }
    }
    if(nbAppels==1)
        _apresClic = true;
}

-(void) viewDidLayoutSubviews{
    NSLog(@"View did layout subviews");
    if(_apresClic!=true)
    {
        //Ajustement de la barre de navigation en haut et configuration des icones
        [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
        [_topBande setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 20)];
        self.navigationController.navigationBarHidden=true;
        [self.view insertSubview:_topBande aboveSubview:_barre];
        _boutonSatellite = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,33)];
        if(![[GeolocalisationManager sharedInstance] trackAccept])
        {
            [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
        }
        else if([[GeolocalisationManager sharedInstance] trackAccept])
        {
            [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:    UIControlStateNormal];
        }
        [_trackAcceptButton setCustomView:_boutonSatellite];
        [_boutonSatellite addTarget:self action:@selector(trackChange)
         forControlEvents:UIControlEventTouchUpInside];
        
        // Configuration du scrollView pour pouvoir se déplacer sur le plan
        [_scrollView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 65)];
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plan Val d'Allos Official corrigé.jpg"]];
        [imageView setFrame:CGRectMake(0,0,_scrollView.frame.size.height*imageView.frame.size.width/imageView.frame.size.height,_scrollView.frame.size.height)];
        [_scrollView addSubview:imageView];
        [_scrollView setContentOffset:CGPointMake((imageView.frame.size.width-_scrollView.frame.size.width)/2,0)];
        [_scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
        [_scrollView setBouncesZoom:NO];
        
        // Ajout de marqueurs pour les lieux importants
        float X = _scrollView.contentSize.width/7452*3424 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        float Y = _scrollView.contentSize.height/3174*1710 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        _etoile_Rez.center = CGPointMake(X,Y);
        X = _scrollView.contentSize.width/7452*3195 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        Y = _scrollView.contentSize.height/3174*2115 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        _etoile_Pat.center = CGPointMake(X,Y);
        X = _scrollView.contentSize.width/7452*3742 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        Y = _scrollView.contentSize.height/3174*1820 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        _etoile_Luge.center = CGPointMake(X,Y);
        X = _scrollView.contentSize.width/7452*3265 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        Y = _scrollView.contentSize.height/3174*1995 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        _etoile_ESF.center = CGPointMake(X,Y);
        X = _scrollView.contentSize.width/7452*3010 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        Y = _scrollView.contentSize.height/3174*1650 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        _etoile_BAB.center = CGPointMake(X,Y);
    
        [_etoile_Rez addTarget:self action:@selector(afficherDetailsPourMarqueur:)
         forControlEvents:UIControlEventTouchUpInside];
        [_etoile_Pat addTarget:self action:@selector(afficherDetailsPourMarqueur:)
          forControlEvents:UIControlEventTouchUpInside];
        [_etoile_Luge addTarget:self action:@selector(afficherDetailsPourMarqueur:)
          forControlEvents:UIControlEventTouchUpInside];
        [_etoile_ESF addTarget:self action:@selector(afficherDetailsPourMarqueur:)
               forControlEvents:UIControlEventTouchUpInside];
        [_etoile_BAB addTarget:self action:@selector(afficherDetailsPourMarqueur:)
               forControlEvents:UIControlEventTouchUpInside];
        
        // Ajout du bouton pour recentrer sur la position de l'utilisateur
        UIButton *ciblage = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height*7/10,47,47)];
        [ciblage setImage:[UIImage imageNamed:@"ciblage.png"] forState:UIControlStateNormal];
        ciblage.alpha=0.5;
        [self.view insertSubview:ciblage aboveSubview:_etoile_Luge];
        [ciblage addTarget:self action:@selector(ciblerPosition)
          forControlEvents:UIControlEventTouchUpInside];
        
        // Cacher la barre de recherche
        if(rechercheActivee!=true)
            _searchBar.hidden = true;
        id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    
        [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
        [barButtonAppearanceInSearchBar setTitle:@"Annuler"];
        
        // Initialisation de la bulle sans l'afficher
        _pateBulle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pate_bulle.png"]];
        [self.view insertSubview:_pateBulle aboveSubview:imageView];
        _pateBulle.hidden=true;
        
        _titre = [[UILabel alloc] init];
        _titre.font=[UIFont boldSystemFontOfSize:16.0];;
        [self.view insertSubview:_titre aboveSubview:_pateBulle];
        _titre.hidden=true;
        
        _nomPiste = [[UILabel alloc] init];
        _nomPiste.font=[UIFont systemFontOfSize:11.0];
        [self.view insertSubview:_nomPiste aboveSubview:_titre];
        _nomPiste.hidden=true;
        
        _derniereDate = [[UILabel alloc]init];
        _derniereDate.font=[UIFont systemFontOfSize:9.0 weight:UIFontWeightLight];
        [self.view insertSubview:_derniereDate aboveSubview:_nomPiste];
        _derniereDate.hidden=true;
        
        _bulle = [[UIView alloc] init];
        [_bulle setBackgroundColor:[UIColor whiteColor]];
        [self.view insertSubview:_bulle belowSubview:_titre];
        _bulle.hidden=true;
        
        NSLog(@"1");
        nbAppels = 1;
        [self viewDidLoad];
    }
    else{
        NSLog(@"2");
        _apresClic=false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self->imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self->imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self->imageView.frame = contentsFrame;
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

-(void)afficherDetailsPourMarqueur:(UIButton *)sender
{
    _apresClic = true;
    
    // Pate de la bulle
    [_pateBulle setFrame: CGRectMake(sender.center.x-11,sender.frame.origin.y-10,22,10)];
    _pateBulle.hidden=false;
    if(sender==marqueur)
    {
        //Titre
        _titre.text=@"Vous êtes ici";
        [_titre sizeToFit];
        _titre.center=CGPointMake(sender.center.x,sender.frame.origin.y-38);
        _titre.hidden=false;
        
        // Nom de la piste
        self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
        NSString *query = [NSString stringWithFormat:@"select nom from pistes where id='%@'",[GeolocalisationManager sharedInstance].dernierePiste];
        _nomPiste.text=[self.dbManager loadDataFromDB:query][0][0];
        [_nomPiste sizeToFit];
        _nomPiste.center=CGPointMake(sender.center.x,sender.frame.origin.y-21);
        _nomPiste.hidden=false;
        
        // Fond de la bulle
        [_bulle setFrame: CGRectMake(0,0,MAX(_nomPiste.frame.size.width+15,_titre.frame.size.width+15),40)];
        _bulle.center = CGPointMake(sender.center.x, sender.frame.origin.y-30);
        
        // Repositionnement du message
        if(_titre.frame.origin.x<_nomPiste.frame.origin.x)
            [_nomPiste setFrame:CGRectMake(_titre.frame.origin.x,_nomPiste.frame.origin.y,_nomPiste.frame.size.width,_nomPiste.frame.size.height)];
        else
            [_titre setFrame:CGRectMake(_nomPiste.frame.origin.x,_titre.frame.origin.y,_titre.frame.size.width,_titre.frame.size.height)];
    }
    else
    {
        // Titre
        if(sender==_etoile_Rez)
            _titre.text=@"Résidence Plein Sud";
        else if(sender==_etoile_Pat)
            _titre.text=@"Patinoire";
        else if(sender==_etoile_Luge)
            _titre.text=@"Luge sur rails";
        else if(sender==_etoile_ESF)
            _titre.text=@"Départ cours ESF";
        else if(sender==_etoile_BAB)
            _titre.text=@"Big Air Bag";
        [_titre sizeToFit];
        _titre.center=CGPointMake(sender.center.x,sender.frame.origin.y-20);
        _titre.hidden=false;
        
        // Fond de la bulle
        [_bulle setFrame: CGRectMake(0,0,_titre.frame.size.width+13,23)];
        _bulle.center = CGPointMake(sender.center.x, sender.frame.origin.y-20);
    }
    _bulle.hidden=false;
    marqueurBulle=sender;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(effacerBulle)];
    [_scrollView addGestureRecognizer:tapGesture];
}

-(void) effacerBulle
{
    _pateBulle.hidden=true;
    _titre.hidden=true;
    _nomPiste.hidden=true;
    _derniereDate.hidden=true;
    _bulle.hidden=true;
}

-(void) afficherBarRecherche{
    if(_searchBar.hidden == true)
    {
        [UIView transitionWithView:self.searchBar
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _searchBar.hidden = false;
                        } completion:nil];
        rechercheActivee = true;
    }
    else
    {
        [UIView transitionWithView:self.searchBar
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _searchBar.hidden = true;
                        } completion:nil];
        rechercheActivee = false;
    }
}

-(void)ciblerPosition
{
    if(marqueur.hidden==false)
    {
        int x = [GeolocalisationManager sharedInstance].dernierX;
        int y = [GeolocalisationManager sharedInstance].dernierY;
        float X = _scrollView.contentSize.width/7452*x;
        float Y = _scrollView.contentSize.height/3174*y;
        float largeur = _scrollView.frame.size.width;
        float hauteur = _scrollView.frame.size.height;
        [_scrollView scrollRectToVisible:CGRectMake(X-largeur/2,Y-hauteur/2,largeur,hauteur) animated:true];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Repositionnement du marqueur
    if(marqueur.hidden==false)
    {
        int x = [GeolocalisationManager sharedInstance].dernierX;
        int y = [GeolocalisationManager sharedInstance].dernierY;
        float X = _scrollView.contentSize.width/7452*x - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
        float Y = _scrollView.contentSize.height/3174*y - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
        marqueur.center = CGPointMake(X,Y);
    }
    
    float X = _scrollView.contentSize.width/7452*3424 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
    float Y = _scrollView.contentSize.height/3174*1710 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
    _etoile_Rez.center = CGPointMake(X,Y);
    X = _scrollView.contentSize.width/7452*3195 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
    Y = _scrollView.contentSize.height/3174*2115 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
    _etoile_Pat.center = CGPointMake(X,Y);
    X = _scrollView.contentSize.width/7452*3742 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
    Y = _scrollView.contentSize.height/3174*1820 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
    _etoile_Luge.center = CGPointMake(X,Y);
    X = _scrollView.contentSize.width/7452*3265 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
    Y = _scrollView.contentSize.height/3174*1995 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
    _etoile_ESF.center = CGPointMake(X,Y);
    X = _scrollView.contentSize.width/7452*3010 - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
    Y = _scrollView.contentSize.height/3174*1650 - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
    _etoile_BAB.center = CGPointMake(X,Y);


    if(_bulle.hidden==false && marqueurBulle!=nil)
    {
        // Pate de la bulle
        [_pateBulle setFrame: CGRectMake(marqueurBulle.center.x-11,marqueurBulle.frame.origin.y-10,22,10)];
        if(marqueurBulle==marqueur)
        {
            _titre.center=CGPointMake(marqueurBulle.center.x,marqueurBulle.frame.origin.y-38);
            _nomPiste.center=CGPointMake(marqueurBulle.center.x,marqueurBulle.frame.origin.y-21);
            _bulle.center = CGPointMake(marqueurBulle.center.x, marqueurBulle.frame.origin.y-30);
            
            // Repositionnement du message
            if(_titre.frame.origin.x<_nomPiste.frame.origin.x)
                [_nomPiste setFrame:CGRectMake(_titre.frame.origin.x,_nomPiste.frame.origin.y,_nomPiste.frame.size.width,_nomPiste.frame.size.height)];
            else
                [_titre setFrame:CGRectMake(_nomPiste.frame.origin.x,_titre.frame.origin.y,_titre.frame.size.width,_titre.frame.size.height)];
        }
        else
        {
            _titre.center=CGPointMake(marqueurBulle.center.x,marqueurBulle.frame.origin.y-20);
            _bulle.center = CGPointMake(marqueurBulle.center.x, marqueurBulle.frame.origin.y-20);
        }
    }
}

// Méthodes pour l'affichage de la recherche des participants
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultatsRecherche count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [resultatsRecherche objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *utilisateur;
    utilisateur = [resultatsRecherche objectAtIndex:indexPath.row];
    [self.searchDisplayController setActive:NO];
    [self searchBarCancelButtonClicked:_searchBar];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    resultatsRecherche = [participants filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    rechercheActivee = false;
    [UIView transitionWithView:self.searchBar
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _searchBar.hidden = true;
                    } completion:nil];
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
