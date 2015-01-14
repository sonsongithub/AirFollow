//
//  SNSAccountEditViewController.m
//  BlueExchanger
//
//  Created by sonson on 09/07/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNSAccountEditViewController.h"
#import "EditingTableViewCell.h"

@implementation SNSAccountEditViewController

@synthesize snsKind;
@synthesize username, password;

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
	//
	//
	//
	[[NSUserDefaults standardUserDefaults] setObject:nameEditingTableViewCell.textField.text forKey:@"TwitterUsername"];
	[[NSUserDefaults standardUserDefaults] setObject:passwordEditingTableViewCell.textField.text forKey:@"TwitterPassword"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass the current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.allowsSelection = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (snsKind == SNSTwitter) {
		self.title = NSLocalizedString(@"Account", nil);
		self.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"TwitterUsername"];
		self.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"TwitterPassword"];
	}
	
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
//	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
//	self.navigationItem.leftBarButtonItem = cancelButton;
//	[cancelButton release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[nameEditingTableViewCell.textField becomeFirstResponder];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *kIdentifier = @"EditingCell";
	
    EditingTableViewCell *cell = (EditingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EditingTableViewCell" owner:self options:nil];
        cell = editingTableViewCell;
    }
    
    if (indexPath.row == 0) {
        cell.label.text = NSLocalizedString(@"Username", nil);
        cell.textField.placeholder = NSLocalizedString(@"Username", nil);
		cell.textField.text = self.username;
		nameEditingTableViewCell = cell;
    }
	else if (indexPath.row == 1) {
        cell.label.text = NSLocalizedString(@"Password", nil);
        cell.textField.placeholder = NSLocalizedString(@"Password", nil);
		cell.textField.text = self.password;
		cell.textField.secureTextEntry = YES;
		passwordEditingTableViewCell = cell;
    }
	
    return cell;
}

- (void)dealloc {
	[username release];
	[password release];
    [super dealloc];
}

@end

