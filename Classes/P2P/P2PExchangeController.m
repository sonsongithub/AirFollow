//
//  ExchangController.m
//  BlueExchanger
//
//  Created by sonson on 09/06/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "P2PExchangeController.h"
#import "TwitterEngineController.h"

// Identifier
const char *P2PDataIdentifier[] = {
	"IMG",
	"ADD",
	"SNS"
};

// IBOutlet for show status
#import "P2PStatusInitView.h"
#import "P2PResultTwitterView.h"

// IBOutlet for show results
#import "P2PResultErrorView.h"
#import "SNSFollowTool.h"
#import "SNSTask.h"
#import "SNSTaskQueue.h"

// Address book
//#import "SNSFollowTool.h"

int packet_size = 0;

@implementation P2PExchangeController

@synthesize dataToSend;
@synthesize dataToReceive;
@synthesize followingSNSName, followingFriendName;

+ (void)initialize {
	packet_size = [[NSUserDefaults standardUserDefaults] integerForKey:@"windowSize"];
	if (packet_size == 0) {
		packet_size = 1024;
		[[NSUserDefaults standardUserDefaults] setInteger:packet_size forKey:@"windowSize"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

#pragma mark -
#pragma mark IBAction from each contentView

- (IBAction)cancel:(id)sender {
	DNSLogMethod
	hasFinishedReceiving = YES;
	hasFinishedSending = YES;
	[self close];
	[alertView dismiss];
}

- (IBAction)pushSaveButton:(id)sender {
	DNSLogMethod
	
	
	if (hasFinishedSending == NO || hasFinishedReceiving == NO) {
		DNSLog(@"some tasks has not been finisehd.");
		return;
	}
	
	char* p = (char*)malloc(sizeof(char)*3);
	memcpy(p, [self.dataToReceive bytes], 3);
	
	NSData *bodyBinary = [NSData dataWithBytes:[self.dataToReceive bytes] + 3 length:[self.dataToReceive length] - 3];
	self.dataToReceive = nil;
	
	if (strncmp("SNS", p, 3) == 0) {
		NSDictionary *xml = (NSDictionary*)CFPropertyListCreateFromXMLData(kCFAllocatorSystemDefault, (CFDataRef)bodyBinary, kCFPropertyListImmutable, nil);
		self.followingSNSName = [xml objectForKey:@"SNSName"];
		self.followingFriendName = [xml objectForKey:@"FriendID"];
		CFRelease(xml);
	}
	
	free(p);
	
	[alertView dismiss];
}

- (IBAction)pushDiscardButton:(id)sender {
	DNSLogMethod
	[alertView dismiss];
}

#pragma mark -
#pragma mark Update content view of UICAlertView

- (void)updateAlertViewWithInitView {
	//
	// Initialize valibles to send and receive
	//
	hasFinishedReceiving = NO;
	hasFinishedSending = NO;
	hasReceivedBytesToReceive = NO;
	hasSentBytesToReceive = NO;
	
	//
	// Alloc UICAlertView
	//
	UICAlertView *view = [[UICAlertView alloc] init];
	view.delegate = self;
	alertView = view;
	[view autorelease];
	
	//
	// Set contentView
	//
	[[NSBundle mainBundle] loadNibNamed:@"P2PStatusInitView" owner:self options:nil];
	[view showContentView:p2PStatusInitView];
}

- (void)updateAlertViewWithResultView {
	DNSLogMethod
	if ([alertView.contentView isKindOfClass:[P2PResultTwitterView class]]) {
		return;
	}
	
	if (hasFinishedSending == NO || hasFinishedReceiving == NO) {
		DNSLog(@"some tasks has not been finisehd.");
		//
		// Sending or receiving task has not been finished
		// 
		return;
	}
	
	if ([self.dataToReceive length] < 4) {
		//
		// There are nothing to do if size of received binary is less than 4bytes. 
		// 
		[alertView dismiss];
		return;
	}
	
	//
	// Raw binary pointor
	//
	// Use for identifying which kind of binary.
	char* p = (char*)[self.dataToReceive bytes];
	
	// Make NSData which includes body of data to be received
	NSData *bodyBinary = [NSData dataWithBytes:[self.dataToReceive bytes] + 3 length:[self.dataToReceive length] - 3];
	
	if (strncmp("SNS", p, 3) == 0) {
		//
		// SNS
		//
		NSDictionary *xml = (NSDictionary*)CFPropertyListCreateFromXMLData(kCFAllocatorSystemDefault, (CFDataRef)bodyBinary, kCFPropertyListImmutable, nil);
		
		if (xml) {
			[[NSBundle mainBundle] loadNibNamed:@"P2PResultTwitterView" owner:self options:nil];
			[alertView showContentView:p2PResultTwitterView];
			p2PResultTwitterView.name.text = [xml objectForKey:@"FriendID"];
			[p2PResultTwitterView update];
			CFRelease(xml);
		}
		
		[self close];
	}
}

//
// At first, this method is called
//
- (void)openPickerWithData:(NSData*)data dataKind:(P2PDataKind)dataKind {
	//
	// Make and show picker, don't autorelease
	//
	GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	[picker show];
	
	NSArray* versions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
	if ([versions count] >= 2) {
		NSString* major = (NSString*)[versions objectAtIndex:0];
		NSString* minor = (NSString*)[versions objectAtIndex:1];
		if ([major isEqualToString:@"3"] && [minor isEqualToString:@"1"]) {
		//	[picker autorelease];
		}
	}
	
	//
	// Make data to send
	//
	NSMutableData *tempData = nil;
	if (data != nil) {
		tempData = [NSMutableData data];
		[tempData appendBytes:P2PDataIdentifier[dataKind] length:3];
		[tempData appendData:data];
	}
	
	//
	// Set up to send and receive
	//
	bytesOfDataAlreadySent = 0;
	bytesOfDataToReceive = -1;
	self.dataToSend = tempData;
	self.dataToReceive = [NSMutableData data];
}

#pragma mark -
#pragma mark Check initialization

- (void)checkInitialize {
	if (hasReceivedBytesToReceive && hasSentBytesToReceive) {
		[self performSelector:@selector(sendData) withObject:nil afterDelay:1];
	}
}

#pragma mark -
#pragma mark Send & Receive

- (BOOL)sendNSData:(NSData*)data {
	NSError *error = nil;
	[session sendData:data toPeers:[NSArray arrayWithObject:self.peerID] withDataMode:GKSendDataReliable error:&error];
	if (error) {
		DNSLog(@"Error:%@", [error localizedDescription]);
		[[NSBundle mainBundle] loadNibNamed:@"P2PResultErrorView" owner:self options:nil];
		p2PResultErrorView.description.text = [error localizedDescription];
		[alertView showContentView:p2PResultErrorView];
		return NO;
	}
	return YES;
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
	DNSLogMethod
	char* header = (char*)[data bytes];
	char* body = header + 1;
	
	if (*header == 0x01) {
		DNSLog(@"Receive:size");
		// Receive size of data to receive
		if (bytesOfDataToReceive == -1) {
			memcpy(&bytesOfDataToReceive, body, sizeof(int));
			// [data getBytes:&bytesOfDataToReceive length:sizeof(bytesOfDataToReceive)];
			DNSLog(@"Receive data size - %d bytes", bytesOfDataToReceive);
			hasReceivedBytesToReceive = YES;
			[self checkInitialize];
		}
	}
	else if (*header == 0x02) {
		DNSLog(@"Receive:data");
		// Receive size of data to receive
		if ([dataToReceive length] < bytesOfDataToReceive) {
			[dataToReceive appendBytes:body length:[data length]-1];
			
			// Sending
			NSMutableData *data = [NSMutableData data];
			char bitToReceive = 0x03;
			[data appendBytes:&bitToReceive length:sizeof(bitToReceive)];
			NSError *error = nil;
			[self.session sendData:data toPeers:[NSArray arrayWithObject:self.peerID] withDataMode:GKSendDataReliable error:&error];
		}
	}
	else if (*header == 0x03) {
		DNSLog(@"Receive:did receive flag");
		//
		// Check whether sending task has finished
		//
		if (bytesOfDataAlreadySent >= [self.dataToSend length]) {
			// Finish
			DNSLog(@"Sending task has been finished");
			hasFinishedSending = YES;
			[self updateAlertViewWithResultView];
		}
		else {
			// Receive sending task has been finished
			[self sendData];
		}
	}
	
	//
	// Check whether receiving task has been finished
	//
	if ([dataToReceive length] == bytesOfDataToReceive) {
		DNSLog(@"receive finished");
		hasFinishedReceiving = YES;
		[self updateAlertViewWithResultView];
	}
}

- (void)sendDataSize {
	//
	// Send a bytes length of NSData to send
	//
	int size = [self.dataToSend length];
	DNSLog(@"Sending data is %d bytes", size);
	
	// Sending
	NSMutableData *data = [NSMutableData data];
	char bitToSendDataSize = 0x01;
	[data appendBytes:&bitToSendDataSize length:sizeof(bitToSendDataSize)];
	[data appendBytes:&size length:sizeof(size)];
	
	// Send
	BOOL result = [self sendNSData:data];
	
	// If successed
	if (result) {
		// Check initialize
		hasSentBytesToReceive = YES;
		[self checkInitialize];
	}
}

- (void)sendData {
	DNSLogMethod
	
	if ([self.dataToSend length] == 0) {
		// Finish
		DNSLog(@"Not task to send data.");
		hasFinishedSending = YES;
		[self updateAlertViewWithResultView];
		return;
	}
	
	char *p = (char*)[self.dataToSend bytes];
	int length = [self.dataToSend length];
	
	//
	// Make and send NSData
	//
	int size_to_send = (length - bytesOfDataAlreadySent) > packet_size ? packet_size : length - bytesOfDataAlreadySent;
	
	NSMutableData *data = [NSMutableData data];
	char bitToSend = 0x02;
	[data appendBytes:&bitToSend length:sizeof(bitToSend)];
	[data appendBytes:(p + bytesOfDataAlreadySent) length:size_to_send];
	bytesOfDataAlreadySent += size_to_send;
	
	// Send
	/*BOOL result =*/[self sendNSData:data];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

- (void)session:(GKSession *)aSession peer:(NSString *)peer didChangeState:(GKPeerConnectionState)state {
    DNSLogMethod
	
	switch (state) {
		case GKPeerStateConnected:
			[self performSelector:@selector(updateAlertViewWithInitView) withObject:nil afterDelay:0];
			break;
		case GKPeerStateDisconnected:
			if (!hasFinishedReceiving || !hasFinishedSending) {
				//
				// Disconnected intentionally
				//
				[[NSBundle mainBundle] loadNibNamed:@"P2PResultErrorView" owner:self options:nil];
				p2PResultErrorView.description.text = NSLocalizedString(@"Disconnected", nil);
				[alertView showContentView:p2PResultErrorView];
			}
			break;
    }
}

#pragma mark -
#pragma mark UICAlertViewDelegate

- (void)willDismissOriginalAlertView:(UICAlertView*)originalAlertView {
	DNSLogMethod
}

- (void)didDismissOriginalAlertView:(UICAlertView*)originalAlertView {
	DNSLogMethod
	
	//
	// Start to follow friend after alert view is dismissed
	// To aboid that HUD view is shown on back of the alert view.
	//
	if ([self.followingSNSName length] > 0 && [self.followingFriendName length] > 0) {
		BOOL autoFollowing = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoFollowingFlag"];
		if (autoFollowing) {
			[[TwitterEngineController sharedInstance] followUser:self.followingFriendName];
			SNSTask* task = [SNSTask SNSTaskFromSNS:self.followingSNSName friend:self.followingFriendName];
			[[SNSTaskQueue sharedInstance].queue addObject:task];
		//	
		//	if (![SNSFollowTool followWithSNSName:self.followingSNSName friend:self.followingFriendName]) {
		//	
		//	}
		}
		else {
			SNSTask* task = [SNSTask SNSTaskFromSNS:self.followingSNSName friend:self.followingFriendName];
			[[SNSTaskQueue sharedInstance].queue addObject:task];
		}
	}
	[self.delegate failedP2PController:self error:nil];
}

- (void)didShowOriginalAlertView:(UICAlertView*)originalAlertView {
	DNSLogMethod
	
	//
	// Send size of data to send after alert view is shown, immediately.
	//
	[self performSelector:@selector(sendDataSize) withObject:nil afterDelay:0.1];
}

- (void)didChangeContentOriginalAlertView:(UICAlertView*)alertView from:(UIView*)from to:(UIView*)to {
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	DNSLogMethod
	[followingSNSName release];
	[followingFriendName release];
	[dataToReceive release];
	[dataToSend release];
	[super dealloc];
}

@end
