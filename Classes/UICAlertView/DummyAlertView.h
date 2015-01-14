//
//  DummyAlertView.h
//  popupSample
//
//  Created by sonson on 09/06/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DummyAlertView : UIView {
	CGGradientRef	growlGradient;
	CGFloat			contentHeight;
	
//	UIView			*contentView;
}
@property (nonatomic, assign) CGFloat contentHeight;
//@property (nonatomic, retain) UIView *contentView;
@end
