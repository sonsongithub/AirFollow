#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RemainedTaskCell : UITableViewCell {
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIImageView *portraitImageView;
}
@property (nonatomic, readonly) UIImageView *portraitImageView;
@property (nonatomic, readonly) UIActivityIndicatorView *activity;
@end
