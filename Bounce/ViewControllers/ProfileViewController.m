//
//  ProfileViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "ViewController.h"
#import "TrackDetailsViewController.h"
#import "ArtistDetailsViewController.h"
#import "TrackCell.h"
#import "ArtistCell.h"
#import "Track.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"
#import "SpotifyManager.h"


@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isEditing;
@property (strong, nonatomic) NSArray *topTracksArray;
@property (strong, nonatomic) NSArray *topArtistsArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchTopTracks];
    [self fetchTopArtists];
    PFUser *user = [PFUser currentUser];
    if(user) {
        self.userLabel.text = user.username;
    } else {
        self.userLabel.text = @"Guest";
    }
    self.editingView.hidden = YES;
    [self.profileView setUserInteractionEnabled:NO];
    UITapGestureRecognizer *profileViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileViewClicked)];
    [self.profileView addGestureRecognizer:profileViewGesture];
    
    // Do any additional setup after loading the view.
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width/2;
    self.profileView.clipsToBounds = YES;
}

- (void)fetchTopTracks {
    [[SpotifyManager shared] getPersonalTopTracks:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
        self.topTracksArray = dictionary[@"items"];
        [self.tableView reloadData];
    }];
}

- (void)fetchTopArtists {
    [[SpotifyManager shared] getPersonalTopArtists:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
        self.topArtistsArray = dictionary[@"items"];
        [self.tableView reloadData];
    }];
}
- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"spotifyVC"];
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
    if (self.isEditing){
        self.profileView.userInteractionEnabled = NO;
        self.isEditing = NO;
        self.editingView.hidden = YES;
    } else {
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

    // Do something with the images (based on your use case)
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
        cell.trackArtistLabel.text = track.artists[0][@"name"];
        NSURL *url = [NSURL URLWithString:track.album.image.url];
        [cell.albumArtView setImageWithURL:url];
        return cell;
    } else { //top artists
        ArtistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ArtistCell"];
        Artist *artist =[[Artist alloc] initWithDictionary:self.topArtistsArray[indexPath.row]];
        cell.artistNameLabel.text = artist.name;
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
