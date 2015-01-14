//
//  DummyAlertView.m
//  popupSample
//
//  Created by sonson on 09/06/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DummyAlertView.h"

#define DEFAULT_ALERTVIEW_WIDTH		280
#define DEFAULT_ALERTVIEW_HEIGHT	100

@interface DummyAlertView(Private)
- (void)setPathOfRoundCornerRect:(CGRect)rect radius:(float)radius;
@end

@implementation DummyAlertView

@synthesize contentHeight;

/*
@dynamic contentView;

#pragma mark -
#pragma mark Setter

- (void)setContentView:(id)newValue {
	if (newValue != contentView) {
		// Update instance
		
		BOOL animated = (contentView != nil);
		
		[contentView removeFromSuperview];
		[contentView release];
		contentView = [newValue retain];
		[self addSubview:contentView];
		
		// Adjust content view position to center
		CGRect self_frame = self.frame;
		CGRect content_frame = contentView.frame;
		content_frame.origin.x = (self_frame.size.width - content_frame.size.width)/2;
		content_frame.origin.y = (self_frame.size.height - content_frame.size.height)/2;
		CGRect self_bounds = self.bounds;
		self_bounds.size.height = content_frame.size.height + 50;
		
		//contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
		if (animated) {
			[UIView beginAnimations:@"a" context:nil];
			
		}
		
		contentView.frame = content_frame;
		self.bounds = self_bounds;
		[self setNeedsDisplay];
		
		if (animated) {
			[UIView commitAnimations];
		}
//		[UIView beginAnimations:@"a" context:nil];
		
//		contentView.frame = content_frame;
//		contentView.transform = CGAffineTransformMakeScale(1, 1);
		
//		[UIView commitAnimations];
		
		//
		// contentHeight automatically adjusted to height of content view.
		//
		contentHeight = content_frame.size.height;
		
	}
}
*/
#pragma mark -
#pragma mark Private

- (void)setPathOfRoundCornerRect:(CGRect)rect radius:(float)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// outline 
	CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
	CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

#pragma mark -
#pragma mark Override

- (id)initWithFrame:(CGRect)frame {
	DNSLogMethod
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	
	//
	// Make a color gradient for growl.
	//
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] = {
		1.0, 1.0, 1.0, 180.0/255.0,
		1.0, 1.0, 1.0, 40/255.0,
	};
	growlGradient = CGGradientCreateWithColorComponents( rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4) );
	CGColorSpaceRelease(rgb);
	
	// Set default value
	contentHeight = DEFAULT_ALERTVIEW_HEIGHT;
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	DNSLogMethod
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//
	// Draw window, centering automatically
	//
	float window_width = DEFAULT_ALERTVIEW_WIDTH;
	float window_height = contentHeight;
	float window_left = (rect.size.width - window_width) / 2;
	float window_top = (rect.size.height - window_height) / 2;
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 3.0, [UIColor blackColor].CGColor);
	CGContextSetRGBStrokeColor(context, 0.9f, 0.9f, 0.9f, 0.75);
	CGContextSetRGBFillColor(context, 12/255.0, 12/255.0, 12/255.0, 0.5);
	CGContextSetLineWidth(context, 2);
	[self setPathOfRoundCornerRect:CGRectMake(window_left, window_top, window_width, window_height) radius:10];
	CGContextDrawPath(context, kCGPathFillStroke);
	CGContextRestoreGState(context);
	
	//
	// Draw growl
	//
	CGContextSaveGState(context);
	CGRect growlRect;
	float growlRadius = 40;
	
	float growl_horizontal_offset = 26;			// round corner size?
	float growl_vertical_offset = 40;			// growl's height inside window
	
	// calc. growl size
	float growl_internal_width = window_width - growl_horizontal_offset * 2;
	growlRect.size = CGSizeMake(growlRadius*2 + growl_internal_width, growlRadius*2);
	
	// calc. growl origin
	float growl_left = window_left + window_width/2 - growlRect.size.width/2;
	float growl_top = window_top - growlRect.size.height + growl_vertical_offset;
	growlRect.origin = CGPointMake(growl_left, growl_top);
	
	// draw growl using clipping
	[self setPathOfRoundCornerRect:CGRectMake(window_left, window_top, window_width, window_height) radius:10];
	CGContextClip(context);
	[self setPathOfRoundCornerRect:growlRect radius:growlRadius];
	CGContextEOClip(context);
	CGContextDrawLinearGradient(context, growlGradient, CGPointMake(0,window_top), CGPointMake(0,window_top+growl_vertical_offset), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	CGGradientRelease(growlGradient);
//	[contentView release];
	[super dealloc];
}


@end
