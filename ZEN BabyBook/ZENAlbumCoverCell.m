//
//  ZENAlbumCoverCell.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 16/03/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENAlbumCoverCell.h"
#import "ZENAlbum.h"
#import "ZENItem.h"
#import "UIColor+ZENColor.h"


@implementation ZENAlbumCoverCell

- (void)setAlbum:(ZENAlbum *)album
{
    _album = album;
    
    // Album image view
    self.albumImageView.image = _album.coverItem.image;
    
    // Album cover color
    if ([_album.color isEqualToString:@"blue"]) {
        self.backgroundColor = [UIColor ZENBlueColor];
    } else if ([_album.color isEqualToString:@"green"]) {
        self.backgroundColor = [UIColor ZENGreenColor];
    } else if ([_album.color isEqualToString:@"orange"]) {
        self.backgroundColor = [UIColor ZENOrangeColor];
    } else if ([_album.color isEqualToString:@"yellow"]) {
        self.backgroundColor = [UIColor ZENYellowColor];
    } else if ([_album.color isEqualToString:@"red"]) {
        self.backgroundColor = [UIColor ZENRedColor];
    } else if ([_album.color isEqualToString:@"purple"]) {
        self.backgroundColor = [UIColor ZENPurpleColor]; {
        }
    }
    
    // Album name according to user language
    NSString *userLanguage = [[[NSLocale preferredLanguages] firstObject] uppercaseString];
    if (_album.titles[userLanguage]) {
        self.albumLabel.text = _album.titles[userLanguage]; // should work because language codes in the ZENLanguageStore are ISO-compliant
    } else {
        self.albumLabel.text = _album.titles[@"EN"];
    }
    
    
}

@end
