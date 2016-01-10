//
//  CarteViewController.h
//  PistusApp
//
//  Created by Lucie on 25/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarteViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIButton *marqueur;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UILabel *texteDistance;
@property (weak, nonatomic) IBOutlet UIView *fondTexteDistance;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

@end
