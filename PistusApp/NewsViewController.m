//
//  NewsViewController.m
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "NewsViewController.h"
#import "GeolocalisationManager.h"
#import "CustomTableViewCell.h"

@interface NewsViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSArray *infosHTML;
@property (nonatomic,strong) NSArray *titreInfos;
@property (nonatomic,strong) NSArray *dateInfos;

@end

@implementation NewsViewController

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
    UIImage *image = [UIImage imageNamed:@"news.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(46,38),NO,3);
    [image drawInRect:CGRectMake(0,0,46,38)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setImage:newImage];
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setImageInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    // Redimensionnement des autres boutons de la barre d'onglets
    UIImage *image2 = [UIImage imageNamed:@"mesInfos.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(47,33),NO,3);
    [image2 drawInRect:CGRectMake(0,0,47,33)];
    UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem] setImage:newImage2];
    [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem]  setImageInsets:UIEdgeInsetsMake(0,0,0,0)];
    UIImage *image3 = [UIImage imageNamed:@"infoGenerales.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,34),NO,3);
    [image3 drawInRect:CGRectMake(0,0,35,34)];
    UIImage *newImage3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem] setImage:newImage3];
    [[[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem]  setImageInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    // Remplir les infos
    _titreInfos=@[@"Pipo 1",@"Pipo 2"];
    _dateInfos = @[@"16/02/2016 12h30",@"17/05/2016 07h25"];
    NSString *info1=
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit. </br>"
    "</br>"
    "<body />";
    NSString *info2 =
    @"<body style = \"font-size:11px; text-align:justify; font-family:'Trebuchet MS'\">"
    "Ut velit mauris, egestas sed, gravida nec, ornare ut, mi. Aenean ut orci vel massa suscipit pulvinar. Nulla sollicitudin. Fusce varius, ligula non tempus aliquam, nunc turpis ullamcorper nibh, in tempus sapien eros vitae ligula. Pellentesque rhoncus nunc et augue. Integer id felis. Curabitur aliquet pellentesque diam. Integer quis metus vitae elit lobortis egestas. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi vel erat non mauris convallis vehicula. Nulla et sapien. Integer tortor tellus, aliquam faucibus, convallis id, congue eu, quam. Mauris ullamcorper felis vitae erat. Proin feugiat, augue non elementum posuere, metus purus iaculis lectus, et tristique ligula justo vitae magna. </br>"
    "</br>"
    "<body />";
    _infosHTML=@[info1,info2];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infosHTML.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
    }
    NSString *titre = _titreInfos[indexPath.row];
    NSString *html = _infosHTML[indexPath.row];
    NSString *date = _dateInfos[indexPath.row];
    hauteurSection = [cell configUIWithTitle:titre date:date HTML:html];
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hauteurSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actualiser:(id)sender {
}
@end
