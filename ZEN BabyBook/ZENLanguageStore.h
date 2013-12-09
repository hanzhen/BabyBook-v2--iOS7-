//
//  ZENLanguageStore.h
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 28/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

 

@interface ZENLanguageStore : NSObject

+ (ZENLanguageStore *)sharedStore;

@property (strong, readonly, nonatomic) NSArray *allLanguages;
@property (strong, readonly, nonatomic) NSMutableDictionary *allLanguagesDict; // useful for initializing defaults


@end
