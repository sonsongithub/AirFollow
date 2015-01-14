//
//  SNSTaskManager.h
//  BlueExchanger
//
//  Created by sonson on 09/07/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SNSTaskQueue : NSObject {
	NSMutableArray *queue;
}
@property (nonatomic, retain) NSMutableArray* queue;

+ (NSString*)savePlistFilePath;
+ (SNSTaskQueue*)sharedInstance;
- (void)save;
- (void)removeTaskWithFriendName:(NSString*)friendName;

@end
