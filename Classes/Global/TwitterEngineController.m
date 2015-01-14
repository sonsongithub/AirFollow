//
//  TwitterEngineController.m
//  AirFollow
//
//  Created by sonson on 10/05/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterEngineController.h"
#import "XAuthTwitterEngine.h"
#import "SNSTaskQueue.h"

TwitterEngineController *sharedInstanceTwitterEngineController = nil;

@implementation TwitterEngineController

#pragma mark -
#pragma mark Class method

@synthesize followingFriendName = _followingFriendName;

+ (TwitterEngineController*)sharedInstance {
	if (sharedInstanceTwitterEngineController == nil) {
		sharedInstanceTwitterEngineController = [[TwitterEngineController alloc] init];
	}
	return sharedInstanceTwitterEngineController;
}

- (void)doit {
}

- (void)showUsernameAndPasswordAlertView {
	_inputAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Input your account", nil)
												 message:@"\r\r\r"
												delegate:self
									   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
									   otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 110.0);
	[_inputAlertView setTransform:myTransform];
	_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	[_usernameField setBorderStyle:UITextBorderStyleRoundedRect];
	[_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_usernameField setKeyboardType:UIKeyboardTypeASCIICapable];
	[_usernameField setPlaceholder:NSLocalizedString(@"Username", nil)];
	_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)];
	[_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_passwordField setKeyboardType:UIKeyboardTypeASCIICapable];
	[_passwordField setSecureTextEntry:YES];
	[_passwordField setBorderStyle:UITextBorderStyleRoundedRect];
	[_passwordField setPlaceholder:NSLocalizedString(@"Password", nil)];
	[_inputAlertView show];
	[_inputAlertView addSubview:_usernameField];
	[_inputAlertView addSubview:_passwordField];
	[_usernameField release];
	[_passwordField release];
	[_inputAlertView release];
	
	[_usernameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterUsername"]];
	
	[_passwordField becomeFirstResponder];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
		twitterEngine.consumerKey = kOAuthConsumerKey;
		twitterEngine.consumerSecret = kOAuthConsumerSecret;
		
		
		if ([twitterEngine isAuthorized]) {
		}
		else {
		}
	}
	return self;
}

- (void) dealloc {
	[_followingFriendName release];
	[super dealloc];
}


- (void)followUser:(NSString*)username {
	DNSLogMethod
	
	if ([twitterEngine isAuthorized]) {
		[twitterEngine enableUpdatesFor:username];
		self.followingFriendName = username;
		[UIAppDelegate openHUDOfString:NSLocalizedString(@"Following...", nil)];
	}
	else {
		self.followingFriendName = username;
		[self showUsernameAndPasswordAlertView];
	}
}

#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username {
	//
	// Note: do not use NSUserDefaults to store this in a production environment. 
	// ===== Use the keychain instead. Check out SFHFKeychainUtils if you want 
	//       an easy to use library. (http://github.com/ldandersen/scifihifi-iphone) 
	//
	NSLog(@"Access token string returned: %@", tokenString);
	
	if (tokenString !=nil || [tokenString length]) {
		[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
		if ([self.followingFriendName length] == 0) {
			[self alertWithTitle:NSLocalizedString(@"Twitter", nil) message:NSLocalizedString(@"Authentication is succeeded.", nil)];
		}
	}
	else {
	}
	[UIAppDelegate closeHUD];
	
	if ([self.followingFriendName length] > 0) {
		[twitterEngine enableUpdatesFor:self.followingFriendName];
		[UIAppDelegate openHUDOfString:NSLocalizedString(@"Following...", nil)];
	}
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username {
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
	}
	else if (buttonIndex == 1) {
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSString *username = _usernameField.text;
		NSString *password = _passwordField.text;
		
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"TwitterUsername"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[twitterEngine exchangeAccessTokenForUsername:username password:password];
		[UIAppDelegate openHUDOfString:NSLocalizedString(@"Checking...", nil)];
	}
	else {
		self.followingFriendName = nil;
	}
	_inputAlertView = nil;
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error {
	NSLog(@"Error: %@", error);
	[UIAppDelegate closeHUD];
	self.followingFriendName = nil;
	[self alertWithTitle:NSLocalizedString(@"Authentication is failed", nil) message:[error localizedDescription]];
}

#pragma mark -
#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
	[UIAppDelegate closeHUD];
	[self alertWithTitle:NSLocalizedString(@"Twitter", nil) message:NSLocalizedString(@"Followed!!", nil)];
	
	[[SNSTaskQueue sharedInstance] removeTaskWithFriendName:self.followingFriendName];
	self.followingFriendName = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FlipsideViewController" object:nil userInfo:nil];
}

- (void)alertWithTitle:(NSString*)title message:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
	[alert release];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	NSLog(@"Twitter request failed: %@ with error:%@", connectionIdentifier, error);
	[UIAppDelegate closeHUD];
	[self alertWithTitle:NSLocalizedString(@"Twitter", nil) message:NSLocalizedString(@"Can't follow your friend.", nil)];
	
	if ([[error domain] isEqualToString: @"HTTP"]) {
		switch ([error code]) {
			case 401:
				break;
			case 502:
				break;
			case 503:
				break;
			default:
				break;				
		}
	}
	else  {
		switch ([error code]) {
			case -1009:
				break;
			case -1200:
				break;								
			default:
				break;
		}
	}
	self.followingFriendName = nil;
}

@end
