//
//  MessageView.h
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageView : UIView {
	NSString *message;
}
- (id)initWithMessage:(NSString*)string;
@end
