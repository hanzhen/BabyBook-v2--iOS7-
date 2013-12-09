//
//  ZENAlbumViewController.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 10/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENAlbumViewController.h"
#import "ZENAlbum.h"
#import "ZENContentStore.h"
#import "ZENAlbumImageCell.h"
#import "ZENImageViewController.h"
#import "UIColor+ZENColor.h"
#import "UIButton+Round.h"
#import "ZENZoomInAnimationController.h"
@import QuartzCore;


@interface ZENAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) ZENZoomInAnimationController *zoomAnimationController;
@end


@implementation ZENAlbumViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Album selected : %@", self.album.name);
    
    // Album background color
    if ([_album.color isEqualToString:@"blue"]) {
        self.view.backgroundColor = [UIColor ZENBlueColor];
    } else if ([_album.color isEqualToString:@"green"]) {
        self.view.backgroundColor = [UIColor ZENGreenColor];
    } else if ([_album.color isEqualToString:@"orange"]) {
        self.view.backgroundColor = [UIColor ZENOrangeColor];
    } else if ([_album.color isEqualToString:@"yellow"]) {
        self.view.backgroundColor = [UIColor ZENYellowColor];
    } else if ([_album.color isEqualToString:@"red"]) {
        self.view.backgroundColor = [UIColor ZENRedColor];
    } else if ([_album.color isEqualToString:@"purple"]) {
        self.view.backgroundColor = [UIColor ZENPurpleColor];
    }
    
    
    // HOME BUTTON
    [UIButton makeRoundButton:self.homeButton WithImageNamed:@"home"];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Album name according to user language
    NSString *userLanguage = [[[NSLocale preferredLanguages] firstObject] uppercaseString];
    if (_album.titles[userLanguage]) {
        self.albumNameLabel.text = _album.titles[userLanguage]; // should work because language codes in the ZENLanguageStore are ISO-compliant
    } else {
        self.albumNameLabel.text = _album.titles[@"EN"];
    }


}


#pragma mark - UICollectionView Datasource methods


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Each ZENAlbumViewController shows the content of 1 album only
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.album.items count];
    NSLog(@"Returns %i items in album", [self.album.items count]);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZENAlbumImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    cell.item = [self.album itemAtIndex:indexPath.item];
    
    // Cells are white rounded rects
    cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cell.layer.cornerRadius = 20.0;
    // and flagged "clip subviews" on the AlbumImageCell in IB

    return cell;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // NOT USED YET
}
*/



#pragma mark - UICollectionView DelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 200);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIEdgeInsetsMake(15, 45, 15, 45);
    } else {
        return UIEdgeInsetsMake(5, 15, 5, 15);
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowItem"]) {
        if ([sender isKindOfClass:[ZENAlbumImageCell class]]) {
            if ([segue.destinationViewController isKindOfClass:[ZENImageViewController class]]) {
                ZENAlbumImageCell *selectedCell = (ZENAlbumImageCell *)sender;
                NSIndexPath *indexPath = [self.imageCollectionView indexPathForCell:selectedCell];
                ZENItem *selectedItem = self.album.items[indexPath.row];
                
                ZENImageViewController *imageViewController = (ZENImageViewController *)segue.destinationViewController;
                imageViewController.item = selectedItem;
                
                imageViewController.transitioningDelegate = self;
                
                // Zoom animated transition : detemine from-rect
                self.zoomAnimationController.fromRect =  [selectedCell.itemImageView convertRect:selectedCell.itemImageView.frame toView:self.view];
                NSLog(@"fromRect : %f %f %f %f", self.zoomAnimationController.fromRect.origin.x, self.zoomAnimationController.fromRect.origin.y, self.zoomAnimationController.fromRect.size.width, self.zoomAnimationController.fromRect.size.height);
            }
        }
    }
}


- (IBAction)backToAlbum:(UIStoryboardSegue *)segue
{
    // Unwind Segue from ImageViewController
    
    
    // Zoom reverse transition : detemine from- and to-rects
    if ([segue.sourceViewController isKindOfClass:[ZENImageViewController class]]) {
        
        ZENImageViewController *imageViewController = (ZENImageViewController *)segue.sourceViewController;
        NSUInteger index = [self.album.items indexOfObject:imageViewController.item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        // Get the layout attributes (including the frame) of the cell
        UICollectionViewLayoutAttributes *attributes = [self.imageCollectionView layoutAttributesForItemAtIndexPath:indexPath];
        CGRect itemFrame = attributes.frame;
        
        // Define toRect and fromRect
        self.zoomAnimationController.toRect = [self.imageCollectionView convertRect:itemFrame toView:self.view];
        self.zoomAnimationController.fromRect = imageViewController.mainImageView.frame;
        NSLog(@"fromRect : %f %f %f %f", self.zoomAnimationController.fromRect.origin.x, self.zoomAnimationController.fromRect.origin.y, self.zoomAnimationController.fromRect.size.width, self.zoomAnimationController.fromRect.size.height);
        NSLog(@"toRect : %f %f %f %f", self.zoomAnimationController.toRect.origin.x, self.zoomAnimationController.toRect.origin.y, self.zoomAnimationController.toRect.size.width, self.zoomAnimationController.toRect.size.height);
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

// Animation Controller lazy instantiation
- (ZENZoomInAnimationController *)zoomAnimationController
{
    if (!_zoomAnimationController) {
        _zoomAnimationController = [[ZENZoomInAnimationController alloc] init];
    }
    
    return _zoomAnimationController;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.zoomAnimationController.reverse = NO;
    return self.zoomAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.zoomAnimationController.reverse = YES;
    return self.zoomAnimationController;
}

@end
