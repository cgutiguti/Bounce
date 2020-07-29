//
//  ProfileViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

//standard
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "SpotifyManager.h"
//view controllers
#import "ViewController.h"
#import "TrackDetailsViewController.h"
#import "ArtistDetailsViewController.h"
#import "LoginViewController.h"
//models and views
#import "TrackCell.h"
#import "ArtistCell.h"
#import "Track.h"
#import "Artist.h"


@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
//storyboard outlets
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeRangeControl;
//editing booleans
@property BOOL isEditing;
//data
@property (strong, nonatomic) NSArray *topTracksArray;
@property (strong, nonatomic) NSArray *topArtistsArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    //set up delegates/datasources
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //get list of user's top tracks and artists
    [self fetchTopTracks];
    [self fetchTopArtists];
    //if user is logged in, display their username. if not, display Guest.
    PFUser *user = [PFUser currentUser];
    if(user) {
        self.userLabel.text = user.username;
    } else {
        self.userLabel.text = @"Guest";
    }
    //setup editing mode
    self.editingView.hidden = YES;
    [self.profileView setUserInteractionEnabled:NO];
    UITapGestureRecognizer *profileViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileViewClicked)];
    [self.profileView addGestureRecognizer:profileViewGesture];
    //make profile view a circle
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width/2;
    self.profileView.clipsToBounds = YES;
    //redo search if time range has changed.
    [self.timeRangeControl addTarget:self action:@selector(didChangeTimeRange) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchTopTracks {
    if ([self.timeRangeControl selectedSegmentIndex] == 0){ //short term
        [[SpotifyManager shared] getPersonalTopTracks:@"?time_range=short_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topTracksArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    } else if ([self.timeRangeControl selectedSegmentIndex] == 1){ //medium term
        [[SpotifyManager shared] getPersonalTopTracks:@"?time_range=medium_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topTracksArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    } else { //long term
        [[SpotifyManager shared] getPersonalTopTracks:@"?time_range=long_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topTracksArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    }
}

- (void)fetchTopArtists {
    if ([self.timeRangeControl selectedSegmentIndex] == 0){ //short term
        [[SpotifyManager shared] getPersonalTopArtists:@"?time_range=short_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topArtistsArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    } else if ([self.timeRangeControl selectedSegmentIndex] == 1){ //medium term
        [[SpotifyManager shared] getPersonalTopArtists:@"?time_range=medium_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topArtistsArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    } else { //long term
        [[SpotifyManager shared] getPersonalTopArtists:@"?time_range=long_term" accessToken:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
            self.topArtistsArray = dictionary[@"items"];
            [self.tableView reloadData];
        }];
    }
}

- (void)didChangeTimeRange { //should redo search if user changed time range
    [self fetchTopArtists];
    [self fetchTopTracks];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error:", error);
        }
    }];
    NSLog(@"User logged out successfully!");
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapSettings:(id)sender {
    if (self.isEditing){ //if user is already editing, then turn off editing mode
        self.profileView.userInteractionEnabled = NO;
        self.isEditing = NO;
        self.editingView.hidden = YES;
    } else { // if user is not already editing, then turn on editing mode
        self.profileView.userInteractionEnabled = YES;
        self.isEditing = YES;
        self.editingView.hidden = NO;
    }
}

- (void) profileViewClicked {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Resize image for upload to Parse server. Set profileView's image to chosen image.
    CGSize size = CGSizeMake(originalImage.size.width/3, originalImage.size.height/3);
    [self resizeImage:originalImage withSize:size];
    self.profileView.image = originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0){ //top tracks
        TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
        Track *track = [[Track alloc] initWithDictionary:self.topTracksArray[indexPath.row]];
        cell.trackTitleLabel.text = track.name;
        // For each artist of the track, append separated by commas.
        NSString *artistsList = @"";
        for (NSDictionary *artist in track.artists) {
            if(artistsList.length == 0) {
                artistsList = [artistsList stringByAppendingFormat:@"%@", artist[@"name"]];
            } else {
                artistsList = [artistsList stringByAppendingFormat:@", %@", artist[@"name"]];
            }
        }
        cell.trackArtistLabel.text = artistsList;
        //set image with url and make circular image.
        NSURL *url = [NSURL URLWithString:track.album.image.url];
        [cell.albumArtView setImageWithURL:url];
        cell.albumArtView.layer.cornerRadius = 5;
        cell.albumArtView.clipsToBounds = YES;
        return cell;
    } else { //top artists
        ArtistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ArtistCell"];
        Artist *artist =[[Artist alloc] initWithDictionary:self.topArtistsArray[indexPath.row]];
        cell.artistNameLabel.text = artist.name;
        //set image with url and make circular image.
        NSURL *url = [NSURL URLWithString:artist.image.url];
        [cell.artistImageView setImageWithURL:url];
        cell.artistImageView.layer.cornerRadius =  cell.artistImageView.frame.size.width/2;
        cell.artistImageView.clipsToBounds = YES;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { //top tracks
        return self.topTracksArray.count;
    } else { //top artists
        return self.topArtistsArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Top Tracks";
    }
    if (section == 1) {
        return @"Top Artists";
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    if (indexPath.section == 0) { // top tracks -- segue to track details View controller
        NSDictionary *trackDict = self.topTracksArray[indexPath.row];
        Track *track = [[Track alloc] initWithDictionary:trackDict];
        TrackDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.accessToken = self.accessToken;
        detailsVC.track = track;
    } else if (indexPath.section == 1) { // related artists -- segue to new artist details view controller
        Artist *artist = [[Artist alloc] initWithDictionary:self.topArtistsArray[indexPath.row]];
        ArtistDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.accessToken = self.accessToken;
        detailsVC.artist = artist;
    }
}






@end
