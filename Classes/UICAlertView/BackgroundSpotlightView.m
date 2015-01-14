//
//  BackgroundSpotlightView.m
//  popupSample
//
//  Created by sonson on 09/06/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BackgroundSpotlightView.h"

@implementation BackgroundSpotlightView

- (id)initWithFrame:(CGRect)frame {
	DNSLogMethod
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	
	//
	// Make radial gradient fot background spotlight shading
	//
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] = {
		0., 0.0, 0.0, 0.0/255.0,
		0.0, 0.0, 0.0, 180.0/255.0,
	};
	spotLightGradient = CGGradientCreateWithColorComponents( rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4) );
	CGColorSpaceRelease(rgb);
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	DNSLogMethod
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint start, end;
	
	CGContextSaveGState(context);
	start = end = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGFloat startRadius = 0;
	CGFloat endRadius = 300;
	CGContextDrawRadialGradient(context, spotLightGradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
}

- (void) dealloc {
	CGGradientRelease(spotLightGradient);
	[super dealloc];
}


@end
