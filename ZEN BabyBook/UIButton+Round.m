//
//  UIButton+Round.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 03/12/2013.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "UIButton+Round.h"

@implementation UIButton (Round)

+ (void)makeRoundButton:(UIButton *)button WithImageNamed:(NSString *)name {
    
    button.layer.cornerRadius = button.bounds.size.width / 2.0; // makes the button round
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // the icon used in the button gets the tintColor of the view
    [button setImage:image forState:UIControlStateNormal];
    
}

@end
