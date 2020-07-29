//
//  ArtistDetailsViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/21/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

//view controllers
#import "ArtistDetailsViewController.h"
#import "TrackDetailsViewController.h"
//cell models
#import "ArtistDetailsCell.h"
#import "ArtistCell.h"
#import "TrackCell.h"
//models
#import "Artist.h"
#import "Track.h"
//outside functions
#import "UIImageView+AFNetworking.h"
#import "SpotifyManager.h"


@interface ArtistDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
//storyboard outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//data
@property (strong, nonatomic) NSArray *topTracksArray;
@property (strong, nonatomic) NSArray *relatedArtistsArray;
@end

@implementation ArtistDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchTopTracks];
    [self fetchRelatedArtists];
    // Do any additional setup after loading the view.
}
- (void) fetchTopTracks {
    [[SpotifyManager shared] getArtistTopTracks:self.artist.id accessToken:self.accessToken completion:^(NSDictionary * _Nonnull array, NSError * _Nonnull error) {
        self.topTracksArray = array[@"tracks"];
        [self.tableView reloadData];
    }];
    
}
- (void) fetchRelatedArtists {
    [[SpotifyManager shared] getRelatedArtists:self.artist.id accessToken:self.accessToken completion:^(NSDictionary * _Nonnull array, NSError * _Nonnull error) {
        self.relatedArtistsArray = array[@"artists"];
        [self.tableView reloadData];
    }];
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ArtistDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier: @"ArtistDetailsCell"];
        cell.artistNameLabel.text = self.artist.name;
        //cell.artistPopularityLabel.text = self.artist.popularity;
        NSString *genresList = @"";
        for (NSDictionary *genre in self.artist.genres) {
                  if(genresList.length == 0) {
                      genresList = [genresList stringByAppendingString:genre];
                  } else {
                      genresList = [genresList stringByAppendingFormat:@", %@", genre];
                  }
              }
        cell.genresLabel.text = genresList;
        NSURL *url = [NSURL URLWithString:self.artist.image.url];
        [cell.artistImageView setImageWithURL:url];
        cell.artistImageView.layer.cornerRadius =  cell.artistImageView.frame.size.width/2;
        cell.artistImageView.clipsToBounds = YES;
        return cell;
    } else if (indexPath.section == 1) {//top tracks section
        TrackCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TrackCell"];
        Track *track = [[Track alloc] initWithDictionary:self.topTracksArray[indexPath.row]];
        cell.trackTitleLabel.text = track.name;
        cell.track = track;
        NSURL *url = [NSURL URLWithString:track.album.image.url];
        [cell.albumArtView setImageWithURL:url];
        cell.albumArtView.layer.cornerRadius =  5;
        cell.albumArtView.clipsToBounds = YES;
        return cell;
    } else { // related artists section
        ArtistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ArtistCell"];
        Artist *artist =[[Artist alloc] initWithDictionary:self.relatedArtistsArray[indexPath.row]];
        cell.artistNameLabel.text = artist.name;
        NSURL *url = [NSURL URLWithString:artist.image.url];
        [cell.artistImageView setImageWithURL:url];
        cell.artistImageView.layer.cornerRadius =  cell.artistImageView.frame.size.width/2;
        cell.artistImageView.clipsToBounds = YES;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1){
        return self.topTracksArray.count;
    }
    if (section == 2){
        return self.relatedArtistsArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Top Tracks";
    }
    if (section == 2) {
        return @"Related Artists";
    }
    return @"";
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    if (indexPath.section == 1) { // top tracks -- segue to track details View controller
        NSDictionary *trackDict = self.topTracksArray[indexPath.row];
        Track *track = [[Track alloc] initWithDictionary:trackDict];
        TrackDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.accessToken = self.accessToken;
        detailsVC.track = track;
    } else if (indexPath.section == 2) { // related artists -- segue to new artist details view controller
        Artist *artist = [[Artist alloc] initWithDictionary:self.relatedArtistsArray[indexPath.row]];
        ArtistDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.accessToken = self.accessToken;
        detailsVC.artist = artist;
    }
}









@end
