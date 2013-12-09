//
//  UIImage+RWExtensions.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "UIImage+RWExtensions.h"

@implementation UIImage (RWExtensions)

+ (UIImage *)rw_imageWithContentsOfURL:(NSURL *)url {
    return [[UIImage alloc] rw_initWithContentsOfURL:url];
}

- (id)rw_initWithContentsOfURL:(NSURL *)url {
    
    NSURL *toLoad = url;
    
    // Retina display: check for @2x version
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {

        NSURL * parentDirectory = [url URLByDeletingLastPathComponent];
        NSString * lastPathComponent = [url lastPathComponent];
        NSString * lastPathComponentWithNoExtension = [lastPathComponent stringByDeletingPathExtension];
        NSString * extension = [url pathExtension];
        NSString * filename2X = [NSString stringWithFormat:@"%@@2x.%@", lastPathComponentWithNoExtension, extension];

        NSURL * url2x = [parentDirectory URLByAppendingPathComponent:filename2X];
        if ([[NSFileManager defaultManager] fileExistsAtPath:url2x.path]) {
            toLoad = url2x;
        }
    }
    
    NSData * data = [NSData dataWithContentsOfURL:toLoad];
    return [[UIImage alloc] initWithData:data];
    
}


@end
