//
//  ZENItem.h
//  ZENImageBook
//
//  Created by Frédéric ADDA on 17/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//
@class ZENAlbum;

@interface ZENItem : NSObject <NSCoding>

@property (copy, nonatomic)     NSString *name;
@property (strong, nonatomic)   UIImage *image;
@property (weak, nonatomic)     ZENAlbum *album;

- (id)initWithName:(NSString *)name;

@end
