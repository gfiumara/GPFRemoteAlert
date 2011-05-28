// GPFRemoteAlertExampleViewController.m
//
// Copyright (c) 2011, Greg Fiumara
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name of Greg Fiumara nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "GPFRemoteAlert.h"

#import "GPFRemoteAlertExampleViewController.h"

@implementation GPFRemoteAlertExampleViewController
@synthesize versionLabel;

- (void)viewDidLoad
{
	[versionLabel setText:[NSString stringWithFormat:@"Example App Version %0.1f",
			       [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]]];
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
