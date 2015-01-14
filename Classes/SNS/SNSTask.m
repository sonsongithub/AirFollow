//
//  SNSTask.m
//  BTwitter
//
//  Created by sonson on 09/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNSTask.h"
#import "SNSFollowTool.h"
#import "TwitterImageQueue.h"
#import "TwitterShowQueue.h"
#import "SNDownloadManager.h"

NSString *kSNSNameIdentifier = @"kSNSNameIdentifier";
NSString *kSNSFriendNameIdentifier = @"kSNSFriendNameIdentifier";
NSString *kSNSImageIdentifier = @"kSNSImageIdentifier";

@implementation SNSTask

@synthesize SNSName;
@synthesize SNSFriendName;
@synthesize SNSImageData;
@synthesize SNSImage;
@synthesize cantDownload;

#pragma mark -
#pragma mark Accessor

- (UIImage*)SNSImage {
	DNSLogMethod
	if (SNSImage == nil) {
		[SNSImage release];
		SNSImage = [UIImage imageWithData:self.SNSImageData];
		[SNSImage retain];
	}
	return SNSImage;
}

#pragma mark -
#pragma mark Class method

+ (SNSTask*)SNSTaskFromSNS:(NSString*)SNSName friend:(NSString*)friendName {
	SNSTask* obj = [[SNSTask alloc] init];
	obj.SNSName = SNSName;
	obj.SNSFriendName = friendName;
	return [obj autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)downloadPortraitImage {
	DNSLogMethod
	DNSLog(@"%@", self.SNSFriendName);
	if (self.SNSImageData == nil) {
		NSURLRequest *request = [SNSFollowTool URLRequestOfTwitterShowFriendName:self.SNSFriendName];
		TwitterShowQueue *queue = [TwitterShowQueue queueFromURLRequest:request];
		queue.target = self;
		queue.needsOfflineError = NO;
		[[SNDownloadManager sharedInstance] addQueue:queue];
	}
}

#pragma mark -
#pragma mark SNDownloadQueueDelegate

- (void)didDownloadQueue:(SNDownloadQueue*)queue userInfo:(NSDictionary*)userInfo {
	self.SNSImageData = [userInfo objectForKey:KeyForTwitterImage];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FlipsideViewController" object:nil];
}

- (void)failedDownloadQueue:(SNDownloadQueue*)queue {
	self.cantDownload = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FlipsideViewController" object:nil];
}

#pragma mark -
#pragma mark Override

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	
	cantDownload = NO;
	self.SNSName = [coder decodeObjectForKey:kSNSNameIdentifier];
	self.SNSFriendName = [coder decodeObjectForKey:kSNSFriendNameIdentifier];
	self.SNSImageData = [coder decodeObjectForKey:kSNSImageIdentifier];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.SNSName forKey:kSNSNameIdentifier];
	[encoder encodeObject:self.SNSFriendName forKey:kSNSFriendNameIdentifier];
	[encoder encodeObject:self.SNSImageData forKey:kSNSImageIdentifier];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[SNSName release];
	[SNSFriendName release];
	[SNSImageData release];
	[SNSImage release];
	[super dealloc];
}


@end
