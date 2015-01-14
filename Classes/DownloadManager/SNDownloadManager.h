//
//  SNDownloadManager.h
//  StoreSales
//
//  Created by sonson on 09/05/25.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNDownloadQueue.h"

@class SNDownloadQueue;

extern NSString* kSNDownloadTaskCompleted;

@interface SNDownloadManager : NSObject {	
	NSMutableArray	*queueStack;
	NSURLConnection	*downloader;
	NSMutableData	*downloadData;
}

@property (nonatomic, retain) NSMutableArray* queueStack;
@property (nonatomic, retain) NSMutableData* downloadData;
@property (nonatomic, retain) NSURLConnection* downloader;

+ (SNDownloadManager*)sharedInstance;
	
- (void)removeAllQueue;
- (void)removeQueuesForTarget:(id)target;
- (void)startDownload;
- (void)addQueue:(SNDownloadQueue*)queue;
- (void)addToTailQueue:(SNDownloadQueue*)queue;

@end