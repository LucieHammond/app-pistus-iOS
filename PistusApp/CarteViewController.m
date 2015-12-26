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

@end

@implementation CarteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _scrollView.delegate=self;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=8.0;
    // Do any additional setup after loading the view.
}

-(void) viewDidLayoutSubviews{
    
    //Ajustement de la barre de navigation en haut et configuration des icones
    [_barre setFrame:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width, 45)];
    
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

- (IBAction)trackChange:(id)sender {
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
