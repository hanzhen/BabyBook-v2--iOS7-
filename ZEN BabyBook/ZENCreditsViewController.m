//
//  ZENCreditsViewController.m
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 02/11/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENCreditsViewController.h"
@import QuartzCore;


@interface ZENCreditsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containingView;
@property (strong, nonatomic) NSTimer *timer;
@end


@implementation ZENCreditsViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = NSLocalizedString(@"Credits",@"Credits");
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"geometry"]];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Hide the textView, so it will appear from below the bottom
    self.textView.hidden = YES;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    // INITIAL POSITION of the text : below the bottom of the UITextView
    self.textView.contentOffset = CGPointMake(0, - self.textView.bounds.size.height);
//    NSLog(@"textView contentSize : %f", self.textView.contentSize.height);
//    NSLog(@"textView bounds height : %f", self.textView.bounds.size.height);
    
    
    // Set a GRADIENT LAYER to fade the top and bottom parts of the textView
    [self defineFadingMaskForView:self.containingView];

    // Unhide the textView
    self.textView.hidden = NO;
    
    // Set a repeating NSTIMER to scroll
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(scrollText)
                                   userInfo:nil
                                    repeats:YES];
    
    
    //    // Automatic scrolling using UIView animation method
    //    CGFloat scrollHeight = 200;
    //    [UIView animateWithDuration:10
    //                          delay:0
    //                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
    //                     animations:^{
    //                         self.textView.contentOffset = CGPointMake(0, scrollHeight);
    //                     }
    //                     completion:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - Custom methods

- (void)scrollText
{
    // Automatic scrolling
    CGPoint scrollPoint = self.textView.contentOffset;
    scrollPoint.y = scrollPoint.y + 20.0;
    [self.textView setContentOffset:scrollPoint animated:YES];
//    NSLog(@"TextView content offset : %0f", self.textView.contentOffset.y);
    
    // Infinite scrolling
    // If the text passes over the textView top edge
    if (self.textView.contentOffset.y > self.textView.contentSize.height) {
        // Restart the text
        self.textView.contentOffset = CGPointMake(0, - self.textView.bounds.size.height);
    }
}


#pragma mark - Fading text effect

- (void)defineFadingMaskForView:(UIView *)viewToFade {
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                         (id)[UIColor clearColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[ @0.0f, @0.2f, @0.9f, @1.0f ];
    maskLayer.frame = viewToFade.bounds;
    viewToFade.layer.mask = maskLayer;
    
}

@end
