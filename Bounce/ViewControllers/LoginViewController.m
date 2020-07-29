//
//  LoginViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/15/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

//view controllers
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "AffinitiesViewController.h"
#import "ProfileViewController.h"
//outside functions
#import "SpotifyManager.h"
#import <Parse/Parse.h>
//models
#import "Track.h"




@interface LoginViewController ()
//storyboard outlets
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
//data
@property (strong, nonatomic) NSMutableArray *tracksData;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPlaylistData];
    // Set up green round buttons formatting
    UIColor *color = [UIColor colorWithRed:(29.0 / 255.0) green:(185.0 / 255.0) blue:(84.0 / 255.0) alpha:1.0];
    self.loginButton.backgroundColor = color;
    self.loginButton.layer.cornerRadius = 20.0;
    self.signupButton.backgroundColor = color;
    self.signupButton.layer.cornerRadius = 20.0;
    self.skipButton.backgroundColor = color;
    self.skipButton.layer.cornerRadius = 20.0;
}

- (void)fetchPlaylistData {
    self.tracksData = [[NSMutableArray alloc] init];
    [[SpotifyManager shared] getPersonalPlayLists:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
        NSArray *data = dictionary[@"items"];
        for (NSDictionary *playlist in data) {
            NSString *href = [playlist[@"tracks"][@"href"] substringFromIndex:23];
            [[SpotifyManager shared] doGetRequest:href accessToken:self.accessToken completion:^(NSDictionary * trackList, NSError * error) {
                if (trackList) {
                    NSArray *trackArray = trackList[@"items"];
                    [self.tracksData addObjectsFromArray:trackArray];
                }
            }];
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error: "
           message:@"Username or Password is empty."
    preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            // display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    // initialize a user object
      PFUser *newUser = [PFUser user];
      
      // set user properties
      newUser.username = self.usernameField.text;
      newUser.password = self.passwordField.text;
      
      // call sign up function on the object
      [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
          if (error != nil) {
              NSLog(@"Error: %@", error.localizedDescription);
          } else {
              NSLog(@"User registered successfully");
              [self performSegueWithIdentifier:@"loginSegue" sender:nil];
              // manually segue to logged in view
          }
      }];
}

- (IBAction)didTapSkip:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:self.accessToken];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UITabBarController* tbc = [segue destinationViewController];
        SearchViewController* searchVC = [[SearchViewController alloc] init];
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        AffinitiesViewController *affinitiesVC = [[AffinitiesViewController alloc] init];
        
        UINavigationController *searchNav = [[UINavigationController alloc] init];
        UINavigationController *profileNav = [[UINavigationController alloc] init];
        UINavigationController *affinitiesNav = [[UINavigationController alloc] init];
        
        affinitiesNav = (UINavigationController *)[[tbc customizableViewControllers] objectAtIndex:0];
        searchNav = (UINavigationController *)[[tbc customizableViewControllers] objectAtIndex:1];
        profileNav = (UINavigationController *)[[tbc customizableViewControllers] objectAtIndex:2];
        
        searchVC = (SearchViewController *)[searchNav topViewController];
        profileVC = (ProfileViewController *)[profileNav topViewController];
        affinitiesVC = (AffinitiesViewController *)[affinitiesNav topViewController];
        
        searchVC.accessToken = self.accessToken;
        profileVC.accessToken = self.accessToken;
        affinitiesVC.accessToken = self.accessToken;
        affinitiesVC.tracksData = self.tracksData;
        
        
        tbc.selectedIndex = 1;
       }
}


@end
