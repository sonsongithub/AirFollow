//
//  BTwitterAppDelegate.m
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BTwitterAppDelegate.h"
#import "MainViewController.h"
#import "SNHUDActivityView.h"
#import "SNSTaskQueue.h"

#import "TwitterEngineController.h"

@implementation BTwitterAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	UIAppDelegate = self;

#ifdef _DEBUG
	// for xauth test
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCachedXAuthAccessTokenStringKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
#endif
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	
//	[[TwitterEngineController sharedInstance] followUser:@"sonson_twit"];
//	[[TwitterEngineController sharedInstance] doit];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[SNSTaskQueue sharedInstance] save];
}

#pragma mark -
#pragma mark HUD

- (void)openHUDOfString:(NSString*)message {
	DNSLogMethod
	if ([SNHUDActivityView sharedInstance].superview == nil) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		[message retain];	// add retain count, for another thread.
		[NSThread detachNewThreadSelector:@selector(openActivityHUDOfString:) toTarget:self withObject:message];
	}
}

- (void)openActivityHUDOfString:(id)obj {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	DNSLogMethod
	@synchronized (self) {
		[[SNHUDActivityView sharedInstance] setupWithMessage:(NSString*)obj];
		[obj release];
		[[SNHUDActivityView sharedInstance] arrange:window.frame];
		[window addSubview:[SNHUDActivityView sharedInstance]];
	}
	[pool release];
	[NSThread exit];
}

- (void)closeHUD {
	DNSLogMethod
	if ([SNHUDActivityView sharedInstance].superview != nil) {
		while ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
			DNSLog(@"Try to cancel ignoring interaction");
			[NSThread sleepForTimeInterval:0.05];
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		}
		[[SNHUDActivityView sharedInstance] dismiss];
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
