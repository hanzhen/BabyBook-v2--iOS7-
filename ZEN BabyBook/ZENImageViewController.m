//
//  ZENImageViewController.m
//  ZENImageBook
//
//  Created by Frédéric ADDA on 10/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENImageViewController.h"
#import "ZENItem.h"
#import "ZENAlbum.h"
#import "ZENContentStore.h"
#import "ZENGlobalSettings.h"
#import "ZENLanguage.h"
#import "UIColor+ZENColor.h"
#import "UIButton+Round.h"
@import AudioToolbox;


@interface ZENImageViewController ()

// IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonFirstLanguage;
@property (weak, nonatomic) IBOutlet UIButton *buttonSecondLanguage;
@property (weak, nonatomic) IBOutlet UIButton *backButton; // iPad only
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel; // iPad only

@property (strong, nonatomic) UILabel *titleLabel; // iPhone only

// Sound properties
@property (nonatomic) SystemSoundID itemSound; // animal sound for example, not always present
@property (nonatomic) SystemSoundID speechFirstLanguage;
@property (nonatomic) SystemSoundID speechSecondLanguage;

@end



@implementation ZENImageViewController

#pragma mark - override item setter
- (void)setItem:(ZENItem *)item
{
    _item = item;
    
    // Update item image and sounds
    [self updateItemResources];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set first and second languages for the VC
    self.firstLanguage = [[ZENGlobalSettings sharedStore] firstLanguage];
    self.secondLanguage = [[ZENGlobalSettings sharedStore] secondLanguage];
    
    NSLog(@"Item selected : %@", self.item.name);
    
    // BACK BUTTON
    [UIButton makeRoundButton:self.backButton WithImageNamed:@"grid-layout"];

    // ARROW BUTTONS
    [UIButton makeRoundButton:self.leftArrowButton WithImageNamed:@"arrow-left"];
    [UIButton makeRoundButton:self.rightArrowButton WithImageNamed:@"arrow-right"];

    
    // TEXT COLOR is the tint color of the view
    self.itemLabel.textColor = self.view.tintColor;
    
//    // The main image is a white rounded rect
//    self.mainImageView.layer.cornerRadius = 20.0;

    
    // Display FLAG images
    [self.buttonFirstLanguage setImage:[UIImage imageNamed:self.firstLanguage.flagImageName] forState:UIControlStateNormal];
    [self.buttonSecondLanguage setImage:[UIImage imageNamed:self.secondLanguage.flagImageName] forState:UIControlStateNormal];
    
    
    
    // TITLE LABEL
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 32)]; // 32 = navigationBar height for iPhone in landscape
    self.titleLabel.text = @"";
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel; // in the navigation Item = iPhone only
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ITEM LABEL is hidden at first
    self.itemLabel.text = nil;
    
    // UPDATE item image and sounds
    [self updateItemResources];
    
    // Initial state for device rotation
    self.hasDeviceRotated = NO;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Dispose of any resources that can be recreated.
    
    self.item.image = nil;
    
    AudioServicesDisposeSystemSoundID(self.itemSound);
    AudioServicesDisposeSystemSoundID(self.speechFirstLanguage);
    AudioServicesDisposeSystemSoundID(self.speechSecondLanguage);
}




#pragma mark - Custom methods

- (void)updateItemResources
{
    if (self.view) { // only if view has been created
        
        // Display item image
        self.mainImageView.image = self.item.image;
        
        // Create sound objects
        self.itemSound = [self createSoundID:[@[@"SND_", self.item.name, @".mp3"] componentsJoinedByString:@""]];
        self.speechFirstLanguage = [self createSoundID:[@[@"SPC_", self.item.name, @"_", self.firstLanguage.code, @".m4a"] componentsJoinedByString:@""]];
        self.speechSecondLanguage = [self createSoundID:[@[@"SPC_", self.item.name, @"_", self.secondLanguage.code, @".m4a"] componentsJoinedByString:@""]];
        
        // If item has a sound (like an animal sound), play it when the image appears (if permitted in the settings)
        if ([[ZENGlobalSettings sharedStore] playAnimalSounds]) {
            AudioServicesPlaySystemSound(self.itemSound);
        }
        
        // Manage Arrow buttons
        NSUInteger index = [self.item.album.items indexOfObject: self.item];
        self.leftArrowButton.hidden = (index == 0) ? YES : NO; // first object : no left arrow
        self.rightArrowButton.hidden = (self.item == [self.item.album.items lastObject]) ? YES : NO; // last object : no right arrow
        
    }
}

