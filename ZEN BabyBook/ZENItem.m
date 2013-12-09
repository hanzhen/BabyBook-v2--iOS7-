//
//  ZENItem.m
//  ZENImageBook
//
//  Created by Frédéric ADDA on 17/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENItem.h"
#import "ZENAlbum.h"
#import "UIImage+RWExtensions.h"

@implementation ZENItem 


// Designated initializer
- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        _name = name;
    }
    
    return self;
}

- (id)init
{
    return [self initWithName:@"Name"];
}


#pragma mark - override getter / setter methods

- (UIImage *)image
{
    if (!_image) {
        // Determine the image name of the item in resource folder      
        NSString *itemImageString = [@[@"IMG_", self.name, @".png"] componentsJoinedByString:@""];
        _image = [UIImage rw_imageWithContentsOfURL:[self.album.dirURL URLByAppendingPathComponent:itemImageString
                                                                                                isDirectory:NO]];
    }
    return _image;
}



#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
    }
    
    return self;
}


@end
