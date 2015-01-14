#import "P2PResultErrorView.h"

@implementation P2PResultErrorView

@synthesize description;

- (void)awakeFromNib {
	DNSLogMethod
	UIImage *buttonImage = [[UIImage imageNamed:@"defaultbutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
	[okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

- (void)dealloc {
	DNSLogMethod
    [super dealloc];
}

@end
