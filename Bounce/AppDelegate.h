//
//  AppDelegate.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>


@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) NSString *accessToken;
//- (void)setAccessToken:(NSString *)accessToken;
@property (nonatomic) SPTAppRemote *appRemote;
@end

