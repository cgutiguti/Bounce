//
//  SceneDelegate.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "SceneDelegate.h"
#import "ViewController.h"



@interface SceneDelegate ()
@property ViewController *spotifyVC;
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene openURLContexts:(nonnull NSSet<UIOpenURLContext *> *)URLContexts {
//    [self.rootViewController.sessionManager application:application openURL:URL options:options];
//    NSLog(@"%@ %@", URL, options);
////    return YES;
//    NSURL *url = [[URLContexts allObjects] firstObject].URL;
//    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    UIOpenURLContext *ctx = [URLContexts allObjects][0];
    
 //   ViewController *rootVC = (ViewController *) [UIApplication sharedApplication].keyWindow.rootViewController;
 //   [rootVC.sessionManager application:[UIApplication sharedApplication] openURL:ctx.URL options:ctx.options];
    [self.spotifyVC.sessionManager application:[UIApplication sharedApplication] openURL:ctx.URL options:ctx.options];
}
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//    NSSet *c = connectionOptions.URLContexts;
//    if(c && [c count] > 0)
//    {
//        NSURL *url = ((UIOpenURLContext*)[[c allObjects] firstObject]).URL;
//        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
//    }
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
 //   self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *spotifyVC = [storyboard instantiateViewControllerWithIdentifier:@"spotifyVC"];
    self.window.rootViewController = spotifyVC;
    self.spotifyVC = spotifyVC;
    
}



- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
