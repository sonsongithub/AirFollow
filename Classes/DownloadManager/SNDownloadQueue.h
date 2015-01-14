//
//  SNDownloadQueue.h
//  StoreSales
//
//  Created by sonson on 09/05/25.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DownloadQueueDone = 0,
	DownloadQueueCancelled = 1,
	DownloadQueueError = 2
}DownloadManagerResult;

@class SNDownloadQueue;

@protocol SNDownloadQueueDelegate <NSObject>
- (void)didDownloadQueue:(SNDownloadQueue*)queue userInfo:(NSDictionary*)userInfo;
- (void)failedDownloadQueue:(SNDownloadQueue*)queue;
@end

@interface SNDownloadQueue : NSObject {
	id						target;
	NSURLRequest			*request;
	NSURLResponse			*response;
	DownloadManagerResult	result;
	NSError					*resultError;
	int						contentLength;
	BOOL					needsOfflineError;
	BOOL					needsDifferentError;
}

@property (nonatomic, retain) id<SNDownloadQueueDelegate>target;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, assign) DownloadManagerResult result;
@property (nonatomic, retain) NSError *resultError;
@property (nonatomic, assign) int contentLength;
@property (nonatomic, assign) BOOL needsOfflineError;
@property (nonatomic, assign) BOOL needsDifferentError;

//+ (SNDownloadQueue*)queueFromURL:(NSURL*)URL;
+ (SNDownloadQueue*)queueFromURLRequest:(NSURLRequest*)URLRequest;

- (void)doTaskAfterDownloadingData:(NSData*)data;
- (void)doTaskAfterReturnedDifferentURL;
- (void)doTaskAfterFailedDownload:(NSError*)error;

@end
