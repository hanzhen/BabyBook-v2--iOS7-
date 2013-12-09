//
//  ZENAlbumImageCell.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 10/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENAlbumImageCell.h"
#import "ZENItem.h"
@import QuartzCore;


@implementation ZENAlbumImageCell

- (void)setItem:(ZENItem *)item
{
    _item = item;
    self.itemImageView.image = _item.image;
}

@end
