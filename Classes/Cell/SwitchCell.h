#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SwitchCell : UITableViewCell {
    IBOutlet UISwitch *switchButton;
}
- (IBAction)switchChanged:(id)sender;
@property (nonatomic, retain) IBOutlet UISwitch *switchButton;
@end
