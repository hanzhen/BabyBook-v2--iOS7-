//
//  ZENLanguagePickerViewController.h
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 14/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//


@interface ZENLanguagePickerViewController : UITableViewController

// The LanguagePickerVC is used to select both the first and the second language
// In the SettingsTVC, the sender cell's tag is used to know which language we are selecting (1 or 2)
@property (weak, nonatomic) UITableViewCell *sender;
@end
