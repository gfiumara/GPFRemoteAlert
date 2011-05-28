// GPFRemoteAlert.h
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

#import <Foundation/Foundation.h>

/// Server and path where GPFRemoteAlert property lists are stored.
static NSString * const kGPFRemoteAlertServer = @"http://<YOUR_DOMAIN>/";
/// Name of the file on the remote server that contains the alerts
static NSString * const kGPFRemoteAlertMessagePlistName = @"example_alerts.plist";

/// Name of the NSDictionary key for the title of the UIAlertView
static NSString * const kTitleKey = @"title";
/// Name of the NSDictionary key for the cancel button of the UIAlertView
static NSString * const kCancelButtonKey = @"cancelButton";
/// Name of the NSDictionary key for the message of the UIAlertView
static NSString * const kMessageKey = @"message";
/// Name of the NSDictionary key for the minimum bundle version of the UIAlertView
static NSString * const kMinVersionKey = @"minVersion";
/// Name of the NSDictionary key for the maximum bundle version of the UIAlertView
static NSString * const kMaxVersionKey = @"maxVersion";
/// Name of the NSDictionary key for the version of the remote alert property list
static NSString * const kGPFRemoteAlertPropertyListVersion = @"GPFRemoteAlertPropertyListVersion";

/// A class for displaying UIAlertViews pulled from a remote host at runtime.
@interface GPFRemoteAlert : NSObject
{

}

/// Alerts parsed from remote property list
@property(nonatomic, retain) NSDictionary *alerts;
/// Connection to remote server to download property list
@property(nonatomic, retain) NSURLConnection *connection;
/// Encoded alerts NSDictionary
@property(nonatomic, retain) NSMutableData *connectionData;
/// Version of the remote alert property list
@property(nonatomic, retain) NSNumber *propertyListVersion;

/// @brief
/// Retrieve and display any alerts for the current module.
- (void)displayAlertsForModule:(NSString *)module;

/// @brief
/// Return a singleton instance of GPFRemoteAlert
///
/// @details
/// When using the singleton instance, all modules should be included in the
/// remote property list.  This revision implements only the singleton instance.
/// Situations where you would need to load more than one remot property list
/// seem unlikely.
///
/// @return
/// Shared GPFRemoteAlert object.
+ (id)sharedRemoteAlert;

/// @brief
/// Free all possible used memory, including the reference to the current 
/// singleton.
///
/// @details
/// Should mainly be used in - didReceiveMemoryWarning, etc.
///
/// @note
/// Because we've gone to the trouble of making a singleton method, there's no
/// point in declaring a dealloc that will never get called.  Instead, let
/// the OS just quickly discard all our used memory at the end, saving time
/// for the host app to properly free any used resources.
- (void)cleanup;

@end
