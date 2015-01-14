//
//  MainViewController.m
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "P2PExchangeController.h"
#import "SNSFollowTool.h"
#import "InfoViewController.h"
#import "TutorialPageController.h"

@implementation MainViewController

@synthesize p2PExchangeController;

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender {
	UINavigationController *con = [InfoViewController controllerWithNavigationController];
	con.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:con animated:YES];
}

- (IBAction)showSetting:(id)sender {
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
	controller.delegate = self;
	
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:navi animated:YES];
	
	[controller release];
	[navi release];
}

- (void)openAccountEdit {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
	controller.delegate = self;
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:navi animated:YES];
	[controller setSNSAccountView];
	
	[controller release];
	[navi release];
}

- (IBAction)openTutorial:(id)sender {
	DNSLogMethod
	TutorialPageController *controller = [[[TutorialPageController alloc] initWithNibName:nil bundle:nil] autorelease];
	UINavigationController *navigation = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
	[self presentModalViewController:navigation animated:YES];
}

- (IBAction)p2p:(id)sender {
	//
	// Check whether user has input his/her twitter account
	//
	NSString *twitterAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterUsername"];
	if ([twitterAccount length] == 0) {
		[self openAccountEdit];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
															message:NSLocalizedString(@"Please input your twitter account.", nil)
														   delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	//
	// Twitter
	//
	NSData *dataToSend = (NSData*)XMLDataOfSNSNameAndFriendID(@"twitter", [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterUsername"]);
	P2PExchangeController *controller = [[P2PExchangeController alloc] init];
	[controller openPickerWithData:dataToSend dataKind:P2PDataSNS];
	controller.delegate = self;
//	[self.p2PExchangeController openPickerWithData:dataToSend dataKind:P2PDataSNS];
	[dataToSend release];
}

- (void)doneP2PController:(P2PController*)controller {
	DNSLogMethod
	[controller autorelease];
}

- (void)failedP2PController:(P2PController*)controller error:(NSError*)error {
	DNSLogMethod
	[controller autorelease];
}

- (void)dealloc {
    [super dealloc];
}


@end
