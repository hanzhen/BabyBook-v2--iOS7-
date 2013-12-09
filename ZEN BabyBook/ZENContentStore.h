//
//  ZENContentStore.h
//  ZENImageBook
//
//  Created by Frédéric ADDA on 17/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

@interface ZENContentStore : NSObject

+ (ZENContentStore *)sharedStore;

@property (strong, readonly, nonatomic) NSMutableArray *allAlbums;

- (void)unlockContentWithDirURL:(NSURL *)dirURL;
- (void)unlockAlbumWithDirURL:(NSURL *)url;

@end
