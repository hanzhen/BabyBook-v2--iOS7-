//
//  ZENContentStore.m
//  ZENImageBook
//
//  Created by Frédéric ADDA on 17/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENContentStore.h"
#import "ZENAlbum.h"


@interface ZENContentStore ()
@property (strong, readwrite, nonatomic) NSMutableArray *allAlbums;
@end


@implementation ZENContentStore


+ (ZENContentStore *)sharedStore
{
    static ZENContentStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}


- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL * resourceURL = [NSBundle mainBundle].resourceURL;
        // Unlock albums bundled in the application
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"AnimalsFarm"]];
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"Colors"]];
        
        // For test purposes - should be unlocked via in-app purchase
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"Fruits"]];
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"Vegetables"]];
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"AnimalsOcean"]];
        [self unlockAlbumWithDirURL:[resourceURL URLByAppendingPathComponent:@"AnimalsSavanna"]];
        
    }
    
    return self;
}


- (void)unlockAlbumWithDirURL:(NSURL *)url
{
    ZENAlbum *album = [[ZENAlbum alloc] initWithDirURL:url];
    
    if (album) {
        // Make sure we don't already have this album
        BOOL found = FALSE;
        for (int i = 0; i < self.allAlbums.count; i++) {
            ZENAlbum *currentAlbum = self.allAlbums[i];
            if ([album.name isEqualToString:currentAlbum.name]) {
                NSLog(@"Album %@ already present : replacing ...", album.name);
                self.allAlbums[i] = album;
                found = TRUE;
                break;
            }
        }
        if (!found) {
            // Unlock new album
            NSLog(@"Album unlocked : %@", album.name);
            [self.allAlbums addObject:album];
        }
        
    } else {
        NSLog(@"Album is nil ?!");
    }
}


- (void)unlockContentWithDirURL:(NSURL *)dirURL { // downloaded albums
    
    // First case : the content is included directly in the directory
    // Look for an album (Album.plist) at that level
    if ([ZENAlbum albumAtURL:dirURL]) {
        [self unlockAlbumWithDirURL:dirURL];
    } else {
        
        // Second case : the content is included in sub-directories of the directory
        // Loop through the sub-directories to find one or many albums
        
        NSArray *urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dirURL
                                                      includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil];
        
        if (urls) {
            NSError *error = nil;
            NSNumber *isDirectory;
            int numberOfAlbumsFound = 0;
            
            for (NSURL *subURL in urls) {
                // Is the sub-URL a directory ?
                if ([subURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
                    
                    // If an album is found here,
                    if ([ZENAlbum albumAtURL:subURL]) {
                        [self unlockAlbumWithDirURL:subURL];
                        numberOfAlbumsFound += 1;
                    }
                }
            }
            
            if (numberOfAlbumsFound == 0) {
                NSLog(@"Unexpected content!");
            }
        }
    }
}


#pragma mark - Override properties getters (lazy instantiation)

- (NSArray *)allAlbums
{
    if (!_allAlbums) _allAlbums = [[NSMutableArray alloc] init];    
    return _allAlbums;
}


@end
