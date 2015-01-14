//
//  TwitterShowQueue.m
//  BTwitter
//
//  Created by sonson on 09/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNDownloadManager.h"
#import "TwitterShowQueue.h"
#import "TwitterImageQueue.h"
#import "SNSTask.h"
#import "P2PResultTwitterView.h"
#import "JSON.h"

@implementation TwitterShowQueue

+ (TwitterShowQueue*)queueFromURLRequest:(NSURLRequest*)URLRequest {
	TwitterShowQueue *queue = [[self alloc] init];
	queue.request = URLRequest;
	return [queue autorelease];
}

#pragma mark -
#pragma mark SNDownloadQueueDelegate

- (void)doTaskAfterDownloadingData:(NSData*)data {
	DNSLogMethod
	NSString *resultJSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	DNSLog(@"%@", resultJSONString);
	NSDictionary *resultDict = [resultJSONString JSONValue];
	
	NSString *profile_image_url = [resultDict objectForKey:@"profile_image_url"];
	DNSLog(@"%@", profile_image_url);
	
	if ([profile_image_url length]) {
		NSURLRequest *newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:profile_image_url]];
		TwitterImageQueue *newQueue = [TwitterImageQueue queueFromURLRequest:newRequest];
		newQueue.target = self.target;
		newQueue.needsOfflineError = NO;
		[[SNDownloadManager sharedInstance] addQueue:newQueue];
	}
	[resultJSONString release];
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
	if ([self.target respondsToSelector:@selector(failedDownloadQueue:)]) {
		[self.target failedDownloadQueue:self];
	}
}

@end
