// GPFRemoteAlert.m
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

/// "Private" methods for GPFRemoteAlert
@interface GPFRemoteAlert()

/// @brief
/// Whether or not to display a particular alert
///
/// @param alertMetadata
/// A single entry from the remote alert property list containing all
/// particular metadata.
///
- (BOOL)shouldDisplayAlertWithMetadata:(NSDictionary *)alertMetadata;

/// @brief
/// Spawn a NSURLRequest to download the property list of alerts
- (void)retrieveAlerts;

@end
static GPFRemoteAlert *singletonInstance = nil;

@implementation GPFRemoteAlert

@synthesize alerts;
@synthesize connection;
@synthesize connectionData;
@synthesize propertyListVersion;

#pragma mark - Initialization of a Singleton Instance
// http://www.duckrowing.com/2010/05/21/using-the-singleton-pattern-in-objective-c/
+ (id)sharedRemoteAlert
{
	@synchronized (self) {
		if (singletonInstance == nil) {
			[[self alloc] init];
		}
	}
	
	return (singletonInstance);
		
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized (self) {
		if (singletonInstance == nil) {
			singletonInstance = [super allocWithZone:zone];
			return (singletonInstance);
		}
	}
	
	return (nil);
}

- (id)copyWithZone:(NSZone *)zone
{
	return (self);
}

- (id)retain
{
	return (self);
}

- (NSUInteger)retainCount
{
	return (NSUIntegerMax);
}

- (void)release
{
	// NOP
}

- (id)autorelease
{
	return (self);
}

- (id)init
{
	@synchronized (self) {
		[super init];
		[self retrieveAlerts];
		
		// TODO Because we use the non-blocking NSURLRequest to fetch
		//      the alerts, this always will return nil the first time
		//      because the connection will not return the property
		//      list fast enough.  Best bet is to initialize the shared
		//      object in your AppDelegate so that the alerts are 
		//      downloaded by the time a view loads, but that won't 
		//      be enough time for every app.  Add a queue to the object
		//      that tracks when you send displayAlertsForModule: and
		//      re-sends once the remote property list has been 
		//      downloaded.
		
		return (self);
	}
}

#pragma mark - URL Request
- (void)retrieveAlerts
{
	NSURLRequest *request = [NSURLRequest requestWithURL:
				 [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
						       kGPFRemoteAlertServer, 
						       kGPFRemoteAlertMessagePlistName]]
						 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
					     timeoutInterval:60];
	connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	if (connection != nil)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
	if (([(NSHTTPURLResponse *)response statusCode] / 100) == 2) 
		connectionData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
	[connectionData appendData:data];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error 
{
#ifdef DEBUG
	NSLog(@"Failed with error %@", [error localizedDescription]);
#endif
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString *dictionaryString = [[NSString alloc] initWithData:connectionData encoding:NSASCIIStringEncoding];
	alerts = [[NSDictionary alloc] initWithDictionary:[dictionaryString propertyList]];
	[dictionaryString release];
	
	propertyListVersion = [[NSNumber alloc] initWithUnsignedInteger:[[alerts objectForKey:kGPFRemoteAlertPropertyListVersion] unsignedIntValue]];
}

#pragma mark - Functionality
- (BOOL)shouldDisplayAlertWithMetadata:(NSDictionary *)alertMetadata
{
	BOOL displayAlert = NO;
	
	switch ([[self propertyListVersion] unsignedIntValue]) {
		case 1: {
			// Check that version is within range
			float bundleVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
			if (bundleVersion >= [[alertMetadata objectForKey:kMinVersionKey] floatValue] && 
			    bundleVersion <= [[alertMetadata objectForKey:kMaxVersionKey] floatValue])
				displayAlert = YES;
		}
	}
		
	return (displayAlert);
}

- (void)displayAlertsForModule:(NSString *)module
{
	@synchronized (self) {
		NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
		
		NSArray *moduleAlerts = [alerts objectForKey:module];
		for (NSDictionary *alert in moduleAlerts) {
			if ([self shouldDisplayAlertWithMetadata:alert]) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[alert objectForKey:kTitleKey] objectForKey:locale]
										    message:[[alert objectForKey:kMessageKey] objectForKey:locale]
										   delegate:nil
									  cancelButtonTitle:[[alert objectForKey:kCancelButtonKey] objectForKey:locale]
									  otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
	}
}

#pragma mark - Memory Management
- (void)cleanup
{
	@synchronized (self) {
#ifndef DEBUG
		[alerts release], alerts = nil;
		[connection release], connection = nil;
		[connectionData release], connectionData = nil;
		[propertyListVersion release], propertyListVersion = nil;
#else
		[alerts release];
		[connection release];
		[connectionData release];
		[propertyListVersion release];
#endif
		[singletonInstance release], singletonInstance = nil;
	}
}

@end
