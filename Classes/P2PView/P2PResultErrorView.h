#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface P2PResultErrorView : UIView {
    IBOutlet UILabel		*description;
    IBOutlet UILabel		*title;
    IBOutlet UIButton		*okButton;
}
@property (nonatomic, readonly) UILabel	*description;
@end
