//
//  P2PController.m
//  BlueExchanger
//
//  Created by sonson on 09/06/08.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "P2PController.h"

@implementation P2PController

@synthesize session, peerID, delegate;

#pragma mark -
#pragma mark Controller

- (void)close {
	DNSLogMethod
	[self.session disconnectFromAllPeers];
	self.session.available = NO;
	[self.session setDataReceiveHandler:nil withContext:nil];
	self.session.delegate = nil;
	self.session = nil;
}

- (void)dismissPeerPickerController:(GKPeerPickerController *)picker {
	NSArray* versions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
	if ([versions count] >= 2) {
		NSString* major = (NSString*)[versions objectAtIndex:0];
		NSString* minor = (NSString*)[versions objectAtIndex:1];
		if ([major isEqualToString:@"3"] && [minor isEqualToString:@"1"]) {
			[picker dismiss];
			return;
		}
	}
	[picker dismiss];
	[picker release];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	DNSLogMethod
	//
	// Make session object
	//
	GKSession* theSession = [[GKSession alloc] initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer];
	theSession.delegate = self;
	[theSession autorelease];
	return theSession;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peer toSession: (GKSession *)theSession {
	DNSLogMethod
	//
	// Receive session object after connection
	//
	DNSLog(@"peerID=%@ sesssion=%@", peer, theSession);
	self.session = theSession;
	self.peerID = peer;
	[self.session setDataReceiveHandler :self withContext:nil];
	[self dismissPeerPickerController:picker];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
	DNSLogMethod
	[self close];
	[self dismissPeerPickerController:picker];
	[delegate failedP2PController:self error:nil];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
	DNSLogMethod
	if (type == GKPeerPickerConnectionTypeOnline) {
		//
		// This is wrong selection, picker must be released and don't let them connect each other.
		//
		[self dismissPeerPickerController:picker];
		[delegate failedP2PController:self error:nil];
	}
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[self close];
	[peerID release];
	[super dealloc];
}

@end
