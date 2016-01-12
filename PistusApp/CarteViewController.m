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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _scrollView.delegate=self;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=8.0;
    
    if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        if([GeolocalisationManager sharedInstance].pisteProche!=nil)
        {
            double distance = [GeolocalisationManager sharedInstance].distanceStation;
            NSString *pisteProche = [GeolocalisationManager sharedInstance].pisteProche;
            _texteDistance.text=[NSString stringWithFormat:@"%@%.0f%@%@%@",@"Vous vous trouvez à ",distance,@"m de la piste la plus proche : ",pisteProche,@". Attention, la pratique du hors piste est à vos risques et périls"];
            [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+20, _texteDistance.frame.size.height+10)];
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
        }
        else if([GeolocalisationManager sharedInstance].distanceStation>0)
        {
            double distance = [GeolocalisationManager sharedInstance].distanceStation/1000;
            _texteDistance.text=[NSString stringWithFormat:@"%@%.2f%@",@"Impossible de vous localiser sur la carte. \nVous vous trouvez à ",distance,@" km de la station Val d'Allos"];
            [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+15, _texteDistance.frame.size.height-5)];
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
            marqueur.hidden=true;
        }
        else if([GeolocalisationManager sharedInstance].distanceStation==-1)
        {
            _texteDistance.text=[NSString stringWithFormat:@"Impossible de vous localiser sur le domaine skiable. Vous vous trouvez à plus de 100m des pistes"];
            [_fondTexteDistance setFrame:CGRectMake(0, 0, _texteDistance.frame.size.width+20, _texteDistance.frame.size.height-5)];
            _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
            _fondTexteDistance.hidden=false;
            marqueur.hidden=true;
        }
        else
        {
            _texteDistance.text = @"";
            _fondTexteDistance.hidden=true;
            
            // Affichage du marqueur de position
            int x = [GeolocalisationManager sharedInstance].dernierX;
            int y = [GeolocalisationManager sharedInstance].dernierY;
            float X = _scrollView.contentSize.width/7452*x - _scrollView.contentOffset.x + _scrollView.frame.origin.x;
            float Y = _scrollView.contentSize.height/3174*y - _scrollView.contentOffset.y + _scrollView.frame.origin.y;
            marqueur.center = CGPointMake(X,Y);
            marqueur.hidden = false;
        }
    }
    // Do any additional setup after loading the view.
}

-(void) viewDidLayoutSubviews{
    
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

    // Configuration du scrollView pour pouvoir se déplacer sur le plan
    [_scrollView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 65)];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plan Val d'Allos Official corrigé.jpg"]];
    [imageView setFrame:CGRectMake(0,0,_scrollView.frame.size.height*imageView.frame.size.width/imageView.frame.size.height,_scrollView.frame.size.height)];
    [_scrollView addSubview:imageView];
    [_scrollView setContentOffset:CGPointMake((imageView.frame.size.width-_scrollView.frame.size.width)/2,0)];
    [_scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    [_scrollView setScrollEnabled:YES];
    
    // Configuration du scrollView pour pouvoir zoomer sur le plan
    [_scrollView addGestureRecognizer:_pinchGesture];
    
    // Ajustement du texte qui s'affiche en cas de localisation hors de la station
    _texteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
    _fondTexteDistance.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 110);
    [self.view insertSubview:_fondTexteDistance aboveSubview:_scrollView];
    [self.view insertSubview:_texteDistance aboveSubview:_fondTexteDistance];
    _texteDistance.text=@"";
    _fondTexteDistance.hidden=true;
    
    // Création du marqueur
    marqueur = [[UIButton alloc] initWithFrame:CGRectMake(0,0,16,16)];
    [marqueur setImage:[UIImage imageNamed:@"marker2.png"] forState:UIControlStateNormal];
    [marqueur addTarget:self action:@selector(afficherDetailsPourMarqueur:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:marqueur aboveSubview:imageView];
    marqueur.hidden=true;
    
    // Ajout du bouton pour recentrer sur la position de l'utilisateur
    UIButton *ciblage = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height*7/10,47,47)];
    [ciblage setImage:[UIImage imageNamed:@"ciblage.png"] forState:UIControlStateNormal];
    ciblage.alpha=0.5;
    [self.view insertSubview:ciblage aboveSubview:_scrollView];
    [ciblage addTarget:self action:@selector(ciblerPosition)
               forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [_etoile_Rez addTarget:self action:@selector(afficherDetailsPourMarqueur:)
         forControlEvents:UIControlEventTouchUpInside];
    [_etoile_Pat addTarget:self action:@selector(afficherDetailsPourMarqueur:)
          forControlEvents:UIControlEventTouchUpInside];
    [_etoile_Luge addTarget:self action:@selector(afficherDetailsPourMarqueur:)
          forControlEvents:UIControlEventTouchUpInside];
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
    // Pate de la bulle
    UIImageView *pateBulle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pate_bulle.png"]];
    [pateBulle setFrame: CGRectMake(sender.center.x-11,sender.frame.origin.y-10,22,10)];
    [self.view insertSubview:pateBulle aboveSubview:imageView];
    
    // Titre "Vous êtes ici"
    UILabel *titre = [[UILabel alloc] init];
    titre.text=@"Vous êtes ici";
    titre.font=[UIFont boldSystemFontOfSize:16.0];
    [titre sizeToFit];
    titre.center=CGPointMake(sender.center.x,sender.frame.origin.y-38);
    [self.view insertSubview:titre aboveSubview:pateBulle];
    
    // Nom de la piste
    UILabel *nomPiste = [[UILabel alloc] init];
    self.dbManager=[[DBManager alloc]initWithDatabaseFilename:@"bddPistes.db"];
    NSString *query = [NSString stringWithFormat:@"select nom from pistes where id='%@'",[GeolocalisationManager sharedInstance].dernierePiste];
    nomPiste.text=[self.dbManager loadDataFromDB:query][0][0];
    nomPiste.font=[UIFont systemFontOfSize:11.0];
    [nomPiste sizeToFit];
    nomPiste.center=CGPointMake(sender.center.x,sender.frame.origin.y-21);
    [self.view insertSubview:nomPiste aboveSubview:titre];
    
    // Fond de la bulle
    UIView *bulle = [[UIView alloc] init];
    [bulle setBackgroundColor:[UIColor whiteColor]];
    [bulle setFrame: CGRectMake(0,0,MAX(nomPiste.frame.size.width+15,titre.frame.size.width+15),40)];
    bulle.center = CGPointMake(sender.center.x, sender.frame.origin.y-30);
    [self.view insertSubview:bulle belowSubview:titre];
    
    // Repositionnement du message
    if(titre.frame.origin.x<nomPiste.frame.origin.x)
        [nomPiste setFrame:CGRectMake(titre.frame.origin.x,nomPiste.frame.origin.y,nomPiste.frame.size.width,nomPiste.frame.size.height)];
    else
        [titre setFrame:CGRectMake(nomPiste.frame.origin.x,titre.frame.origin.y,titre.frame.size.width,titre.frame.size.height)];
    
    // Effacement de la bulle
    [sender addTarget:self action:@selector(effacerBulle) forControlEvents:UIControlEventTouchUpOutside];
    [bulle removeFromSuperview];
    [nomPiste removeFromSuperview];
    [titre removeFromSuperview];
    [pateBulle removeFromSuperview];
    
    //NSArray *lieuxImportants = [NSArray arrayWithObjects: @"Résidence Plein Sud", @"Patinoire",@"Verdon Express /nLuge sur rails",nil];
}

-(void) effacerBulle
{
    NSLog(@"Bite");
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
