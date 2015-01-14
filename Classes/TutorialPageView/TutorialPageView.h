//
//  TutorialPageView.h
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageView;

@interface TutorialPageView : UIViewController {
	int				page;
	UIImageView		*imageview;
	MessageView		*messageview;
}
@property (nonatomic, assign) int page;
@property (nonatomic, readonly) NSString *pageTitle;

+ (int)totalPage;
+ (NSString*)titleOfPage:(int)page;
+ (NSString*)messageOfPage:(int)page;
+ (UIImage*)imageOfPage:(int)page;
- (void)reloadContent;

@end
