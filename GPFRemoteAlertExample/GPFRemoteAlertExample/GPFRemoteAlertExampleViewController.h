//
//  GPFRemoteAlertExampleViewController.h
//  GPFRemoteAlertExample
//
//  Created by Greg Fiumara on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPFRemoteAlertExampleViewController : UIViewController {
    
	UILabel *versionLabel;
}
- (IBAction)showModule1Alerts:(id)sender;
- (IBAction)showModule2Alerts:(id)sender;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

@end
