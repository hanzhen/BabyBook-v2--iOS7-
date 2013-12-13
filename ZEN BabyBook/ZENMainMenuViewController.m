//
//  ZENMainMenuViewController.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 17/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENMainMenuViewController.h"
#import "ZENAlbumViewController.h"
#import "ZENContentStore.h"
#import "ZENAlbum.h"
#import "ZENAlbumCoverCell.h"
#import "ZENSettingsTableViewController.h"
#import "ZENPortalAnimationController.h"
#import "CEPinchInteractionController.h"
@import QuartzCore;

@interface ZENMainMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (strong, nonatomic) UIPopoverController *preferencesPopover;
@property (strong, nonatomic) ZENPortalAnimationController *portalAnimationController;
@property (strong, nonatomic) CEPinchInteractionController *pinchInteractionController;

@end


@implementation ZENMainMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"geometry-beige"]];

    /* Unused but to be kept as reference
     
    // Set the title view layer as a black translucent rounded rect
    UIColor *blackTranslucentColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.20];
    self.titleImageView.layer.backgroundColor = blackTranslucentColor.CGColor;
    self.titleImageView.layer.cornerRadius = 12.0;
    */
    
    // Title
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZENBabyBook_titleSmall"]];
    
    // Navigation controller delegate
    // (necessary for custom transitions within navigationController)
    self.navigationController.delegate = self;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // Remove pointer to popover
    self.preferencesPopover = nil;
}



#pragma mark - UICollectionView Datasource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // ZENMainMenuViewController has 1 section only
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[ZENContentStore sharedStore] allAlbums] count];
    NSLog(@"Returns %i albums", [[[ZENContentStore sharedStore] allAlbums] count]);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZENAlbumCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    cell.album = [[ZENContentStore sharedStore] allAlbums][indexPath.item];
    
    return cell;
}

/*
 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 // NOT USED YET
 }
 */


#pragma mark - UICollectionView DelegateFlowLayout methods

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // set in Interface Builder
//}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    // set in Interface Builder
//}


#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowSettingsInPopover"]) {
        return (!self.preferencesPopover.popoverVisible) ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowAlbum"]) {
        if ([sender isKindOfClass:[ZENAlbumCoverCell class]]) {
            if ([segue.destinationViewController isKindOfClass:[ZENAlbumViewController class]]) {
                NSIndexPath *indexPath = [self.albumCollectionView indexPathForCell:sender];
                ZENAlbum *selectedAlbum = [[ZENContentStore sharedStore] allAlbums][indexPath.row];
                ZENAlbumViewController *albumViewController = segue.destinationViewController;
                albumViewController.album = selectedAlbum;
                
                // Custom VC transition
                albumViewController.transitioningDelegate = self;
                [self.pinchInteractionController wireToViewController:albumViewController forOperation:CEInteractionOperationDismiss];
            }
        }
    } else if ([segue.identifier isEqualToString:@"ShowSettingsInPopover"]) {
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            self.preferencesPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        }
        
    } else if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        // unused yet
    }
}


- (IBAction)backToMenu:(UIStoryboardSegue *)segue
{
    // Unwind Segue from AlbumViewController
}


#pragma mark - Notification center (observer) method

- (void)reloadMyCollectionView:(NSNotification *)notification
// Useful to reload data of the collectionView after content has been unlocked
{
    [self.albumCollectionView reloadData];
    
}


//#pragma mark - status bar hidden
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark - Animation / Interaction controllers

// Animation Controller lazy instantiation
- (ZENPortalAnimationController *)portalAnimationController
{
    if (!_portalAnimationController) {
        _portalAnimationController = [ZENPortalAnimationController new];
    }
    
    return _portalAnimationController;
}


// Interaction Controller lazy instantiation
- (CEPinchInteractionController *)pinchInteractionController
{
    if (!_pinchInteractionController) {
        _pinchInteractionController = [CEPinchInteractionController new];
    }
    return _pinchInteractionController;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.portalAnimationController.reverse = NO;
    self.portalAnimationController.duration = 0.8f;
    return self.portalAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.portalAnimationController.reverse = YES;
    self.portalAnimationController.duration = 0.8f;
    return self.portalAnimationController;
}


- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.pinchInteractionController.interactionInProgress ? self.pinchInteractionController : nil;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        [self.pinchInteractionController wireToViewController:toVC forOperation:CEInteractionOperationPop];
    }
    
    self.portalAnimationController.reverse = operation == UINavigationControllerOperationPop;
    self.portalAnimationController.duration = 0.8f;
    return self.portalAnimationController;
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    
    return self.pinchInteractionController.interactionInProgress ? self.pinchInteractionController : nil;
}

@end
