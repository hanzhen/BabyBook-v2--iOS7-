//
//  ZENLanguage.h
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 14/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

@interface ZENLanguage : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *flagImageName;

// designated initializer
- (id)initWithCode:(NSString *)code Description:(NSString *)description Image:(NSString *)imageName;

@end
