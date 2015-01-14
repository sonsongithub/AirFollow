//
//  OriginalAlertViewController.m
//  popupSample
//
//  Created by sonson on 09/06/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UICAlertView.h"
#import "DummyAlertView.h"
#import "BackgroundSpotlightView.h"
#import "CGRect+Help.h"

@interface UICAlertView(private)
- (void)layoutAlertView:(BOOL)animated;

- (void)startFirstDismissAnimation;
- (void)startSecondDismissAnimation;
- (void)didSecondDismissAnimation;

- (void)startBlackoutAnimation;
- (void)startFirstExpandingAnimation;
- (void)startSecondReducingAnimation;
- (void)startThirdExpandingAnimation;
@end

@implementation UICAlertView

@synthesize delegate;
@synthesize contentView;
@synthesize previousContentView;

#pragma mark -
#pragma mark Set alertview bounds

- (void)layoutAlertView:(BOOL)animated {
	//
	// Adjust content view position to center
	//
	
	CGRect bounds = self.bounds;
	
	CGRect alertView_frame = alertView.frame;
	CGRect contentView_frame = contentView.frame;
	contentView_frame.origin.x = (bounds.size.width-contentView_frame.size.width)/2;
	contentView_frame.origin.y = (bounds.size.height-contentView_frame.size.height)/2;
	dropFractionOfRect(&contentView_frame);
	contentView.frame = contentView_frame;
	
	alertView.contentHeight = (int)(contentView_frame.size.height + 0);
	alertView_frame.size.height = (int)(contentView_frame.size.height + 30);
	
	alertView_frame.origin.x = (bounds.size.width-alertView_frame.size.width)/2;
	alertView_frame.origin.y = (bounds.size.height-alertView_frame.size.height)/2;
	dropFractionOfRect(&alertView_frame);
	alertView.frame = alertView_frame;
	
	DNSLog(@"%f", alertView_frame.size.height);
	
	if (animated) {
		contentView.alpha = 0;
		contentView.transform = CGAffineTransformMakeScale(1.4, 1.4);
		previousContentView.transform = CGAffineTransformMakeScale(1, 1);
		[UIView beginAnimations:@"a" context:nil];
		[UIView setAnimationDidStopSelector:@selector(didChangeContentView)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
	}
	
	//
	// Set new layout values
	//
	[alertView setNeedsDisplay];
	
	if (animated) {
		contentView.alpha = 1;
		contentView.transform = CGAffineTransformMakeScale(1, 1);
		previousContentView.transform = CGAffineTransformMakeScale(0.6, 0.6);
		previousContentView.alpha = 0;
		[UIView commitAnimations];
	}
}

- (void)didChangeContentView {
	if ([delegate respondsToSelector:@selector(didChangeContentOriginalAlertView:from:to:)]) {
		[delegate didChangeContentOriginalAlertView:self from:self.previousContentView to:self.contentView];
	}
	[self.previousContentView removeFromSuperview];
	self.previousContentView = nil;
}

#pragma mark -
#pragma mark Override

- (id)init {
	DNSLogMethod
    if (self = [super initWithFrame:CGRectZero] ) {
		self.backgroundColor = [UIColor clearColor];
		self.autoresizesSubviews = YES;
		
		// Alloc subviews
		backView = [[BackgroundSpotlightView alloc] initWithFrame:CGRectZero];
		alertView = [[DummyAlertView alloc] initWithFrame:CGRectZero];
		
		// Set subviews
		[self addSubview:backView];
		[self addSubview:alertView];
		
		//		
		window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		window.windowLevel = UIWindowLevelStatusBar;
		[window makeKeyAndVisible];
		
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	DNSLogMethod
	if (newSuperview == nil) {
		//
		// will remove from superview
		//
		if ([delegate respondsToSelector:@selector(willDismissOriginalAlertView:)]) {
			[delegate willDismissOriginalAlertView:self];
		}
	}
}

- (void)didMoveToSuperview {
	DNSLogMethod
	if ([self superview] == nil) {
		//
		// did remove from superview
		//
		if ([delegate respondsToSelector:@selector(didDismissOriginalAlertView:)]) {
			[delegate didDismissOriginalAlertView:self];
		}
	}
}

#pragma mark -
#pragma mark Original method

- (void)showContentView:(UIView*)newContentView {
	DNSLogMethod
	if (self.superview == nil) {
		[window addSubview:self];
		self.frame = window.frame;
		backView.frame = self.frame;
		alertView.frame = self.frame;
		self.contentView = newContentView;
		[self addSubview:newContentView];
		[self layoutAlertView:YES];
		//
		// Start first animation
		//
		[self startBlackoutAnimation];
	}
	else {
		self.previousContentView = contentView;
		self.contentView = newContentView;
		[self addSubview:newContentView];
		[self layoutAlertView:YES];
	}
}

- (void)dismiss {
	[self startFirstDismissAnimation];
}

#pragma mark -
#pragma mark Private methods for Core Animation, dismiss animation

- (void)startFirstDismissAnimation {
	[UIView beginAnimations:@"dismissAnimation" context:nil];
	[UIView setAnimationDidStopSelector:@selector(startSecondDismissAnimation)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	alertView.alpha = 0;
	alertView.transform = CGAffineTransformMakeScale(0.95, 0.95);
	contentView.alpha = 0;
	contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
	[UIView commitAnimations];
}

- (void)startSecondDismissAnimation {
	[UIView beginAnimations:@"dismissAnimation" context:nil];
	[UIView setAnimationDidStopSelector:@selector(didSecondDismissAnimation)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	backView.alpha = 0;
	[UIView commitAnimations];
}

- (void)didSecondDismissAnimation {
	[self removeFromSuperview];
}

#pragma mark -
#pragma mark Private methods for Core Animation

- (void)startBlackoutAnimation {
	backView.alpha = 0.0;
	alertView.alpha = 0;
	contentView.alpha = 0;
	[UIView beginAnimations:@"firstExpandingAnimation" context:nil];
	[UIView setAnimationDidStopSelector:@selector(startFirstExpandingAnimation)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	backView.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)startFirstExpandingAnimation {
	//
	// Initialize before starting first animation
	//
	alertView.transform = CGAffineTransformMakeScale(0.75, 0.75);
	contentView.transform = CGAffineTransformMakeScale(0.75, 0.75);
	[UIView beginAnimations:@"firstExpandingAnimation" context:nil];
	[UIView setAnimationDidStopSelector:@selector(startSecondReducingAnimation)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	alertView.alpha = 1.0;
	contentView.alpha = 1.0;
	alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
	contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
	[UIView commitAnimations];
}

- (void)startSecondReducingAnimation {
	DNSLogMethod
	[UIView beginAnimations:@"secondReducingAnimation" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDidStopSelector:@selector(startThirdExpandingAnimation)];
	[UIView setAnimationDelegate:self];
	alertView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	[UIView commitAnimations];
}

- (void)startThirdExpandingAnimation {
	DNSLogMethod
	[UIView beginAnimations:@"thirdExpandingAnimation" context:nil];
	[UIView setAnimationDidStopSelector:@selector(didThirdExpandingAnimation)];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	alertView.transform = CGAffineTransformIdentity;
	contentView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)didThirdExpandingAnimation {
	if ([delegate respondsToSelector:@selector(didShowOriginalAlertView:)]) {
		[delegate didShowOriginalAlertView:self];
	}
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	DNSLogMethod
	[window release];
	[contentView release];
	[previousContentView release];
	[backView release];
	[alertView release];
    [super dealloc];
}

@end
