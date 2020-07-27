//
//  AppDelegate.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

static NSString * const SpotifyClientID = @"78a164a9d67e4cd4857e69bd9b70b2bb";
static NSString * const SpotifyRedirectURLString = @"bounce-spotify://callback";


@interface AppDelegate ()

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property(nonatomic, strong) ViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
     self.window.rootViewController = [ViewController new];
     self.rootViewController = [ViewController new];
    
    //self.window.rootViewController = [LoginViewController new];
    // self.rootViewController = [LoginViewController new];
    
    
     self.window.rootViewController = self.rootViewController;
     [self.window makeKeyAndVisible];
    
    
    
    
    //Parse config
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"bounce-parse";
        configuration.server = @"http://bounce_parse.herokuapp.com/parse";
    }];
    [Parse initializeWithConfiguration:config];
    
//    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
//                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
//
//    // Set these url's to your backend which contains the secret to exchange for an access token
//    // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//    configuration.tokenSwapURL = [NSURL URLWithString: @"https://bounce-spotify.herokuapp.com/api/token"];
//    configuration.tokenRefreshURL = [NSURL URLWithString: @"https://bounce-spotify.herokuapp.com/api/refresh_token"];
//
//    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
//    self.appRemote.delegate = self;
     return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    [self.rootViewController.sessionManager application:application openURL:URL options:options];
    NSLog(@"%@ %@", URL, options);
    return YES;
}
- (void)sessionManager:(nonnull SPTSessionManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"fail: %@", error);
}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    if (session) {
        NSLog(@"%@" , session.description);
    }
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"failed.");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"connected");
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
      if (error) {
        NSLog(@"error: %@", error.localizedDescription);
      }
    }];
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"player state changed");
    NSLog(@"Track name: %@", playerState.track.name);
}
//- (void)setAccessToken:(NSString *)accessToken {
//    self.accessToken = accessToken;
//}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    UISceneConfiguration *configuration = [[UISceneConfiguration alloc] init];
    configuration.delegateClass = SceneDelegate.class;
    return configuration;
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
