@import UIKit;
#import <SpotifyiOS/SpotifyiOS.h>


NS_ASSUME_NONNULL_BEGIN


@interface ViewController : UIViewController <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;
@property (nonatomic) SPTAppRemote *appRemote;
+ (instancetype)shared;
- (void)setConfiguration;
@end


NS_ASSUME_NONNULL_END
