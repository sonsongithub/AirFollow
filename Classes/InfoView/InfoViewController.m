//
//  InfoViewController.m
//  2tch
//
//  Created by sonson on 09/07/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "LicenseViewController.h"

@implementation InfoViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controllerWithNavigationController {
	InfoViewController* con = [[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (id)infoValueForKey:(NSString*)key {
	if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (UITableViewCell *)tableView:(UITableView *)tableView obtainCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = nil;
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	UITextAlignment alignment = UITextAlignmentLeft;
	
	if (indexPath.section == 0) {
		if (indexPath.row < 3) {
			CellIdentifier = @"Attribute";
			style = UITableViewCellStyleValue1;
			alignment = UITextAlignmentLeft;
		}
		else {
			CellIdentifier = @"Centered";
			style = UITableViewCellStyleDefault;
			alignment = UITextAlignmentCenter;
		}
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textAlignment = alignment;
    }
	return cell;
}

#pragma mark -
#pragma mark Button callback

- (void)doneButton:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
	self.title = NSLocalizedString(@"Info", nil);
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)];
	doneButton.style = UIBarButtonItemStyleDone;
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DNSLogMethod
	
	if (actionSheet.tag == InfoViewOpenSupport) {
		if (buttonIndex == 0) {
			// Push mail button
			DNSLog(@"Compose new mail");
			//
			// Mail composer
			//
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			
			//
			// Attach an image to the email
			//
			[picker setSubject:NSLocalizedString(@"[AirFollow contact] ", nil)];
			[picker setToRecipients:[NSArray arrayWithObject:NSLocalizedString(@"SupportMailAddress", nil)]];
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else if (buttonIndex == 1) {
			// Push "open safari" button
			DNSLog(@"Open support site");
			NSURL *URL = [NSURL URLWithString:NSLocalizedString(@"WebSiteURL", nil)];
			[[UIApplication sharedApplication] openURL:URL];
		}
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Application", nil);
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 5;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView obtainCellForRowAtIndexPath:indexPath];
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Name", nil);
			cell.detailTextLabel.text = [self infoValueForKey:@"CFBundleDisplayName"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Version", nil);
#ifdef _DEBUG
			NSString *str = [NSString stringWithFormat:@"%@(r%@) Debug", [self infoValueForKey:@"CFBundleVersion"], [self infoValueForKey:@"CFBundleRevision"]];
#else
			NSString *str = [NSString stringWithFormat:@"%@(r%@)", [self infoValueForKey:@"CFBundleVersion"], [self infoValueForKey:@"CFBundleRevision"]];
#endif
			cell.detailTextLabel.text = str;
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Copyright", nil);
			cell.detailTextLabel.text = NSLocalizedString(@"sonson", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 3) {
			cell.textLabel.text = NSLocalizedString(@"License", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		if (indexPath.row == 4) {
			cell.textLabel.text = NSLocalizedString(@"Contact", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.section == 0) {
		if (indexPath.row == 3) {
			LicenseViewController *controller = [LicenseViewController defaultController];
			[self.navigationController pushViewController:controller animated:YES];
		}
		if (indexPath.row == 4) {
			// Clicked "Contact"
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Contact, please send unknown bugs or your feedback.", nil) 
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:nil
													  otherButtonTitles:NSLocalizedString(@"Mail with Mail.app", nil), NSLocalizedString(@"Open Site with Safari", nil), nil];
			[sheet showFromToolbar:self.navigationController.toolbar];
			[sheet release];
			sheet.tag = InfoViewOpenSupport;
		}
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
	[[NSNotificationCenter defaultCenter] removeObserver:self.tableView];
    [super dealloc];
}

@end

