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
@property (weak, nonatomic) IBOutlet UIButton *homeButton; // iPad only
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel; // iPad only

@property (strong, nonatomic) UILabel *titleLabel; // iPhone only

@property (strong, nonatomic) ZENZoomInAnimationController *zoomAnimationController;
@end


@implementation ZENAlbumViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Album selected : %@", self.album.name);
    
    // Album background color
    if ([self.album.color isEqualToString:@"blue"]) {
        self.view.backgroundColor = [UIColor ZENBlueColor];
    } else if ([self.album.color isEqualToString:@"green"]) {
        self.view.backgroundColor = [UIColor ZENGreenColor];
    } else if ([self.album.color isEqualToString:@"orange"]) {
        self.view.backgroundColor = [UIColor ZENOrangeColor];
    } else if ([self.album.color isEqualToString:@"yellow"]) {
        self.view.backgroundColor = [UIColor ZENYellowColor];
    } else if ([self.album.color isEqualToString:@"red"]) {
        self.view.backgroundColor = [UIColor ZENRedColor];
    } else if ([self.album.color isEqualToString:@"purple"]) {
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
    NSString *albumName = [NSString new];
    if (self.album.titles[userLanguage]) {
        albumName = self.album.titles[userLanguage]; // should work because language codes in the ZENLanguageStore are ISO-compliant
        self.albumNameLabel.text = albumName;
    
    } else {
        albumName = self.album.titles[@"EN"];
        self.albumNameLabel.text = albumName;
    }
    
    
    // TITLE LABEL
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 32)]; // 32 = navigationBar height for iPhone in landscape
    self.titleLabel.text = albumName;
    self.titleLabel.hidden = YES; // hidden at first to avoid appearance bug
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel; // in the navigation Item = iPhone only
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.titleLabel.hidden = NO;
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




#pragma mark - UICollectionView DelegateFlowLayout methods

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // set in Interface Builder
//}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    // set in Interface Builder
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
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
//                NSLog(@"fromRect : %f %f %f %f", self.zoomAnimationController.fromRect.origin.x, self.zoomAnimationController.fromRect.origin.y, self.zoomAnimationController.fromRect.size.width, self.zoomAnimationController.fromRect.size.height);
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
        if (imageViewController.hasDeviceRotated) {
            // Device has rotated : the original frame of the item in the collectionView is no longer valid
            // Move the item out of of the screen
            self.zoomAnimationController.toRect = CGRectMake(0 - itemFrame.size.height,
                                                             0 - itemFrame.size.width,
                                                             itemFrame.size.width,
                                                             itemFrame.size.height);
        } else {
            // Device has not rotated : the original frame of the item in the collectionView is still valid
            self.zoomAnimationController.toRect = [self.imageCollectionView convertRect:itemFrame toView:self.view];
        }
        
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
    self.zoomAnimationController.duration = 0.8;
    return self.zoomAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.zoomAnimationController.reverse = YES;
    self.zoomAnimationController.duration = 0.8;
    return self.zoomAnimationController;
}


@end
