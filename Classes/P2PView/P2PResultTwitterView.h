#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SNDownloadQueue.h"

@interface P2PResultTwitterView : UIView <SNDownloadQueueDelegate> {
    IBOutlet UILabel		*name;
    IBOutlet UIImageView	*portraitImage;
    IBOutlet UIButton		*saveButton;
    IBOutlet UIButton		*discardButton;
	IBOutlet UIActivityIndicatorView *activity;
	
	NSData	*imageBinary;
}
@property (nonatomic, retain) NSData *imageBinary;
@property (nonatomic, readonly) UILabel *name;
- (void)update;
- (void)updatePortraitImageView;
@end
