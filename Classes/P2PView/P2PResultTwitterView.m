#import "P2PResultTwitterView.h"
#import "SNDownloadManager.h"
#import "SNSFollowTool.h"
#import "TwitterShowQueue.h"
#import "TwitterImageQueue.h"

@implementation P2PResultTwitterView

@synthesize name;
@synthesize imageBinary;

#pragma mark -
#pragma mark Instance method

- (void)update {
	DNSLogMethod
	[activity startAnimating];
	NSURLRequest *request = [SNSFollowTool URLRequestOfTwitterShowFriendName:name.text];
	TwitterShowQueue *queue = [TwitterShowQueue queueFromURLRequest:request];
	queue.target = self;
	queue.needsOfflineError = NO;
	[[SNDownloadManager sharedInstance] addQueue:queue];
}

- (void)updatePortraitImageView {
	UIImage *image = [UIImage imageWithData:self.imageBinary];
	if (image) {
		[portraitImage setImage:image];
		[activity stopAnimating];
	}
	else {
		UIImage *defaultImage = [UIImage imageNamed:@"default_profile_bigger.png"];
		[portraitImage setImage:defaultImage];
		[activity stopAnimating];
	}
}

#pragma mark -
#pragma mark SNDownloadQueueDelegate

- (void)didDownloadQueue:(SNDownloadQueue*)queue userInfo:(NSDictionary*)userInfo {
	self.imageBinary = [userInfo objectForKey:KeyForTwitterImage];
	[self updatePortraitImageView];
}

- (void)failedDownloadQueue:(SNDownloadQueue*)queue {
	[self updatePortraitImageView];
}

#pragma mark -
#pragma mark Override

- (void)awakeFromNib {
	DNSLogMethod
	UIImage *buttonImage = [[UIImage imageNamed:@"defaultbutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
	[discardButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
	[[SNDownloadManager sharedInstance] removeAllQueue];
	[imageBinary release];
    [super dealloc];
}

@end
