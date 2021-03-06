
//view models
#import "ConnectView.h"
//view controllers
#import "ViewController.h"
#import "LoginViewController.h"
//outside functions
#import "AppDelegate.h"
#import <SpotifyiOS/SpotifyiOS.h>

//Spotify API connection parameters
static NSString * const SpotifyClientID = @"78a164a9d67e4cd4857e69bd9b70b2bb";
static NSString * const SpotifyRedirectURLString = @"bounce-spotify://callback";

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - Authorization 

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     This configuration object holds your client ID and redirect URL.
     */
    [self setConfiguration];
}

/* View controller must be shared so that other views can access the song player app remote that is initialized here. */
+ (instancetype) shared{
    static dispatch_once_t once;
    static ViewController *sharedObject = nil;
    dispatch_once(&once, ^{
        sharedObject = [[ViewController alloc] init];
        [sharedObject setConfiguration];
    });
    return sharedObject;
}

- (void)setConfiguration {
    self.sessionManager.delegate = self;
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    // Set these url's to your backend which contains the secret to exchange for an access token
    // You can use the provided ruby script spotify_token_swap.rb for testing purposes
    configuration.tokenSwapURL = [NSURL URLWithString: @"https://bounce-spotify.herokuapp.com/api/token"];
    configuration.tokenRefreshURL = [NSURL URLWithString: @"https://bounce-spotify.herokuapp.com/api/refresh_token"];
    //configuration.playURI = @"";
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:configuration logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self;

    /*  The session manager lets you authorize, get access tokens, and so on.  */
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                    delegate:self];
}
#pragma mark - Actions

- (void)didTapAuthButton:(ConnectButton *)sender
{
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    SPTScope scope = SPTPlaylistReadPrivateScope | SPTPlaylistModifyPublicScope | SPTPlaylistModifyPrivateScope |SPTUserFollowReadScope | SPTUserFollowModifyScope | SPTUserLibraryReadScope | SPTUserLibraryModifyScope | SPTUserTopReadScope | SPTAppRemoteControlScope | SPTUserReadEmailScope | SPTUserReadPrivateScope | SPTStreamingScope | SPTUserModifyPlaybackStateScope;

    /*
     Start the authorization process. This requires user input.
     */
    if (@available(iOS 11, *)) {
        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    if (session) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"connectToLoginSegue" sender:session.accessToken];
        });
    }
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    [self presentAlertControllerWithTitle:@"Authorization Failed"
                                  message:error.description
                              buttonTitle:@"Bummer"];
    NSLog(error.description);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Session Renewed"
                                  message:session.description
                              buttonTitle:@"Sweet"];
}

#pragma mark - Set up view

- (void)loadView
{
    ConnectView *view = [ConnectView new];
       [view.connectButton addTarget:self action:@selector(didTapAuthButton:) forControlEvents:UIControlEventTouchUpInside];
       self.view = view;}

- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            buttonTitle:(NSString *)buttonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:dismissAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    });
}
#pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"connectToLoginSegue"]) {
        LoginViewController *loginVC = [segue destinationViewController];
        loginVC.accessToken = sender;
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"Error connecting to Spotify app %@",error);
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if(error){
        NSLog(@"SPTAppRemote player error: %@",error.description);
        }else{
            NSLog(@"SPTAppRemote player connected.");
        }
    }];
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
     NSLog(@"Track name: %@" , playerState.track.name);
}


@end
