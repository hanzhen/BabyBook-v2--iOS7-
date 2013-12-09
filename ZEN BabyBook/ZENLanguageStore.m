//
//  ZENLanguageStore.m
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 28/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENLanguageStore.h"
#import "ZENLanguage.h"


@interface ZENLanguageStore ()
@property (strong, readwrite, nonatomic) NSArray *allLanguages;
@property (strong, readwrite, nonatomic) NSMutableDictionary *allLanguagesDict;
@end



@implementation ZENLanguageStore

+ (ZENLanguageStore *)sharedStore
{
    static ZENLanguageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}


- (id)init
{
    self = [super init];
    if (self) {
        
        _allLanguages = @[
                          [[ZENLanguage alloc] initWithCode:@"FR"           Description:@"Français"                  Image:@"FLAG_France.png"],
                          [[ZENLanguage alloc] initWithCode:@"PT"           Description:@"Português (Brasil)"        Image:@"FLAG_Brazil.png"],
                          [[ZENLanguage alloc] initWithCode:@"EN-GB"        Description:@"English (UK)"              Image:@"FLAG_United-kingdom.png"],
                          [[ZENLanguage alloc] initWithCode:@"EN"           Description:@"English (USA)"             Image:@"FLAG_United-states.png"],
                          [[ZENLanguage alloc] initWithCode:@"IT"           Description:@"Italiano"                  Image:@"FLAG_Italy.png"],
                          [[ZENLanguage alloc] initWithCode:@"ES"           Description:@"Español"                   Image:@"FLAG_Spain.png"],
                          [[ZENLanguage alloc] initWithCode:@"DE"           Description:@"Deutsch"                   Image:@"FLAG_Germany.png"],
                          [[ZENLanguage alloc] initWithCode:@"DA"           Description:@"Dansk"                     Image:@"FLAG_Denmark.png"],
                          [[ZENLanguage alloc] initWithCode:@"SV"           Description:@"Svenska"                   Image:@"FLAG_Sweden.png"],
                          [[ZENLanguage alloc] initWithCode:@"TR"           Description:@"Türkçe"                    Image:@"FLAG_Turkey.png"],
                          [[ZENLanguage alloc] initWithCode:@"HE"           Description:@"עברית"                     Image:@"FLAG_Israel.png"],
                          [[ZENLanguage alloc] initWithCode:@"AR"           Description:@"العربية"                       Image:@"FLAG_Morocco.png"],
                          [[ZENLanguage alloc] initWithCode:@"ZH-HANS"      Description:@"中文"                       Image:@"FLAG_China.png"]
                          ];
        
        // NB : be careful to use ISO codes for languages, as the album names are displayed according to the current language of the system
        
        
        // Constitute array with all language symbols
        _allLanguagesDict = [[NSMutableDictionary alloc] init];
        [_allLanguages enumerateObjectsUsingBlock:^(ZENLanguage *language, NSUInteger idx, BOOL *stop) {
            [_allLanguagesDict setValue:language forKey:language.code];
        }];
    }
    
    return self;
}


@end
