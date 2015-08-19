//
//  AppDelegate.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "WelcomeViewController.h"
#import "SettingsManager.h"
#import "CoreDataManager.h"
#import "SaveQuizQuestionsOperation.h"
#import "ServiceCoordinator.h"
#import "CreateAgendaOperation.h"
#import "AddLocationsOperation.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)setupUserInterfaceWithOptions:(NSDictionary*)launchOptions {
    SettingsManager *settings = [SettingsManager sharedManager];
    CoreDataManager *coreData = [CoreDataManager sharedManager];
    //DO NOT MOVE OR REMOVE THIS. THESE OBJECTS MUST BE CREATED FIRST BEFORE ANYTHING ELSE.
    NSString *appVersionString = [SCConfigurationUtil applicationShortVersionString];
    if(settings.lastLaunchedAppVersion && ![settings.lastLaunchedAppVersion isEqualToString:appVersionString]) {
        SCLogMessage(kLogLevelDebug, @"App version change detected. Clearing the CoreData files.");
        [coreData clearStores];
    }
    [coreData setUpManagedObjects];
    [self populateAgenda];
    [self populateQuizQuestions];
    [self populateLocations];
    //END DO NOT MOVE SECTION
    
    settings.lastLaunchedAppVersion = appVersionString;    
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    NSString *username = sharedManager.username;
    if (username) {
        HomeViewController *homeViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    }
    else {
        WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc]initWithNibName:@"WelcomeViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = self.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
}

- (void)populateQuizQuestions
{
   SaveQuizQuestionsOperation *saveQuizOperation = [[SaveQuizQuestionsOperation alloc]initGame];
    [ServiceCoordinator addLocalOperation:saveQuizOperation completion:^(void) {
        // do something when it is finished
    }];
}

- (void)populateAgenda {
    CreateAgendaOperation *createAgendaOperation = [[CreateAgendaOperation alloc]initAgendaWithType:@"agenda"];
    [ServiceCoordinator addLocalOperation:createAgendaOperation completion:^(void){
    }];
}

- (void)populateLocations {
    AddLocationsOperation *locationsOperation = [[AddLocationsOperation alloc]initLocations];
    [ServiceCoordinator addLocalOperation:locationsOperation completion:^(void){
    }];
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
    // Saves changes in the application's managed object context before the application terminates.
}

@end
