//
//  ZENZoomInAnimationController.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 08/12/2013.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENZoomInAnimationController.h"

@implementation ZENZoomInAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if(self.reverse){
        [self executeReverseAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    } else {
        [self executeForwardsAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    
}

#define ZOOM_SCALE 2.5 // to get from 200 x 200 to 500 x 500

- (void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {

    UIView *containerView = [transitionContext containerView];

//  Add the views to the container
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    // Initial state : to-View is dimmed
    toView.alpha = 0.0;
    
    // Snapshot the selected frame of the from- view
    UIView *fromViewSnapshot = [fromView resizableSnapshotViewFromRect:self.fromRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    fromViewSnapshot.layer.cornerRadius = 20.0;
    fromViewSnapshot.clipsToBounds = YES;
    fromViewSnapshot.frame = self.fromRect;
    [containerView addSubview:fromViewSnapshot];
    
    // Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                                      
                                      // Dim the from-view (the to-View is completely dimmed, so it gives a nice "fade-to-black" effect)
                                      fromView.alpha = 0.7;
                                      
                                      // Move the image snapshot to the center
                                      fromViewSnapshot.center = toView.center;
                                      
                                      // Zoom in the image snapshot to reach the size of the main image in the ImageVC
                                      CATransform3D scale = CATransform3DIdentity;
                                      fromViewSnapshot.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);
                                      
                                      
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
                                      // Finish fading-out the from-view, and fade-in the to-view
                                      fromView.alpha = 0.0;
                                      toView.alpha = 1.0;
                                      
                                  }];
                                  
                              } completion:^(BOOL finished) {
                                  
                                  // Remove all the temporary views
                                  if ([transitionContext transitionWasCancelled]) {
                                      [self removeOtherViews:fromView];
                                  } else {
                                      [self removeOtherViews:toView];
                                  }
                                  
                                  // Inform the context of completion
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
    
}


- (void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];

    // Add the views to the container
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    [containerView addSubview:fromView];

    // Initial state : to-View is dimmed
    toView.alpha = 0.0;
    
    
    // Snapshot the selected frame of the from- view
    UIView *fromViewSnapshot = [fromView resizableSnapshotViewFromRect:self.fromRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    fromViewSnapshot.layer.cornerRadius = 20.0;
    fromViewSnapshot.clipsToBounds = YES;
    fromViewSnapshot.frame = self.fromRect;
    [containerView addSubview:fromViewSnapshot];

    
    // Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
                                      // Start fading-out the from-view
                                      fromView.alpha = 0.0;
                                  }];

                                  [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.6f animations:^{
                                      
                                      // Dim the from-view and start fading-in the to-view
                                      toView.alpha = 0.5;
                                      
                                      // Move the image snapshot to the initial place
                                      fromViewSnapshot.frame = [toVC.view convertRect:self.toRect toView:toVC.view];
                                      
                                      // Zoom out the image snapshot to reach the size of the original cell in the AlbumVC
                                      CATransform3D scale = CATransform3DIdentity;
                                      fromViewSnapshot.layer.transform = CATransform3DScale(scale, 1, 1, 1);
                                      
                                      
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.4f animations:^{
                                      // Finish fading-in the to-view
                                      toView.alpha = 1.0;
                                      
                                  }];
                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [self removeOtherViews:fromView];
                         } else {
                             [self removeOtherViews:toView];
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}


// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}



@end
