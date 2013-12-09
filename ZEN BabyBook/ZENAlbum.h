//
//  ZENAlbum.h
//  ZENImageBook
//
//  Created by Frédéric ADDA on 06/01/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

@class ZENItem;

@interface ZENAlbum : NSObject

@property (strong, nonatomic, readonly) NSURL *dirURL; // URL of album content
@property (copy, nonatomic, readonly)   NSString *name;
@property (copy, nonatomic, readonly)   NSString *color;
@property (copy, nonatomic, readonly)   ZENItem *coverItem;
@property (strong, nonatomic, readonly) NSMutableDictionary *titles; // dictionary of album translations
@property (strong, nonatomic, readonly) NSMutableArray *items; // array of Item
@property (strong, nonatomic, readonly) NSMutableDictionary *itemNames; // dictionary of item translations


+ (BOOL)albumAtURL:(NSURL *)url;

- (id)initWithDirURL:(NSURL *)url;
- (ZENItem *)itemAtIndex:(NSUInteger)index;


@end
