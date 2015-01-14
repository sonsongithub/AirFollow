//
//  TutorialPageView.m
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TutorialPageView.h"
#import "MessageView.h"

NSMutableArray *images = nil;
NSMutableArray *messages = nil;
NSMutableArray *titles = nil;

@implementation TutorialPageView

@dynamic page, pageTitle;

#pragma mark -
#pragma mark Class method

+ (void)initialize {
	images = [[NSMutableArray array] retain];
	messages = [[NSMutableArray array] retain];
	titles = [[NSMutableArray array] retain];
	
	[images addObject:[UIImage imageNamed:@"screenshot01.png"]];
	[messages addObject:NSLocalizedString(@"Thank you for downloading AirFollow!!", nil)];
	[titles addObject:NSLocalizedString(@"Tutorial", nil)];
	
	[images addObject:[UIImage imageNamed:@"screenshot02.png"]];
	[messages addObject:NSLocalizedString(@"At first, fill out your twitter account's information.", nil)];
	[titles addObject:NSLocalizedString(@"Account setting", nil)];
	
//	[images addObject:[UIImage imageNamed:@"picture01.png"]];
//	[messages addObject:NSLocalizedString(@"Start!", nil)];
//	[titles addObject:NSLocalizedString(@"Start", nil)];
	
	[images addObject:[UIImage imageNamed:@"picture02.png"]];
	[messages addObject:NSLocalizedString(@"Run AirFollow together with your friend.", nil)];
	[titles addObject:NSLocalizedString(@"Together", nil)];
		
	[images addObject:[UIImage imageNamed:@"picture03.png"]];
	[messages addObject:NSLocalizedString(@"Push the big button.", nil)];
	[titles addObject:NSLocalizedString(@"Push the button", nil)];
	
	[images addObject:[UIImage imageNamed:@"picture04.png"]];
	[messages addObject:NSLocalizedString(@"Bluetooth window is opened. Automatically, iPhones start to search each other.", nil)];
	[titles addObject:NSLocalizedString(@"Bluetooth", nil)];
	
	[images addObject:[UIImage imageNamed:@"picture05.png"]];
	[messages addObject:NSLocalizedString(@"The device list is displayed. In case unfortunately your iPhone can't search each other, you have to retry from beginning.", nil)];
	[titles addObject:NSLocalizedString(@"Device list", nil)];
	
//	[images addObject:[UIImage imageNamed:@"picture06.png"]];
//	[messages addObject:NSLocalizedString(@"In case unfortunately your iPhone can't search each other, you have to retry from beginning.", nil)];
//	[titles addObject:NSLocalizedString(@"Device list", nil)];
	
	[images addObject:[UIImage imageNamed:@"picture07.png"]];
	[messages addObject:NSLocalizedString(@"Push Accept if you want to continue it.", nil)];
	[titles addObject:NSLocalizedString(@"Accept", nil)];
	
	[images addObject:[UIImage imageNamed:@"picture09.png"]];
	[messages addObject:NSLocalizedString(@"Finally, your friend's twitter name and icon are displayed.", nil)];
	[titles addObject:NSLocalizedString(@"Result", nil)];
	
	[images addObject:[UIImage imageNamed:@"screenshot03.png"]];
	[messages addObject:NSLocalizedString(@"Push Twitter, to confirm the result of exchanging.", nil)];
	[titles addObject:NSLocalizedString(@"Open Twitter", nil)];
	
	[images addObject:[UIImage imageNamed:@"screenshot04.png"]];
	[messages addObject:NSLocalizedString(@"Accept your friend's twitter account is shown on your remained list. You can follow it by taping the list.", nil)];
	[titles addObject:NSLocalizedString(@"Remained list", nil)];
	
	[images addObject:[UIImage imageNamed:@"screenshot05.png"]];
	[messages addObject:NSLocalizedString(@"If this value is set ON, following starts immediately after exchanging.", nil)];
	[titles addObject:NSLocalizedString(@"Auto follow", nil)];
	
}

+ (int)totalPage {
	return [images count];
}

+ (NSString*)titleOfPage:(int)page {
	if (page < [titles count])
		return [titles objectAtIndex:page];
	return nil;
}

+ (NSString*)messageOfPage:(int)page {
	if (page < [messages count])
		return [messages objectAtIndex:page];
	return nil;
}

+ (UIImage*)imageOfPage:(int)page {
	if (page < [images count])
		return [images objectAtIndex:page];
	return nil;
}

#pragma mark -
#pragma mark Accessor

- (NSString*)pageTitle {
	return [[self class] titleOfPage:page];
}

- (void)setPage:(int)newValue {
	if (page != newValue) {
		page = newValue;
		[self reloadContent];
	}
}

#pragma mark -
#pragma mark Instance method

- (void)reloadContent {
	[imageview removeFromSuperview];
	imageview = [[UIImageView alloc] initWithImage:[[self class] imageOfPage:page]];
	[self.view addSubview:[imageview autorelease]];
	
	[messageview removeFromSuperview];
	messageview= [[MessageView alloc] initWithMessage:[[self class] messageOfPage:page]];
	[self.view addSubview:[messageview autorelease]];
	CGRect frame = messageview.frame;
	frame.origin.x = (int)(self.view.frame.size.width - messageview.frame.size.width)/2;
	frame.origin.y = (int)(imageview.frame.size.height - messageview.bounds.size.height);
	messageview.frame = frame;
}

#pragma mark -
#pragma mark Override

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.view.backgroundColor = [UIColor colorWithRed:143.0f/255.0f green:145.0f/255.0f blue:146.0f/255.0f alpha:255.0f/255.0f];
		[self reloadContent];
    }
    return self;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end
