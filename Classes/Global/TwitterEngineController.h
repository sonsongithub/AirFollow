//
//  TwitterEngineController.h
//  AirFollow
//
//  Created by sonson on 10/05/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAToken.h"

#define kOAuthConsumerKey					@"jn7q5QijUNxfbaIZF83Ew"
														// Replace these with your consumer key 
#define	kOAuthConsumerSecret				@"X06IdBK8TUTxe4zdQPvmtbvHjcqFxOcgVqVstlY7Yk"		
														// and consumer secret from http://twitter.com/oauth_clients/details/<your app id>
#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@class XAuthTwitterEngine;

@interface TwitterEngineController : NSObject {
	XAuthTwitterEngine *twitterEngine;
	
	UIAlertView			*_inputAlertView;
	UITextField			*_usernameField;
	UITextField			*_passwordField;
	
	NSString			*_followingFriendName;
}
@property (nonatomic, retain) NSString *followingFriendName;

+ (TwitterEngineController*)sharedInstance;
- (id) init;
- (void)followUser:(NSString*)username;

@end
