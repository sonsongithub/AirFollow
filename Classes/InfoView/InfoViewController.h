//
//  InfoViewController.h
//  2tch
//
//  Created by sonson on 09/07/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef enum {
	InfoViewOpenSupport		= 3,
}InfoViewUIActionSheetType;

@interface InfoViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UIColor					*detailTextLabelColor;	
}
+ (UINavigationController*)controllerWithNavigationController;
@end
