//
//  ZENAlbumCoverCell.h
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 16/03/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

@class ZENAlbum;

@interface ZENAlbumCoverCell : UICollectionViewCell
@property (strong, nonatomic) ZENAlbum *album;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@end
