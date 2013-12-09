//
//  ZENAlbumImageCell.h
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 10/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

@class ZENItem;
@class ZENItemView;

@interface ZENAlbumImageCell : UICollectionViewCell
@property (strong, nonatomic) ZENItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@end
