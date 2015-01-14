//
//  TutorialPageController.m
//  TutorialTest
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TutorialPageController.h"
#import "TutorialPageView.h"

@implementation TutorialPageController

#pragma mark -
#pragma mark Instance method

- (void)updateTitle:(int)page {
	if ([TutorialPageView totalPage] > page && page >= 0) {
		TutorialPageView *controller = [viewControllers objectAtIndex:page];
		self.title = [controller pageTitle];
	}
}

- (void)loadScrollViewWithPage:(int)page {
	
    if (page < 0) return;
    if (page >= [TutorialPageView totalPage]) return;
	
    // replace the placeholder if necessary
    TutorialPageView *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[TutorialPageView alloc] initWithNibName:nil bundle:nil];
		controller.page = page;
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)changePage:(id)sender {
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
	
	[self updateTitle:page];
}

- (void)setupContent {
	viewControllers = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [TutorialPageView totalPage]; i++)
		[viewControllers addObject:[NSNull null]];
	
	pageControl.numberOfPages = [TutorialPageView totalPage];
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [TutorialPageView totalPage], scrollView.frame.size.height);
	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Override

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	scrollView.frame = self.view.bounds;
	pageControl.frame = CGRectMake(0, self.view.bounds.size.height-36, 320, 36);
	[self setupContent];
	[self updateTitle:0];
	
	UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)] autorelease];
	self.navigationItem.rightBarButtonItem = done;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor colorWithRed:143.0f/255.0f green:145.0f/255.0f blue:146.0f/255.0f alpha:255.0f/255.0f];
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		[self.view addSubview:scrollView];
		
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
		pageControl.currentPage = 0;
		[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		[self.view addSubview:pageControl];
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
	[self updateTitle:page];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[pageControl release];
	[scrollView release];
	[viewControllers release];
    [super dealloc];
}

@end
