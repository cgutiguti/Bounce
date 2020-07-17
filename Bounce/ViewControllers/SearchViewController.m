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
        NSLog(@"Authorization Token: ", self.accessToken);
         // fetch data with predicate from spotify api
        NSDictionary *keys = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.searchBar.searchTextField.text, @"q", nil];
        NSError *error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:keys options:kNilOptions error:&error];
        NSURLResponse *response;
        NSData *localData = nil;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.spotify.com/v1/search"]];
        [request setHTTPMethod:@"GET"];

        if (error == nil)
        {
            [request setHTTPBody:jsonData];
            [request setValue:[[NSUserDefaults standardUserDefaults]valueForKey:self.accessToken] forHTTPHeaderField:@"Authorization"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

            // Send the request and get the response
            localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

            NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
            NSLog(@"Search results : %@", result);
        }
    }
    
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TrackCell"];
    // *track = self.resultsArray[indexPath.row];
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsArray.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
