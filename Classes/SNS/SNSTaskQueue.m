//
//  SNSTaskManager.m
//  BlueExchanger
//
//  Created by sonson on 09/07/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNSTaskQueue.h"
#import "SNSTask.h"

SNSTaskQueue* sharedSNSTaskManager = nil;

@implementation SNSTaskQueue

@synthesize queue;

+ (NSString*)savePlistFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *filepath = [documentPath stringByAppendingPathComponent:@"SNSTaskManager.plist"];
	return filepath;
}

+ (SNSTaskQueue*)sharedInstance {
	if (sharedSNSTaskManager == nil) {
		sharedSNSTaskManager = [[SNSTaskQueue alloc] init];
	}
	return sharedSNSTaskManager;
}

- (void)save {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[encoder encodeObject:self.queue forKey:@"SNSTaskQueue"];
	[encoder finishEncoding];
	
	[data writeToFile:[SNSTaskQueue savePlistFilePath] atomically:NO];
	[encoder release];
	[data release];
}

- (void)removeTaskWithFriendName:(NSString*)friendName {
	for (SNSTask *task in [self.queue reverseObjectEnumerator]) {
		if ([task.SNSFriendName isEqualToString:friendName]) {
			[self.queue removeObject:task];
		}
	}
}

- (id)init {
	if (self = [super init]) {
		if( [[NSFileManager defaultManager] fileExistsAtPath:[SNSTaskQueue savePlistFilePath]] ) {
			NSData *data  = [NSData dataWithContentsOfFile:[SNSTaskQueue savePlistFilePath]];
			if ([data length]) {
				NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
				NSMutableArray *readArray = [NSMutableArray arrayWithArray:[decoder decodeObjectForKey:@"SNSTaskQueue"]];
	
				if ([readArray count]) {
					self.queue = readArray;
				}
				else {
					self.queue = [NSMutableArray array];
				}
			
				[decoder finishDecoding];
				[decoder release];
			}
			else {
				self.queue = [NSMutableArray array];
			}
		}
		else {
			self.queue = [NSMutableArray array];
		}
	}
	return self;
}

- (void)dealloc {
	[queue release];
	[super dealloc];
}

@end
