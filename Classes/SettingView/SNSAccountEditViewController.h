//
//  SNSAccountEditViewController.h
//  BlueExchanger
//
//  Created by sonson on 09/07/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditingTableViewCell;

typedef enum {
	SNSTwitter
}SNSKind;

@interface SNSAccountEditViewController : UITableViewController {
	IBOutlet EditingTableViewCell	*editingTableViewCell;
	SNSKind							snsKind;
	EditingTableViewCell			*nameEditingTableViewCell;
	EditingTableViewCell			*passwordEditingTableViewCell;
	
	NSString						*username;
	NSString						*password;
}
@property (nonatomic, assign) SNSKind snsKind;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@end
