//
//  AppDelegate.m
//  BestAdmobIAd
//
//  Created by Charles-Hubert Basuiau on 18/11/2013.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Slot.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    RootViewController *rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
