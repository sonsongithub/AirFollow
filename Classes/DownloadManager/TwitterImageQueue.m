//
//  TwitterImageQueue.m
//  BTwitter
//
//  Created by sonson on 09/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TwitterImageQueue.h"
#import "P2PResultTwitterView.h"
#import "SNSTask.h"

NSString *KeyForTwitterImage = @"KeyForTwitterImage";

@implementation TwitterImageQueue

+ (TwitterImageQueue*)queueFromURLRequest:(NSURLRequest*)URLRequest {
	TwitterImageQueue *queue = [[self alloc] init];
	queue.request = URLRequest;
	return [queue autorelease];
}

- (void)doTaskAfterDownloadingData:(NSData*)data {
	DNSLogMethod
	if ([self.target respondsToSelector:@selector(didDownloadQueue:userInfo:)]) {
		NSDictionary *dict = [NSDictionary dictionaryWithObject:data forKey:KeyForTwitterImage];
		[self.target didDownloadQueue:self userInfo:dict];
	}
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
	if ([self.target respondsToSelector:@selector(failedDownloadQueue:)]) {
		[self.target failedDownloadQueue:self];
	}
}

@end
