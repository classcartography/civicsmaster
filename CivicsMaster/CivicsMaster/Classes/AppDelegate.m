//
//  AppDelegate.m
//  CivicsMaster
//
//  Created by Chamara Paul on 6/3/13.
//  Copyright (c) 2013 CitizenshipFirst. All rights reserved.
//

#import "AppDelegate.h"
#import "DDFileLogger.h"
#import "DDNSLoggerLogger.h"


@interface AppDelegate (HiddenMethods)
- (void)configureExternalLibraries;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark hidden methods

- (void)configureExternalLibraries {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [DDLog addLogger:fileLogger];
    [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    UIColor *gray = [UIColor colorWithRed:(80.0/255.0) green:(80.0/255.0) blue:(80.0/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:gray backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    
    if ([[fileLogger.logFileManager unsortedLogFilePaths] count] == 0) {
        ELOG(@"Init"); // Make sure log file exists
        _logFilePath = [[fileLogger.logFileManager unsortedLogFilePaths] objectAtIndex:0];
    } else {
        for (NSString *s in [fileLogger.logFileManager unsortedLogFilePaths]) {
            if ([s rangeOfString:@"archived"].location == NSNotFound) {
                _logFilePath = s;
            }
        }
    }
    DLOG(@"Logging: %@", _logFilePath);
    
    NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
#ifdef DEBUG
    ILOG(@"app version = %@", appVersion);
#elif DISTRIBUTION
    ILOG(@"app version = %@", appVersion);
#else //RELEASE
    ELOG(@"app version = %@", appVersion);
#endif
}

@end
