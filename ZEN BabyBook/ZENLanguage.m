//
//  ZENLanguage.m
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 14/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENLanguage.h"

@implementation ZENLanguage


// Designated initializer
- (id)initWithCode:(NSString *)code Description:(NSString *)description Image:(NSString *)imageName
{
    self = [super init];
    
    if (self) {
        _code = code;
        _description = description;
        _flagImageName = imageName;
    }
    
    return self;
}

- (id)init
{
    return [self initWithCode:@"XX" Description:@"Unknown"  Image:nil];
    NSLog(@"Don't use ""init"" initializer ! Use ""initWithSymbol:Description:Image:"" instead");
}


#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.flagImageName forKey:@"flagImageName"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _code = [aDecoder decodeObjectForKey:@"code"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _flagImageName = [aDecoder decodeObjectForKey:@"flagImageName"];
    }
    
    return self;
}


@end
