//
//  LicenseViewController.m
//  2tch
//
//  Created by sonson on 09/07/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LicenseViewController.h"

@implementation LicenseViewController

+ (LicenseViewController*)defaultController {
	LicenseViewController* controller = [[LicenseViewController alloc] initWithNibName:nil bundle:nil];
	return [controller autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.title = NSLocalizedString(@"License", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
