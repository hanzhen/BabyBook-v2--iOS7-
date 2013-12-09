//
//  ZENLanguagePickerViewController.m
//  ZEN Portfolio
//
//  Created by Frédéric ADDA on 14/10/12.
//  Copyright (c) 2012 Frédéric ADDA. All rights reserved.
//

#import "ZENLanguagePickerViewController.h"
#import "ZENGlobalSettings.h"
#import "ZENLanguageStore.h"
#import "ZENLanguage.h"
#import "ZENLanguageTableViewCell.h"



@interface ZENLanguagePickerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSIndexPath* checkedIndexPath;
@end



@implementation ZENLanguagePickerViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    if (self.sender.tag == 1) {
        self.title = NSLocalizedString(@"First Language",@"First Language");
    } else if (self.sender.tag == 2) {
        self.title = NSLocalizedString(@"Second Language",@"Second Language");
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Table view data source methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[ZENLanguageStore sharedStore] allLanguages] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZENLanguage *l = [[ZENLanguageStore sharedStore] allLanguages][indexPath.row];
    ZENLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LanguagePickerCell"];
    
    cell.languageLabel.text = l.description;
    cell.flagImageView.image = [UIImage imageNamed:l.flagImageName];
    
    // Mark the selected cell
    if (self.sender.tag == 1) {
        if ([l.code isEqual:[[[ZENGlobalSettings sharedStore] firstLanguage] code]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.checkedIndexPath = indexPath;            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (self.sender.tag == 2) {
        if ([l.code isEqual:[[[ZENGlobalSettings sharedStore] secondLanguage] code]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.checkedIndexPath = indexPath;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    return cell;
    
}


#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    ZENLanguage *selectedLanguage = [[ZENLanguageStore sharedStore] allLanguages][indexPath.row];
    
    
    // Remove checkmark from the previously marked cell
    previouslySelectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    // Add checkmark to the selected cell
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;
    
    // Animate deselection of cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Stock the new language as NSUserDefaults
    if (self.sender.tag == 1) {
        [[ZENGlobalSettings sharedStore] setFirstLanguage:selectedLanguage];
        NSLog(@"Global settings / first language selected : %@", [[[ZENGlobalSettings sharedStore] firstLanguage] code]);
        
    } else if (self.sender.tag == 2) {
        [[ZENGlobalSettings sharedStore] setSecondLanguage:selectedLanguage];
        NSLog(@"Global settings / second language selected : %@", [[[ZENGlobalSettings sharedStore] secondLanguage] code]);
    }
    
    // Update the description of the chosen language in the Settings TV
    self.sender.detailTextLabel.text = selectedLanguage.description;
    
    // Dismiss language picker view controller after delay
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@"YES" afterDelay:0.25]; // possible too : withObject:@1

}

@end
