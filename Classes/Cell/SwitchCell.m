#import "SwitchCell.h"

@implementation SwitchCell

@synthesize switchButton;

- (IBAction)switchChanged:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
		[[NSUserDefaults standardUserDefaults] setBool:((UISwitch*)sender).on forKey:@"AutoFollowingFlag"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) dealloc {
	[switchButton release];
	[super dealloc];
}

@end
