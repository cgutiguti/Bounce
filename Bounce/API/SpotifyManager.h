//
//  SpotifyManager.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/20/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.

#import <SpotifyiOS/SpotifyiOS.h>
#import "AFNetworking.h"
#import "AFOAuth2Manager.h"
#import "AFHTTPRequestSerializer+OAuth2.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : AFOAuth2Manager

+(instancetype)shared;

- (void)getSong:(NSString *)songURI accessToken:(NSString *)token completion:(void(^)(NSDictionary *song, NSError *error))completion; //could delete Token
- (void) searchForSong:(NSString *)songQueryURI  accessToken:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion;
- (void) getAudioFeaturesForTrack:(NSString *)songURI  accessToken:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion;
@end

NS_ASSUME_NONNULL_END
