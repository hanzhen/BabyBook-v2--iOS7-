//
//  ZENGlobalSettings.m
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 28/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENGlobalSettings.h"
#import "ZENLanguageStore.h"
#import "ZENLanguage.h"

NSString * const ZENBabybookFirstLanguagePrefKey                = @"ZENBabybookFirstLanguagePrefKey";
NSString * const ZENBabybookSecondLanguagePrefKey               = @"ZENBabybookSecondLanguagePrefKey";
NSString * const ZENBabyBookDisplayItemNamesPrefKey             = @"ZENBabyBookDisplayItemNamesPrefKey";
NSString * const ZENBabyBookPlayAnimalSoundsPrefKey             = @"ZENBabyBookPlayAnimalSoundsPrefKey";


@implementation ZENGlobalSettings

+ (ZENGlobalSettings *)sharedStore
{
    static ZENGlobalSettings *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}


#pragma mark - LANGUAGES
// firstLanguage : override getter and setter methods
- (ZENLanguage *)firstLanguage
{
    // Point to NSUserDefaults to retrieve the first language
    NSString *firstLanguageDefaultCode = [[NSUserDefaults standardUserDefaults] objectForKey:ZENBabybookFirstLanguagePrefKey];
    ZENLanguage *firstLanguageDefault = [[ZENLanguageStore sharedStore] allLanguagesDict][firstLanguageDefaultCode];
    return firstLanguageDefault;
}

- (void)setFirstLanguage:(ZENLanguage *)firstLanguage
{
    // Store the first language code as NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:firstLanguage.code forKey:ZENBabybookFirstLanguagePrefKey];
    NSLog(@"Saved first language %@ in NSUserDefaults",firstLanguage.code);

}

// secondLanguage : override getter and setter methods
- (ZENLanguage *)secondLanguage
{
    // Point to NSUserDefaults to retrieve the second language
    NSString *secondLanguageDefaultCode = [[NSUserDefaults standardUserDefaults] objectForKey:ZENBabybookSecondLanguagePrefKey];
    ZENLanguage *secondLanguageDefault = [[ZENLanguageStore sharedStore] allLanguagesDict][secondLanguageDefaultCode];
    return secondLanguageDefault;
}

- (void)setSecondLanguage:(ZENLanguage *)secondLanguage
{
    // Store the second language code as NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:secondLanguage.code forKey:ZENBabybookSecondLanguagePrefKey];
    NSLog(@"Saved second language %@ in NSUserDefaults",secondLanguage.code);
}


#pragma mark - DISPLAY ITEM NAMES
// display item name : override getter and setter methods
- (BOOL)displayItemNames
{
    // Point to NSUserDefaults to retrieve the displayItemNames Bool
    return [[NSUserDefaults standardUserDefaults] boolForKey:ZENBabyBookDisplayItemNamesPrefKey];
}

- (void)setDisplayItemNames:(BOOL)displayItemNames
{
    // Store the first language as NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:displayItemNames forKey:ZENBabyBookDisplayItemNamesPrefKey];
    NSLog(@"Saved displayItemNames %i in NSUserDefaults",displayItemNames);
}



#pragma mark - PLAY ANIMAL SOUNDS
// play animal sounds : override getter and setter methods
- (BOOL)playAnimalSounds
{
    // Point to NSUserDefaults to retrieve the displayItemNames Bool
    return [[NSUserDefaults standardUserDefaults] boolForKey:ZENBabyBookPlayAnimalSoundsPrefKey];
}

- (void)setPlayAnimalSounds:(BOOL)playAnimalSounds
{
    // Store the first language as NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:playAnimalSounds forKey:ZENBabyBookPlayAnimalSoundsPrefKey];
    NSLog(@"Saved playAnimalSounds %i in NSUserDefaults",playAnimalSounds);
}
@end
