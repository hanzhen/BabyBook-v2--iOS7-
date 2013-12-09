//
//  ZENGlobalSettings.h
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 28/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

@class ZENLanguage;

@interface ZENGlobalSettings : NSObject

+ (ZENGlobalSettings *)sharedStore;

@property (copy, nonatomic) ZENLanguage *firstLanguage;
@property (copy, nonatomic) ZENLanguage *secondLanguage;
@property (nonatomic) BOOL displayItemNames;
@property (nonatomic) BOOL playAnimalSounds;

@end
