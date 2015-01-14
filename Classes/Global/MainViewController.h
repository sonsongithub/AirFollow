//
//  MainViewController.h
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"

@class P2PExchangeController;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	P2PExchangeController *p2PExchangeController;
}
@property (nonatomic, retain) P2PExchangeController *p2PExchangeController;

- (IBAction)showInfo:(id)sender;
- (IBAction)showSetting:(id)sender;
- (IBAction)openTutorial:(id)sender;

@end
