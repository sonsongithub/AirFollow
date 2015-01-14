//
//  MessageView.m
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageView.h"

#define _MessageViewFont	14
#define _MESSAGE_VIEW_SIZE	275

@implementation MessageView

- (id)initWithMessage:(NSString*)string {
	message = [string retain];
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:_MessageViewFont] constrainedToSize:CGSizeMake(_MESSAGE_VIEW_SIZE, 120) lineBreakMode:UILineBreakModeCharacterWrap];
	
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width+20, size.height+20)]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawBack:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// outline 
	CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
	CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
	
	// radius is 12 when width = 59
	float radius = 10;//rect.size.width / 5;
	
	// offset 3 = 59
	//float y_offset = -rect.size.width * 1.0f / 59.0f;
	
	// spraed 2 = 59
	//float spread = rect.size.width * 3.0f / 59.0f;
	
	CGContextSetRGBFillColor(context, 0.25, 0.25, 0.25, 0.90);
	
	CGContextSaveGState(context);
//	CGContextSetShadowWithColor(context, CGSizeMake(0, y_offset), spread, [UIColor blackColor].CGColor);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[self drawBack:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:_MessageViewFont] constrainedToSize:CGSizeMake(_MESSAGE_VIEW_SIZE, 120) lineBreakMode:UILineBreakModeCharacterWrap];
	
	float x = (int)((rect.size.width - size.width) / 2);
	float y = (int)((rect.size.height - size.height) / 2);
	CGRect messageRect = CGRectMake(x, y, size.width, size.height);
	
	[message drawInRect:messageRect withFont:[UIFont boldSystemFontOfSize:_MessageViewFont] lineBreakMode:UILineBreakModeCharacterWrap];
}

- (void)dealloc {
	[message release];
    [super dealloc];
}


@end
