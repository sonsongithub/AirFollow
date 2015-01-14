//
//  SNSFollowTool.h
//  BlueExchanger
//
//  Created by sonson on 09/07/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

CFDataRef XMLDataOfSNSNameAndFriendID(NSString* snsName, NSString *friendName);

@interface SNSFollowTool : NSObject {
}
+ (NSURLRequest*)URLRequestOfTwitterFollowFriendName:(NSString*)friendName;
+ (NSURLRequest*)URLRequestOfTwitterShowFriendName:(NSString*)friendName;
+ (BOOL)followTwitterFriend:(NSString*)friendName;
+ (BOOL)followWithSNSName:(NSString*)SNSName friend:(NSString*)friendName;
@end
