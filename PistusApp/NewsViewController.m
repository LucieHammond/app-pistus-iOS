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
#import "DataManager.h"

@interface NewsViewController ()

@property (nonatomic,strong) UIButton *boutonSatellite;
@property (nonatomic,strong) NSArray *generalNews;
@property (nonatomic,strong) NSMutableArray *displayedNews;

@end

@implementation NewsViewController

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
    
    // Get News from API
    _generalNews = [DataManager getData:@"generalNews"][@"generalNews"];
    
    // Enlever les marqueurs pour les alertes passées
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    // Sort news to keep only those with an earlier date
    _displayedNews = [[NSMutableArray alloc]init];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for(int i=_generalNews.count-1;i>=0;i--){
        NSDate *dateTime = [df dateFromString:_generalNews[i][@"date"]];
        if([dateTime compare:[NSDate date]]==NSOrderedDescending)
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = dateTime;
            localNotification.alertTitle= _generalNews[i][@"title"];
            localNotification.alertBody = _generalNews[i][@"text"];
            localNotification.alertAction = @"Fais glisser pour voir la news";
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        else
            [_displayedNews insertObject:_generalNews[i] atIndex:0];
    }
    
    // Ajustement de la tableView
    [_tableView setFrame:CGRectMake(0,65,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-114)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
    NSLog(@"%i",_displayedNews.count);return _displayedNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
    }
    NSString *title = _displayedNews[indexPath.row][@"title"];
    NSString *content = _displayedNews[indexPath.row][@"text"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nsdate = [df dateFromString:_displayedNews[indexPath.row][@"date"]];
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *date = [df stringFromDate:nsdate];
    
    hauteurSection = [cell configUIWithTitle:title date:date HTML:content];
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
    [self viewDidLoad];
}
@end
