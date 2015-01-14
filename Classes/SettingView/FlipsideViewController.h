//
//  FlipsideViewController.h
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SwitchCell.h"
#import "RemainedTaskCell.h"

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
    IBOutlet UITableView *tableView_;
	IBOutlet RemainedTaskCell *remainedTaskCell;
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet	SwitchCell *switchCell;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (void)setSNSAccountView;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

