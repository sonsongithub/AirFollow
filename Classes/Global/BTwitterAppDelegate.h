//
//  BTwitterAppDelegate.h
//  BTwitter
//
//  Created by sonson on 09/08/20.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class MainViewController;

@interface BTwitterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

- (void)openHUDOfString:(NSString*)message;
- (void)openActivityHUDOfString:(id)obj;
- (void)closeHUD;
@end

