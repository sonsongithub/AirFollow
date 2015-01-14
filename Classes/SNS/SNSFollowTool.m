//
//  SNSFollowTool.m
//  BlueExchanger
//
//  Created by sonson on 09/07/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNSFollowTool.h"
#import "SNSTaskQueue.h"
#import "SNSTask.h"

// Tool
#import "NSString+Base64.h"
#import "JSON.h"
#import "NSString+AutoDecoder.h"

//
// Base SNS'API URL
//

// Twitter
NSString *twitterFollowURL = @"http://twitter.com/friendships/create/%@.json?follow=true";
NSString *twitterShowURL = @"http://twitter.com/users/show/%@.json";

//
// Make NSDictionary Binary data from SNS name and friend name
//
CFDataRef XMLDataOfSNSNameAndFriendID(NSString* snsName, NSString *friendName) {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
								snsName,	@"SNSName",
								friendName,	@"FriendID",
						  nil];
	CFDataRef xmlData = CFPropertyListCreateXMLData(kCFAllocatorSystemDefault, (CFPropertyListRef)dict);
	return xmlData;
}

@implementation SNSFollowTool

+ (NSURLRequest*)URLRequestOfTwitterFollowFriendName:(NSString*)friendName {
	DNSLogMethod
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"TwitterUsername"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"TwitterPassword"];
	NSString *apiURL = [[NSString alloc] initWithFormat:twitterFollowURL, friendName];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
	NSString *baseStr = [[NSString alloc] initWithFormat:@"%@:%@", username, password];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [baseStr stringEncodedWithBase64]] forHTTPHeaderField:@"Authorization"];
	[baseStr release];
	[apiURL release];
	[request setHTTPMethod:@"POST"];
	return request;
}

+ (NSURLRequest*)URLRequestOfTwitterShowFriendName:(NSString*)friendName {
	DNSLogMethod
	NSString *apiURL = [[NSString alloc] initWithFormat:twitterShowURL, friendName];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
	[apiURL release];
	[request setHTTPMethod:@"GET"];
	return request;
}

+ (BOOL)followTwitterFriend:(NSString*)friendName {
	DNSLogMethod
	BOOL result = NO;
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	[UIAppDelegate openHUDOfString:NSLocalizedString(@"Following...", nil)];
	[NSThread sleepForTimeInterval:1];
	
	NSURLRequest *request = [SNSFollowTool URLRequestOfTwitterFollowFriendName:friendName];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	[UIAppDelegate closeHUD];
	
	if (data == nil) {
		result = NO;
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
															message:[error localizedDescription]
														   delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else {
		result = YES;
		//
		// Result of following the friend
		//
		NSString *resultJSONString = [NSString stringAutoDecodeFromData:data];
		
		//NSString *resultJSONString = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
		NSDictionary *resultDict = [resultJSONString JSONValue];
		NSString *followingResult = [resultDict objectForKey:@"following"];
		DNSLog(@"==>%@", resultJSONString);
		
		for (NSString *key in [resultDict allKeys]) {
			DNSLog(@"%@=>%@", key, [resultDict objectForKey:key]);
		}
		
		DNSLog(@"following->%s", class_getName([[resultDict objectForKey:@"following"] class]));
		
		if ([resultDict objectForKey:@"error"]) {
			//
			// Twitter error
			//
			result = NO;
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter error", nil)
																message:[resultDict objectForKey:@"error"]
															   delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		else if ([followingResult intValue]) {
			result = YES;
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter", nil)
																message:NSLocalizedString(@"Followed", nil)
															   delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		else {
			result = NO;
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter error", nil)
																message:NSLocalizedString(@"Error", nil)
															   delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	
	return result;
}

+ (BOOL)followWithSNSName:(NSString*)SNSName friend:(NSString*)friendName {
	if ([SNSName isEqualToString:@"twitter"]) {
		return [self followTwitterFriend:friendName];
	}
	return YES;
}

@end
