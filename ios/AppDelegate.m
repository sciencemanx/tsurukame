//
//  AppDelegate.m
//  wk
//
//  Created by David Sansome on 22/11/17.
//  Copyright © 2017 David Sansome. All rights reserved.
//

#import "AppDelegate.h"
#import "Client.h"
#import "DataLoader.h"
#import "MainViewController.h"
#import "ReviewViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
  DataLoader *_dataLoader;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  _dataLoader = [[DataLoader alloc] initFromURL:[[NSBundle mainBundle] URLForResource:@"data"
                                                                        withExtension:@"bin"]];

  Client *client = [[Client alloc] initWithApiToken:@"(redacted in git history)"];
  
  MainViewController *vc = [[MainViewController alloc] init];
  
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = nav;
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  NSLog(@"Starting thread %@", [NSThread currentThread]);
  [client getAllAssignments:^(NSError *error, NSArray<WKAssignment *> *assignments) {
    if (error) {
      NSLog(@"Failed to get assignments: %@", error);
      return;
    }
    NSLog(@"Callback thread %@", [NSThread currentThread]);
    NSLog(@"Got %lu assignments", (unsigned long)assignments.count);
    NSArray<ReviewItem *> *items = [ReviewItem assignmentsReadyForReview:assignments];
    NSLog(@"Got %lu items", (unsigned long)items.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      ReviewViewController *rvc = [[ReviewViewController alloc]
                                   initWithItems:items
                                   dataLoader:_dataLoader];
      [vc.navigationController pushViewController:rvc animated:YES];
    });
  }];

  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end