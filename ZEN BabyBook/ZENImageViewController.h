//
//  ZENImageViewController.h
//  ZENImageBook
//
//  Created by Frédéric ADDA on 10/12/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//


@class ZENItem;
@class ZENLanguage;

@interface ZENImageViewController : UIViewController

@property (strong, nonatomic) ZENLanguage *firstLanguage;
@property (strong, nonatomic) ZENLanguage *secondLanguage;
@property (strong, nonatomic) ZENItem *item;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end
