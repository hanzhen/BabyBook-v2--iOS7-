//
//  ZENSettingsTableViewController.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 18/02/13.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "ZENSettingsTableViewController.h"
#import "ZENGlobalSettings.h"
#import "ZENLanguagePickerViewController.h"
#import "ZENLanguage.h"

@interface ZENSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayItemNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *displayItemNameSwitch;
@property (weak, nonatomic) IBOutlet UILabel *playAnimalSoundsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *playAnimalSoundsSwitch;

@end


@implementation ZENSettingsTableViewController


#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    self.title = NSLocalizedString(@"Settings", @"Settings title");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Display item name SWITCH
    self.displayItemNameLabel.text = NSLocalizedString(@"Display name while speaking", @"Display name while speaking");
    self.displayItemNameSwitch.on = ([[ZENGlobalSettings sharedStore] displayItemNames] == YES) ? YES : NO;
    [self.displayItemNameSwitch addTarget:self action:@selector(updateDisplayItemInGlobalSettings) forControlEvents:UIControlEventValueChanged];

    // Play animal sound SWITCH
    self.playAnimalSoundsLabel.text = NSLocalizedString(@"Play animal sounds", @"Play animal sounds");
    self.playAnimalSoundsSwitch.on = ([[ZENGlobalSettings sharedStore] playAnimalSounds] == YES) ? YES : NO;
    [self.playAnimalSoundsSwitch addTarget:self action:@selector(updatePlayAnimalSoundsInGlobalSettings) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static cells
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        if (indexPath.section == 0) { // Languages
            if (cell.tag == 1) {
                cell.textLabel.text = NSLocalizedString(@"First Language", @"First language");
                cell.detailTextLabel.text = [[[ZENGlobalSettings sharedStore] firstLanguage] description];
            } else if (cell.tag == 2) {
                cell.textLabel.text = NSLocalizedString(@"Second Language", @"Second language");
                cell.detailTextLabel.text = [[[ZENGlobalSettings sharedStore] secondLanguage] description];
            }
        } else if (indexPath.section == 2) { // Information
            cell.textLabel.text = NSLocalizedString(@"Credits", @"Credits");
        }
    }
    return cell;    
}


#pragma mark - TableView delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    if (section == 0) { //Languages
        sectionTitle = NSLocalizedString(@"Languages", @"Languages");
    } else if (section == 1) { // Display item names
        sectionTitle = NSLocalizedString(@"Item settings", @"Item settings");
    } else if (section == 2) { // Information
        sectionTitle = NSLocalizedString(@"Information", @"Information");
    }
    
    return sectionTitle;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectFirstLanguage"] || [segue.identifier isEqualToString:@"SelectSecondLanguage"] ) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            if ([segue.destinationViewController isKindOfClass:[ZENLanguagePickerViewController class]]) {
                ZENLanguagePickerViewController *languagePicker = (ZENLanguagePickerViewController *)segue.destinationViewController;
                languagePicker.sender = sender;
            }
        }
    }
}

#pragma mark - Custom methods

- (void)updateDisplayItemInGlobalSettings
{
    if ([self.displayItemNameSwitch isOn]) {
        [[ZENGlobalSettings sharedStore] setDisplayItemNames:YES];
    } else {
        [[ZENGlobalSettings sharedStore] setDisplayItemNames:NO];
    }
    NSLog(@"Global settings / display Item names : %i", [[ZENGlobalSettings sharedStore] displayItemNames]);
}

- (void)updatePlayAnimalSoundsInGlobalSettings
{
    if ([self.playAnimalSoundsSwitch isOn]) {
        [[ZENGlobalSettings sharedStore] setPlayAnimalSounds:YES];
    } else {
        [[ZENGlobalSettings sharedStore] setPlayAnimalSounds:NO];
    }
    NSLog(@"Global settings / play animal sounds : %i", [[ZENGlobalSettings sharedStore] playAnimalSounds]);
}

@end
