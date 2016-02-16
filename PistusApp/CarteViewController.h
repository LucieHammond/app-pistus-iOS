//
//  CarteViewController.h
//  PistusApp
//
//  Created by Lucie on 25/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarteViewController : UIViewController <UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *imageView;
    UIButton *marqueurBulle;
    UIButton *marqueur;
    BOOL rechercheActivee;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *barre;
@property (weak, nonatomic) IBOutlet UIView *topBande;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackAcceptButton;
@property (weak, nonatomic) IBOutlet UILabel *texteDistance;
@property (weak, nonatomic) IBOutlet UIView *fondTexteDistance;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

@property (weak, nonatomic) IBOutlet UIButton *etoile_Rez;
@property (weak, nonatomic) IBOutlet UIButton *etoile_Pat;
@property (weak, nonatomic) IBOutlet UIButton *etoile_Luge;
@property (weak, nonatomic) IBOutlet UIButton *etoile_BAB;
@property (weak, nonatomic) IBOutlet UIButton *etoile_ESF;
@property (weak, nonatomic) IBOutlet UIButton *etoile_Yooner;
@property (weak, nonatomic) IBOutlet UIButton *etoile_Cine;
@property (strong, nonatomic) IBOutlet UIImageView *pateBulle;
@property (strong, nonatomic) IBOutlet UILabel *titre;
@property (strong, nonatomic) IBOutlet UILabel *nomPiste;
@property (strong, nonatomic) IBOutlet UILabel *derniereDate;
@property (strong, nonatomic) IBOutlet UIView *bulle;
@property (strong, nonatomic) IBOutlet UIButton *supprimer;

@property BOOL apresClic;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
- (void)centerScrollViewContents;
- (void) updateSelfPosition;
- (void) updateUsersPositions;
- (IBAction)supprimerMarqueur:(id)sender;
- (IBAction)actualiser:(id)sender;

@end
