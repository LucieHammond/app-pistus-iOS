//
//  ViewController.m
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    translation = 0;
    success = false;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidLayoutSubviews {

    /*l'entier translation vaut -1, 0 ou 1 et permet de savoir si on doit 
     - simplement afficher la vue (0)
     - faire une translation vers le haut quand le clavier d'ouvre (1)
     - faire une translation inverse quand le clavier est fermé (-1)*/
    if(translation==0)
    {
        //Choix de l'image suivant la taille de l'écran
        NSString *image;
        float hauteur = [UIScreen mainScreen].bounds.size.height;
        if(hauteur<500)
            image = @"Login@2x~iphone.png";
        else if(hauteur<600)
            image = @"Login-568h@2x~iphone.png";
        else if(hauteur<700)
            image = @"Login-667h@2x~iphone.png";
        else
            image = @"Login-736h@3x~iphone.png";
    
        //Placement de l'image en fond d'écran
        CGRect screenSize = [[UIScreen mainScreen]bounds];
        [_background setFrame:screenSize];
        [_background setImage:[UIImage imageNamed:image]];
        _background.contentMode = UIViewContentModeScaleToFill;
        [_background sendSubviewToBack:self.view];
    
        //Positionnement des deux Text Fields (suivant la taille de l'écran)
        if(hauteur<500){
            [_login setFrame:CGRectMake(71, 166, 182, 30)];
            [_mdp setFrame:CGRectMake(71, 252, 182, 30)];}
        else if(hauteur<600){
            [_login setFrame:CGRectMake(72, 185, 183, 30)];
            [_mdp setFrame:CGRectMake(72, 272, 183, 30)];}
        else if(hauteur<700){
            [_login setFrame:CGRectMake(87, 219, 203, 37)];
            [_mdp setFrame:CGRectMake(87, 319, 203, 37)];
            _login.font = [UIFont systemFontOfSize:16];
            _mdp.font = [UIFont systemFontOfSize:16];}
        else{
            [_login setFrame:CGRectMake(96, 239, 227, 41)];
            [_mdp setFrame:CGRectMake(96, 354, 227, 41)];
            _login.font = [UIFont systemFontOfSize:17];
            _mdp.font = [UIFont systemFontOfSize:17];}
        
        //Positionnement du bouton Valider
        _valider.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height*3/4-10);
    }
    if(translation == 1)
    {
        //Translation vers le haut
        [UIView animateWithDuration:0.15
            delay:0
            options: UIViewAnimationOptionTransitionFlipFromBottom
            animations:^{
                _background.frame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [_login setFrame: CGRectMake(71, 106, 182, 30)];
                [_mdp setFrame: CGRectMake(71, 192, 182, 30)];
                [_valider setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height*3/4-70)];
            }
            completion:^(BOOL finished){
            }];
    }
    else if(translation==-1)
    {
        //Translation vers le bas
        [UIView animateWithDuration:0.15
                              delay:0
                            options: UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             _background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                             [_login setFrame: CGRectMake(71, 166, 182, 30)];
                             [_mdp setFrame: CGRectMake(71, 252, 182, 30)];
                             [_valider setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height*3/4-10)];
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (success == true)
        return true;
    else
        return false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finDeSaisieID:(id)sender {
    //On fait disparaitre le clavier et redescendre la vue pour les devices concernés
    [_login resignFirstResponder];
    if([UIScreen mainScreen].bounds.size.height<500)
        translation=-1;[self viewDidLayoutSubviews];
}

- (IBAction)finDeSaisieMDP:(id)sender {
    //On fait disparaitre le clavier et redescendre la vue pour les devices concernés
    [_mdp resignFirstResponder];
    if([UIScreen mainScreen].bounds.size.height<500)
        translation=-1;[self viewDidLayoutSubviews];
}

- (IBAction)translationID:(id)sender {
    /*Permet de translater l'imamge vers le haut quand le clavier apparait
    pour que l'utilisateur puisse voir ce qu'il tape (pour les iPhones 3 et 4)*/
    if([UIScreen mainScreen].bounds.size.height<500)
        translation= 1;[self viewDidLayoutSubviews];
}

- (IBAction)translationMDP:(id)sender {
    /*Permet de translater l'imamge vers le haut quand le clavier apparait
     pour que l'utilisateur puisse voir ce qu'il tape (pour les iPhones 3 et 4)*/
    if([UIScreen mainScreen].bounds.size.height<500)
        translation= 1;[self viewDidLayoutSubviews];
}

- (IBAction)connection:(id)sender {
    NSString *login = _login.text;
    NSString *mdp = _mdp.text;
    NSString *titre = @"RAS";
    NSString *message = nil;
    
    //Détection de cas non conformes et affectation de messages
    if ([login isEqualToString:@""])
        titre = @"Veuillez renseigner votre identifiant !";
    else if ([mdp isEqualToString:@""])
        titre = @"Veuillez renseigner votre mot de passe !";
    else{
        //Première vérification de la forme du mot de passe
        BOOL conforme = true;
        if ([login length]<=3)
            conforme = false;
        else{
            NSInteger year = [[login substringWithRange:NSMakeRange(0,4)] integerValue];
            NSString *nom = [login substringFromIndex:4];
            if (year<1980 || year>=2020)
                conforme = false;
            else if(![nom isEqualToString: [nom lowercaseString]])
                conforme = false;
        }
        if(conforme == false){
            titre = @"Login incorrect !";
            message = @"Il faut indiquer votre login VIA, de la forme : \"2015durandm\" (pour le GPA Martin Durand)";
        }
        
    }
    // Creation d'une alerte
    if (![titre isEqualToString:@"RAS"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:titre
                              message:message delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        /* Ici j'envoie le login et le mdp de l'utilisateur au serveur d'authentification de VIA
        Celui ci me renvoie un token d'autorisation ou un code d'erreur.*/
        
        [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"pistonski"
                                                                  username:login                                                                password:mdp];
    
        //En cas de succes, un nouvel account est ajouté à [NXOAuth2AccountStore sharedStore]
        [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                    object:[NXOAuth2AccountStore sharedStore]
                    queue:nil
                    usingBlock:^(NSNotification *aNotification){
                        NSInteger s=0;
                        for (NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore] accounts]) {
                            s+=1;
                        };
                        NSLog(@"%li",(long)s);
                        [NXOAuth2Request performMethod:@"GET"
                                            onResource:[NSURL URLWithString:@"https://my.ecp.fr/api/v1/members/me"]
                                       usingParameters:nil
                                           withAccount:[[[NXOAuth2AccountStore sharedStore] accounts] lastObject]
                                   sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) { // e.g., update a progress indicator
                                   }
                                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                                       NSLog(@"Success");
                                       // Process the response
                                   }];
                        
                        //NSLog([NSString stringWithFormat:@"%@", [aNotification.userInfo objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey]]);
                    }];
        
        // En cas d'erreur, j'affiche une alerte avec un message correspondant
        [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                    object:[NXOAuth2AccountStore sharedStore]
                    queue:nil
                    usingBlock:^(NSNotification *aNotification){
                        NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                        
                        //Report de l'erreur dans la console
                        /*for(id key in aNotification.userInfo)
                            NSLog(@"key=%@ value=%@", key, [aNotification.userInfo objectForKey:key]);*/
                        
                        NSString *titre;
                        NSString *mes;
                        if(error.code == 400){
                            titre = @"Mot de passe incorrect"; mes = @"Mauvaise combinaison entre l'identifiant et le mot de passe";}
                        else if(error.code == -1009){
                            titre = @"Pas de connection Internet"; mes = @"Il semble que vous ne soyiez pas connecté à Internet";}
                        else{
                            titre = @"Erreur non identifiée"; mes = @"Une erreur s'est produite qui n'a pas été identifiée. Vérifiez que vous avez correctement renseigné vos identifiants";}
                        
                        UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle:titre
                                                message:mes delegate:self
                                                cancelButtonTitle:@"Réessayer" otherButtonTitles:nil];
                        [alert show];
                    }];
    
        /* Puis je demande au serveur de ressources de VIA de me fournir les infos dont j'ai besoin (nom, prenom, photo...) et je les met dans une variable globale que je transmet à la page main view*/
        
        // Transition vers la vue principale de l'appli (Main View Controller)
        success = false;
        [self shouldPerformSegueWithIdentifier:@"loginReussi" sender:self];
                
        }

}

- (IBAction)deconnection:(id)sender {
    for (NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore] accounts]) {
        [[NXOAuth2AccountStore sharedStore]  removeAccount:account];
    }
}


@end




