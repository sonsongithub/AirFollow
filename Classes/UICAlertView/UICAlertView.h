//
//  OriginalAlertViewController.h
//  popupSample
//
//  Created by sonson on 09/06/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundSpotlightView;
@class DummyAlertView;
@class UICAlertView;

@protocol UICAlertViewDelegate <NSObject>
@optional
- (void)willDismissOriginalAlertView:(UICAlertView*)alertView;
- (void)didDismissOriginalAlertView:(UICAlertView*)alertView;
- (void)didShowOriginalAlertView:(UICAlertView*)alertView;
- (void)didChangeContentOriginalAlertView:(UICAlertView*)alertView from:(UIView*)from to:(UIView*)to;
@end

@interface UICAlertView : UIView {
	UIWindow						*window;
	BackgroundSpotlightView			*backView;
	DummyAlertView					*alertView;
	UIView							*contentView;
	UIView							*previousContentView;
	id <UICAlertViewDelegate>		delegate;
}
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *previousContentView;
@property (nonatomic, assign) id <UICAlertViewDelegate>delegate;
- (void)showContentView:(UIView*)newContentView;
- (void)dismiss;
@end
