//
//  ZENAlbum.m
//  ZENImageBook
//
//  Created by Frédéric ADDA on 06/01/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENAlbum.h"
#import "ZENItem.h"


@interface ZENAlbum ()

@property (copy, nonatomic, readwrite)   NSString *color;
@property (copy, nonatomic, readwrite)   ZENItem *coverItem;
@property (strong, nonatomic, readwrite) NSMutableDictionary *titles; // dictionary of album translations
@property (strong, nonatomic, readwrite) NSMutableArray *items; // array of items
@property (strong, nonatomic, readwrite) NSMutableDictionary *itemNames; // dictionary of item translations

@end


@implementation ZENAlbum

// Designated initializer
- (id)initWithDirURL:(NSURL *)url 
{
    self = [super init];
    
    if (self) {
        _dirURL = url;
        
        // Get content of the album plist file as a dictionary
        NSURL *plistURL = [url URLByAppendingPathComponent:@"Album.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
        if (dict == nil) return nil;
        
        // Get the album folder
        _name = dict[@"name"];
        
        // Get the album color
        _color = dict[@"color"];
        
        // Get the album title translations
        _titles = [[NSMutableDictionary alloc] initWithDictionary:dict[@"titles"]];
        
        // Get the album items
        _items = [[NSMutableArray alloc] init];
        _itemNames = [[NSMutableDictionary alloc] initWithDictionary:dict[@"items"]];

        // The names of the items are the keys in every "items" dictionary : let's take the EN version
        NSArray *itemsArray = [_itemNames[@"EN"] allKeys]; // allKeys : the order is not defined
        
        
        [itemsArray enumerateObjectsUsingBlock:^(NSString *itemName, NSUInteger idx, BOOL *stop) {
            ZENItem *item = [[ZENItem alloc] initWithName:itemName];
            [_items addObject:item];
//            NSLog(@"Item created : %@, index : %i", item.name, [_items indexOfObject:item]);
            item.album = self;
            
            if ([item.name isEqualToString:dict[@"coverItem"]]) {
                _coverItem = item;
            }
        }];
    }
    return self;
}


// Getter for coverItem
- (ZENItem *)coverItem
{
    if (!_coverItem) {
        // If no coverItem was set during the init, then use the first item of the array
        _coverItem = [self.items firstObject];
    }
    return _coverItem;
}


- (ZENItem *)itemAtIndex:(NSUInteger)index
{
    return (index < [self.items count]) ? self.items[index] : nil;
}


#pragma mark - album resource URL management

+ (BOOL)albumAtURL:(NSURL *)url {
    NSURL * plistURL = [url URLByAppendingPathComponent:@"Album.plist" isDirectory:NO];
//    [self listFileAtPath:url.path];
    return [[NSFileManager defaultManager] fileExistsAtPath:plistURL.path];
}


+ (NSArray *)listFileAtPath:(NSString *)path
{
    // List files at a given path
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++) {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

@end
