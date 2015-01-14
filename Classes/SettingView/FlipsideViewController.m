//
//  FlipsideViewController.m
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditingTableViewCell.h"
#import "SwitchCell.h"
#import "SNSAccountEditViewController.h"
#import "SNSTaskQueue.h"
#import "SNSTask.h"
#import "SNSFollowTool.h"
#import "SNDownloadManager.h"

#import "TwitterEngineController.h"

@implementation FlipsideViewController

@synthesize delegate;

#pragma mark -
#pragma mark Instance method

- (void)setSNSAccountView {
	if ([self.navigationController.topViewController isKindOfClass:[SNSAccountEditViewController class]]) {
	}
	else {
		SNSAccountEditViewController *con = [[SNSAccountEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[self.navigationController pushViewController:con animated:NO];
		[con release];
	}
}

- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self]; 
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	}
	else if (section == 1) {
		return [[SNSTaskQueue sharedInstance].queue count];
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 1) {
		if ([[SNSTaskQueue sharedInstance].queue count]) {
			return @"";
		}
		else {
			return NSLocalizedString(@"There is no remained task.", nil);
		}
	}
	return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return NSLocalizedString(@"Account", nil);
		case 1:
			return NSLocalizedString(@"Remained follow task", nil);
		default:
			return nil;
	}
	return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView obtainCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = nil;
	
    static NSString *kCellIdentifierRemainedTask = @"kCellIdentifierRemainedTask";
    static NSString *kCellIdentifierWithValue = @"kCellIdentifierWithValue";
    static NSString *kCellIdentifierWithSwitch = @"kCellIdentifierWithSwitch";
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWithValue];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifierWithValue] autorelease];
			}
		}
		if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierWithSwitch];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"SwitchCell" owner:self options:nil];
				switchCell.switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoFollowingFlag"];
				cell = switchCell;
			}
		}
	}
	else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRemainedTask];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"RemainedTaskCell" owner:self options:nil];
			UIFont *font = remainedTaskCell.textLabel.font;
			remainedTaskCell.textLabel.font = [UIFont boldSystemFontOfSize:[font pointSize]];
			remainedTaskCell.indentationLevel = 1;
			remainedTaskCell.indentationWidth = 50;
			cell = remainedTaskCell;
		}
	}		
	return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView obtainCellForRowAtIndexPath:indexPath];
	
	//
	// Configure the cell
	//
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Your account", nil);
			cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"TwitterUsername"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else if (indexPath.row == 1) {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	if (indexPath.section == 1) {
		RemainedTaskCell *tmp = (RemainedTaskCell*)cell;
		SNSTask *task = [[SNSTaskQueue sharedInstance].queue objectAtIndex:indexPath.row];
		tmp.textLabel.text = task.SNSFriendName;
		if (task.SNSImage) {
			[tmp.portraitImageView setImage:task.SNSImage];
			[tmp.activity stopAnimating];
		}
		else if (task.cantDownload) {
			[tmp.activity stopAnimating];
		}
		else {
			[tmp.activity startAnimating];
		}
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		SNSAccountEditViewController *con = [[SNSAccountEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[self.navigationController pushViewController:con animated:YES];
		[con release];
	}
	else if (indexPath.section == 1) {
		SNSTask *task = [[SNSTaskQueue sharedInstance].queue objectAtIndex:indexPath.row];
		
		[[TwitterEngineController sharedInstance] followUser:task.SNSFriendName];
		
		/*
		if ([SNSFollowTool followWithSNSName:task.SNSName friend:task.SNSFriendName]) {
			[[SNSTaskQueue sharedInstance].queue removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[tableView reloadData];
		}
		*/
	}
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (indexPath.section == 1)
		return YES;
	return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[[SNSTaskQueue sharedInstance].queue removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[tableView reloadData];
	}
}

- (void)reloadDataTableView:(NSNotification*)notification {
	DNSLogMethod
	[tableView_ reloadData];
}

#pragma mark -
#pragma mark override

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	DNSLogMethod
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTableView:) name:@"FlipsideViewController" object:nil];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[tableView_ reloadData];
	self.title = NSLocalizedString(@"Twitter", nil);
	
	for (SNSTask *task in [SNSTaskQueue sharedInstance].queue) {
		[task downloadPortraitImage];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[SNDownloadManager sharedInstance] removeAllQueue];
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	doneButton.style = UIBarButtonItemStyleDone;
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
