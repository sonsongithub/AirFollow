//
//  ExchangController.h
//  BlueExchanger
//
//  Created by sonson on 09/06/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "P2PController.h"
#import "UICAlertView.h"

typedef enum {
	P2PDataImage	= 0,
	P2PDataAddress	= 1,
	P2PDataSNS		= 2
}P2PDataKind;

@class UICAlertView;
@class P2PStatusInitView;
@class P2PResultTwitterView;
@class P2PResultErrorView;

@interface P2PExchangeController : P2PController <UICAlertViewDelegate> {
	//
	// Vaiables for communicating
	//
	int								bytesOfDataToReceive;
	int								bytesOfDataAlreadySent;
	NSMutableData					*dataToReceive;
	NSData							*dataToSend;
	
	// Flag
	BOOL							hasFinishedReceiving;
	BOOL							hasFinishedSending;
	BOOL							hasReceivedBytesToReceive;
	BOOL							hasSentBytesToReceive;
	
	//
	// UICAlertView
	//
	UICAlertView					*alertView;
	
	//
	// IBOutlet for contentView of UICAlertView
	//
	// Status
	IBOutlet P2PStatusInitView		*p2PStatusInitView;
	// Result
	IBOutlet P2PResultTwitterView	*p2PResultTwitterView;
	IBOutlet P2PResultErrorView		*p2PResultErrorView;
	
	//
	// For SNS, copy these string to start following after dimiss alertview
	//
	NSString						*followingSNSName;
	NSString						*followingFriendName;
}
@property (nonatomic, retain) NSMutableData *dataToReceive;
@property (nonatomic, retain) NSData *dataToSend;

@property (nonatomic, retain) NSString *followingSNSName;
@property (nonatomic, retain) NSString *followingFriendName;

#pragma mark -
#pragma mark IBAction from each contentView
- (IBAction)cancel:(id)sender;
- (IBAction)pushSaveButton:(id)sender;
- (IBAction)pushDiscardButton:(id)sender;

#pragma mark -
#pragma mark Update content view of UICAlertView
- (void)updateAlertViewWithInitView;
- (void)updateAlertViewWithResultView;
- (void)openPickerWithData:(NSData*)data dataKind:(P2PDataKind)dataKind;

#pragma mark -
#pragma mark Send & Receive
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context;
- (void)sendDataSize;
- (void)sendData;

@end
