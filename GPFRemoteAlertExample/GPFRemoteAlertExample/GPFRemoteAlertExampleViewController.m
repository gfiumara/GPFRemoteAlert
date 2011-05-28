//
//  GPFRemoteAlertExampleViewController.m
//  GPFRemoteAlertExample
//
//  Created by Greg Fiumara on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPFRemoteAlert.h"

#import "GPFRemoteAlertExampleViewController.h"

@implementation GPFRemoteAlertExampleViewController
@synthesize versionLabel;

- (void)viewDidLoad
{
	[versionLabel setText:[NSString stringWithFormat:@"Example App Version %0.1f",
			       [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]]];
	[[GPFRemoteAlert sharedRemoteAlert] displayAlertsForModule:@"module1"];
	[super viewDidLoad];
}

- (IBAction)showModule1Alerts:(id)sender
{
	[[GPFRemoteAlert sharedRemoteAlert] displayAlertsForModule:@"module1"];
}

- (IBAction)showModule2Alerts:(id)sender
{
	[[GPFRemoteAlert sharedRemoteAlert] displayAlertsForModule:@"module2"];
}

- (void)dealloc
{
#ifndef DEBUG
	[versionLabel release];
#else
	[versionLabel release], versionLabel = nil;
#endif
	[super dealloc];
}

@end
