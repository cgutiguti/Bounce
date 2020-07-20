//
//  SearchViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "SearchViewController.h"
#import "TrackCell.h"
#import "AppDelegate.h"
#import "SpotifyManager.h"
#import "Track.h"
#import "UIImageView+AFNetworking.h"
#import "TrackDetailsViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *resultsArray;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.showsSearchResultsButton = YES;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Do the search...
    if (self.searchBar.searchTextField.text.length != 0) {
        NSLog([@"Authorization Token: " stringByAppendingString:self.accessToken]);
        
         // fetch data with predicate from spotify api
        //[self doSearchUsingHTTPDefault];
        [self doSearchUsingManager];
    }
    
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)doSearchUsingManager {
    [[SpotifyManager shared] searchForSong:self.searchBar.searchTextField.text accessToken:self.accessToken completion:^(NSDictionary * _Nonnull array, NSError * _Nonnull error) {
        self.resultsArray = array[@"tracks"][@"items"];
//        self.resultsArray = [[NSMutableArray alloc] init];
//        self.resultsArray = [NSJSONSerialization JSONObjectWithData:array options:NSJSONReadingMutableContainers error:nil];
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TrackCell"];
    // *track = self.resultsArray[indexPath.row];
    Track *track = [[Track alloc] initWithDictionary:self.resultsArray[indexPath.row]];
    cell.trackArtistLabel.text = track.artists[0][@"name"];
    cell.trackTitleLabel.text = track.name;
    cell.track = track;
    NSURL *url = [NSURL URLWithString:track.album.image.url];
    [cell.albumArtView setImageWithURL:url];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrackCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Track *track = [[Track alloc] initWithDictionary:self.resultsArray[indexPath.row]];
    TrackDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.accessToken = self.accessToken;
    detailsVC.track = track;
    

}



@end
