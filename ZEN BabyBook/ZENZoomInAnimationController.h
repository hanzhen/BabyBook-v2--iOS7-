//
//  ZENZoomInAnimationController.h
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 08/12/2013.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "CEReversibleAnimationController.h"

@interface ZENZoomInAnimationController : CEReversibleAnimationController

/*
 Animates between the two view controllers by zooming in from a small view to the final view.
 */

@property (nonatomic) CGRect fromRect; // the rect zone to snapshot in the source VC (forwards and reverse transition)
@property (nonatomic) CGRect toRect; // the rect zone to get to in the destination VC (reverse transition only)

@end
