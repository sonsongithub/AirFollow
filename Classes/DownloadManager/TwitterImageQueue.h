//
//  TwitterImageQueue.h
//  BTwitter
//
//  Created by sonson on 09/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNDownloadQueue.h"

extern NSString *KeyForTwitterImage;

@interface TwitterImageQueue : SNDownloadQueue {
}
+ (TwitterImageQueue*)queueFromURLRequest:(NSURLRequest*)URLRequest;
@end
