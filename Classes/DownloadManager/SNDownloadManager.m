//
//  SNDownloadManager.m
//  StoreSales
//
//  Created by sonson on 09/05/25.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SNDownloadManager.h"
#import "SNDownloadQueue.h"

SNDownloadManager* sharedSNDownloadManager = nil;

NSString *kSNDownloadTaskCompleted = @"kSNDownloadTaskCompleted";

@implementation SNDownloadManager

@synthesize queueStack;
@synthesize downloader;
@synthesize downloadData;

+ (SNDownloadManager*)sharedInstance {
	if (sharedSNDownloadManager == nil) {
		sharedSNDownloadManager = [[SNDownloadManager alloc] init];
	}
	return sharedSNDownloadManager;
}

- (id)init {
	self = [super init];
	self.queueStack = [NSMutableArray array];
	return self;
}

- (void)startDownload {
	DNSLogMethod
	if ([queueStack count] == 0) {
		//
		// All queue have been completed
		//
		[[NSNotificationCenter defaultCenter] postNotificationName:kSNDownloadTaskCompleted object:self userInfo:nil];
		
		// Stop network activity animation
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return;
	}
	
	//
	// Fetch first queue.
	//
	SNDownloadQueue *queue = [queueStack objectAtIndex:0];
	
	//
	// Start to download based on the queue.
	//
	if (queue.request == nil) {
		queue.request = [[[NSMutableURLRequest alloc] initWithURL:queue.url] autorelease];
	}
	self.downloader = nil;
	self.downloadData = nil;
	self.downloader = [[[NSURLConnection alloc] initWithRequest:queue.request delegate:self] autorelease];
	self.downloadData = [NSMutableData data];
	
	// UI activity
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//
	// Update crawling message
	//

	DNSLog(@"Now starting - %@", [[queue.request URL] absoluteString]);
}

- (void)addQueue:(SNDownloadQueue*)queue {
	if ([queueStack count] > 0) {
		//
		// like FIFO, first in first out
		//
		[queueStack insertObject:queue atIndex:1];
	}
	else {
		//
		// can't insert at index 0 when queue stack is vacant.
		//
		[queueStack addObject:queue];
	}
	//
	// Right now start to download when queue stack is vacant.
	//
	if ([queueStack count] == 1) {
		[self startDownload];
	}
}

- (void)addToTailQueue:(SNDownloadQueue*)queue {
	[queueStack addObject:queue];
	//
	// Right now start to download when queue stack is vacant.
	//
	if ([queueStack count] == 1) {
		[self startDownload];
	}
}

- (void)removeAllQueue {
	DNSLogMethod
	DNSLog(@"Remove %d queues", [queueStack count]);
	[self.downloader cancel];
	self.downloadData = nil;
	self.downloader = nil;
	[queueStack removeAllObjects];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)removeQueuesForTarget:(id)target {
	DNSLogMethod
	
	[self.downloader cancel];
	self.downloadData = nil;
	self.downloader = nil;
	
	for (int i = 0; i < [queueStack count]; i++) {
		SNDownloadQueue *queue = [queueStack objectAtIndex:i];
		if (queue.target == target) {
			DNSLog(@"Remove %s", class_getName([target class]));
			[queueStack removeObjectAtIndex:i];
		}
	}
	
	[self startDownload];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	DNSLogMethod
	SNDownloadQueue *queue = [queueStack objectAtIndex:0];
	queue.response = response;
	
	if (![[[response URL] absoluteString] isEqualToString:[queue.url absoluteString]]) {
		//
		// Differenct URL is loaded
		//
		DNSLog(@"Request %@", [queue.url absoluteString]);
		DNSLog(@"Response %@", [[response URL] absoluteString]);
		[connection cancel];
		
		//
		// Call doTaskAfterReturnedDifferentURL to delegate
		//
		SNDownloadQueue *queue = [queueStack objectAtIndex:0];
		if ([queue respondsToSelector:@selector(doTaskAfterReturnedDifferentURL)]) {
			[queue doTaskAfterReturnedDifferentURL];
		}
		[queueStack removeObjectAtIndex:0];
		[self startDownload];

	}
	else {
		if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
			NSDictionary *headerDict = [(NSHTTPURLResponse*)response allHeaderFields];
			DNSLog(@"%@", headerDict);
			queue.contentLength = [[headerDict objectForKey:@"Content-Length"] intValue];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data lengthReceived:(int)length {
	[self.downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	DNSLogMethod
	
	// Stop network activity animation
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// next queue
	SNDownloadQueue *queue = [queueStack objectAtIndex:0];
	if ([queue respondsToSelector:@selector(doTaskAfterDownloadingData:)]) {
		[queue doTaskAfterDownloadingData:self.downloadData];
	}
	[queueStack removeObjectAtIndex:0];
	[self startDownload];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	DNSLogMethod
	
	// Stop network activity animation
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// current queue
	SNDownloadQueue *queue = [queueStack objectAtIndex:0];
	
	// Show network error alert message
	if (queue.needsOfflineError) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
															message:[error localizedDescription] 
														   delegate:nil 
												  cancelButtonTitle:nil 
												  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[alertView show];
		[alertView release];
	}
	
	if ([queue respondsToSelector:@selector(doTaskAfterFailedDownload:)]) {
		[queue doTaskAfterFailedDownload:error];
	}
	[queueStack removeObjectAtIndex:0];
	
	// if internet connection is lost, all queues must be removed.
	if ([error code] == -1009) {
		[self removeAllQueue];
	}
	
	[self startDownload];
	
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[downloader release];
	[downloadData release];
	[queueStack release];
	[super dealloc];
}

@end