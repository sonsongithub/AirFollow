//
//  P2PController.h
//  BlueExchanger
//
//  Created by sonson on 09/06/08.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class P2PController;

@protocol P2PControllerDelegate
- (void)doneP2PController:(P2PController*)controller;
- (void)failedP2PController:(P2PController*)controller error:(NSError*)error;
@end


@interface P2PController : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate> {
	GKSession		*session;
	NSString		*peerID;
	id				delegate;
}
@property (nonatomic, retain) GKSession *session;
@property (nonatomic, retain) NSString *peerID;
@property (nonatomic, assign) id delegate;
- (void)close;
@end
