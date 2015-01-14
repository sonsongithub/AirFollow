#import "P2PStatusInitView.h"

@implementation P2PStatusInitView

- (void)awakeFromNib {
	DNSLogMethod
	UIImage *buttonImage = [[UIImage imageNamed:@"defaultbutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
	[cancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

- (void)dealloc {
	DNSLogMethod
    [super dealloc];
}

@end
