#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SNHUDActivityView : UIImageView {
	UILabel					*label;
	UIActivityIndicatorView *indicator;
	UIImageView				*check;
}
+ (SNHUDActivityView*)sharedInstance;
- (void)setupWithMessage:(NSString*)msg;
- (BOOL)isShown;
- (BOOL)dismiss;
- (void)arrange:(CGRect)rect;
@end
