//
//  TutorialPageController.h
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TutorialPageController : UIViewController <UIScrollViewDelegate> {
    UIScrollView	*scrollView;
    UIPageControl	*pageControl;
    NSMutableArray	*viewControllers;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}
- (void)loadScrollViewWithPage:(int)page;
- (void)changePage:(id)sender;
- (void)setupContent;
@end
