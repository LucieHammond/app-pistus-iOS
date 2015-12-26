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

@property (nonatomic, strong) GeolocalisationManager *glManager;
@property (nonatomic,strong) UIButton *boutonSatellite;

@end

@implementation CarteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _scrollView.delegate=self;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=8.0;
    self.glManager=[GeolocalisationManager sharedInstance];
    // Do any additional setup after loading the view.
}

-(void) viewDidLayoutSubviews{
    
    //Ajustement de la barre de navigation en haut et configuration des icones
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    _boutonSatellite = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,33)];
    if(![GeolocalisationManager trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
    }
    else if([GeolocalisationManager trackAccept])
    {
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
    }
    [_trackAcceptButton setCustomView:_boutonSatellite];
    [_boutonSatellite addTarget:self action:@selector(trackChange)
         forControlEvents:UIControlEventTouchUpInside];

    // Configuration du scrollView pour pouvoir se déplacer sur le plan
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plan Val d'Allos Official corrigé.jpg"]];
    [imageView setFrame:CGRectMake(0,0,_scrollView.frame.size.height*imageView.frame.size.width/imageView.frame.size.height,_scrollView.frame.size.height)];
    [_scrollView addSubview:imageView];
    [_scrollView setContentOffset:CGPointMake((imageView.frame.size.width-_scrollView.frame.size.width)/2,0)];
    [_scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    [_scrollView setScrollEnabled:YES];
    
    // Configuration du scrollView pour pouvoir zoomer sur le plan
    [_scrollView addGestureRecognizer:_pinchGesture];

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
    if(![GeolocalisationManager trackAccept])
    {
        NSLog(@"Point 0 atteint");
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteon.png"] forState:UIControlStateNormal];
        [GeolocalisationManager beginTrack];
    }
    else if([GeolocalisationManager trackAccept])
    {
        NSLog(@"Point 1 atteint");
        [_boutonSatellite setImage:[UIImage imageNamed:@"satelliteoff.png"] forState:UIControlStateNormal];
        [GeolocalisationManager endTrack];
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

@end