#pragma mark - Sound management methods

- (SystemSoundID)createSoundID:(NSString *)path
{
    NSURL *resourceURL = self.item.album.dirURL;
    NSURL *filePath = [resourceURL URLByAppendingPathComponent:path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    if (soundID == 0) {
        NSLog(@"%@ not available at: %@", path, self.item.album.dirURL);
    }
    
    return soundID;
}


- (IBAction)playSound:(id)sender {
    
    SystemSoundID sound = 0;
    
    // Prepare sound to play & display item text
    if (sender == self.buttonImage) {
        if ([[ZENGlobalSettings sharedStore] playAnimalSounds]) {
            sound = self.itemSound;
        }
        
    } else if (sender == self.buttonFirstLanguage) {
        sound = self.speechFirstLanguage;
        if ([[ZENGlobalSettings sharedStore] displayItemNames]) {
            [self displayLabel:self.itemLabel withText:self.item.album.itemNames[self.firstLanguage.code][self.item.name] forDuration:1.0]; // iPad
            [self displayLabel:self.titleLabel withText:self.item.album.itemNames[self.firstLanguage.code][self.item.name] forDuration:1.0]; // iPhone
        }
     
    } else if (sender == self.buttonSecondLanguage) {
        sound = self.speechSecondLanguage;
        if ([[ZENGlobalSettings sharedStore] displayItemNames]) {
            [self displayLabel:self.itemLabel withText:self.item.album.itemNames[self.secondLanguage.code][self.item.name] forDuration:1.0]; // iPad
            [self displayLabel:self.titleLabel withText:self.item.album.itemNames[self.secondLanguage.code][self.item.name] forDuration:1.0]; // iPhone

        }
    }

    // Play sound
    AudioServicesPlaySystemSound(sound);

}


- (void)displayLabel:(UILabel *)label withText:(NSString *)text forDuration:(float)duration
{
    [label setText:text];
    [label setAlpha:0.0];

    // Fade in
    [UIView animateWithDuration:duration / 2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         [label setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                         {
                             // Fade out
                             [UIView animateWithDuration:duration / 2
                                                   delay:duration
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(void) {
                                                  [label setAlpha:0.0];
                                              }
                                              completion:^(BOOL finished) {
                                                  if(finished) {
                                                      label.text = nil;
                                                  }
                                              }];
                         }
                     }];
}



#pragma mark - Gesture recognizers

- (IBAction)displayPreviousItem:(id)sender
{
    if (self.item != self.item.album.items[0]) {
        
        [UIView transitionWithView:self.mainImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.itemLabel.text = nil;
                            NSUInteger currentIndex = [self.item.album.items indexOfObject:self.item];
                            self.item = self.item.album.items[currentIndex - 1];
                        }
                        completion:NULL];
        
        NSLog(@"Passed to previous item : %@", self.item.name);
    }
}

- (IBAction)displayNextItem:(id)sender
{
    if (self.item != [self.item.album.items lastObject]) {
        self.rightArrowButton.hidden = NO;
        
        [UIView transitionWithView:self.mainImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.itemLabel.text = nil;
                            NSUInteger currentIndex = [self.item.album.items indexOfObject:self.item];
                            self.item = self.item.album.items[currentIndex + 1];
                        }
                        completion:NULL];
        
        NSLog(@"Passed to next item : %@", self.item.name);
    }
}


#pragma mark - Manage rotation
// especially useful to know if rotation has occurred for iPad ZoomInAnimation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"Device did Rotate");
    self.hasDeviceRotated = YES;
}
@end
