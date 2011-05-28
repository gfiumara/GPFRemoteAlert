//
//  GPFRemoteAlertExampleAppDelegate.m
//  GPFRemoteAlertExample
//
//  Created by Greg Fiumara on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPFRemoteAlertExampleAppDelegate.h"

#import "GPFRemoteAlertExampleViewController.h"

@implementation GPFRemoteAlertExampleAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc
{
	[_window release];
	[_viewController release];
	
	[super dealloc];
}

@end
