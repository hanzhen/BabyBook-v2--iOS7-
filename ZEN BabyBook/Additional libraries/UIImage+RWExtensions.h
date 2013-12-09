//
//  UIImage+RWExtensions.h
//  Hangman
//
//  Created by Ray Wenderlich on 7/11/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

@interface UIImage (RWExtensions)
+ (UIImage *)rw_imageWithContentsOfURL:(NSURL *)url;
- (id)rw_initWithContentsOfURL:(NSURL *)url;

@end
