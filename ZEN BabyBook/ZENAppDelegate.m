//
//  ZENAppDelegate.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 03/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENAppDelegate.h"

#import "ZENLanguage.h"
#import "ZENLanguageStore.h"

#define ZENBabybookFirstLanguagePrefKey    @"ZENBabybookFirstLanguagePrefKey"
#define ZENBabybookSecondLanguagePrefKey   @"ZENBabybookSecondLanguagePrefKey"
#define ZENBabyBookDisplayItemNamesPrefKey @"ZENBabyBookDisplayItemNamesPrefKey"
#define ZENBabyBookPlayAnimalSoundsPrefKey @"ZENBabyBookPlayAnimalSoundsPrefKey"

@implementation ZENAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // Initialize defaults in NSUserDefaults
    [self initializeDefaults];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - custom methods
// Initialize defaults in NSUserDefaults
- (void)initializeDefaults
{

    // FIRST DEFAULT LANGUAGE
    NSString *defaultFirstLanguageCode = @"FR";
    NSLog(@"First language is %@", defaultFirstLanguageCode);
    
    // SECOND DEFAULT LANGUAGE
    NSString *defaultSecondLanguageCode = @"EN";
    NSLog(@"Second language is %@", defaultSecondLanguageCode);

    
    // DISPLAY ITEM NAMES DEFAULT
    NSString *displayItemNames = @"YES";
    NSLog(@"Display item names : %@", displayItemNames);
    
    // PLAY ANIMAL SOUNDS DEFAULT
    NSString *playAnimalSounds = @"YES";
    NSLog(@"Play Animal sounds : %@", playAnimalSounds);
    
    
    // RegisterDefaults dictionary
    NSDictionary *defaults = @{ZENBabybookFirstLanguagePrefKey: defaultFirstLanguageCode,
                               ZENBabybookSecondLanguagePrefKey: defaultSecondLanguageCode,
                               // no need to explicitely use [NSNumber numberwithBool] in a dictionary, it is possible to use a string with @"YES" or @"NO"
                               ZENBabyBookDisplayItemNamesPrefKey: displayItemNames,
                               ZENBabyBookPlayAnimalSoundsPrefKey: playAnimalSounds};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
}

@end
