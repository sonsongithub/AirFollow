//
//  SNSTask.h
//  BTwitter
//
//  Created by sonson on 09/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNDownloadQueue.h"

@interface SNSTask : NSObject <SNDownloadQueueDelegate> {
	NSString *SNSName;
	NSString *SNSFriendName;
	NSData	 *SNSImageData;
	UIImage	 *SNSImage;
	BOOL	 cantDownload;
}
@property(nonatomic, retain) NSString *SNSName;
@property(nonatomic, retain) NSString *SNSFriendName;
@property(nonatomic, retain) NSData *SNSImageData;
@property(nonatomic, readonly) UIImage *SNSImage;
@property(nonatomic, assign) BOOL cantDownload;

+ (SNSTask*)SNSTaskFromSNS:(NSString*)SNSName friend:(NSString*)friendName;
- (void)downloadPortraitImage;
	
@end
