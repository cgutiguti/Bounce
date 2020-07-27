//
//  AffinitiesViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/23/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "AffinitiesViewController.h"
#import "SpotifyManager.h"
#import "AAChartKit.h"
#import "Track.h"
#import "Artist.h"

@interface AffinitiesViewController ()
@property (nonatomic, strong) NSMutableArray *tracksData;
@property (nonatomic, strong) NSMutableArray *genresData;
@property (nonatomic, strong) NSMutableArray *artistsData;
@end

@implementation AffinitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPlaylistData];
}

- (void)fetchPlaylistData {
    [[SpotifyManager shared] getPersonalPlayLists:self.accessToken completion:^(NSDictionary * dictionary, NSError * error) {
        NSArray *data = dictionary[@"items"];
        for (NSDictionary *playlist in data) {
            NSString *href = [playlist[@"tracks"][@"href"] substringFromIndex:23];
            [[SpotifyManager shared] doGetRequest:href accessToken:self.accessToken completion:^(NSDictionary * trackList, NSError * error) {
                for (NSDictionary *trackData in trackList[@"items"]){
                    Track *track = [[Track alloc] initWithDictionary:trackData[@"track"]];
                    [self.tracksData addObject:track];
                }
                [self fetchGenresFromTracks];
            }];
        }
    }];
}

- (void)fetchGenresFromTracks {
    /* Spotify API GET several artists endpoint accepts a maximum of 50 ids.
       Below, we batch the ids from self.artistsData in groups of 50 and send requests.
       From the request response, add artist objects to self.artistsData. */
    NSString *artistIDs = @"";
    int i = 0;
    while (i < self.tracksData.count) {
        //if we have reached request maximum (50), then send the request and reset the request string of IDs to an empty string.
        if (i % 50 == 0) {
            //do request
            [[SpotifyManager shared] getSeveralArtists:artistIDs accessToken:self.accessToken completion:^(NSDictionary * artistArray, NSError * error) {
                for (NSDictionary *artistDict in artistArray){
                    Artist *artist = [[Artist alloc] initWithDictionary:artistDict];
                    [self.artistsData addObject:artist];
                }
            }];
            //make request string empty again
            artistIDs = @"";
        }
        //add another id to the end of request string
        Track *track = self.tracksData[i];
        NSDictionary *artistFromTrack = track.artists[0];
        //IDs are in the form of a comma separated list
        artistIDs = [[artistIDs stringByAppendingString:@","] stringByAppendingString:artistFromTrack[@"id"]]; //IDs are in the form of a comma separated list
        i++; //increment count.
    }
    //After we have reached the end of self.tracksData, make one last request for remaining artists if we have not already
    [[SpotifyManager shared] getSeveralArtists:artistIDs accessToken:self.accessToken completion:^(NSDictionary * artistArray, NSError * error) {
        for (NSDictionary *artistDict in artistArray){
            Artist *artist = [[Artist alloc] initWithDictionary:artistDict];
            [self.artistsData addObject:artist];
        }
    }];
    //For each artist object in self.artistsData, add all genres from artist.genres array to self.genresData.
    for (Artist *artist in self.artistsData) {
        for (NSString *genre in artist.genres) {
            [self.genresData addObject:genre];
        }
    }
    NSLog(@"Finished gathering and sorting data.");
}

- (void)setUpChartView {
    AASeriesElement *element = AASeriesElement.new
    .nameSet(@"语言热度值")
    .innerSizeSet(@"20%")//内部圆环半径大小占比
    .sizeSet(@200)//尺寸大小
    .borderWidthSet(@0)//描边的宽度
    .allowPointSelectSet(true)//是否允许在点击数据点标记(扇形图点击选中的块发生位移)
    .statesSet(AAStates.new
               .hoverSet(AAHover.new
                         .enabledSet(false)//禁用点击区块之后出现的半透明遮罩层
                         ))
    .dataSet(@[
        @[@"Firefox",   @3336.2],
        @[@"IE",          @26.8],
        @{@"sliced": @true,
          @"selected": @true,
          @"name": @"Chrome",
          @"y": @666.8,        },
        @[@"Safari",      @88.5],
        @[@"Opera",       @46.0],
        @[@"Others",     @223.0],
    ]);
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .colorsThemeSet(@[@"#0c9674",@"#7dffc0",@"#ff3333",@"#facd32",@"#ffffa0",@"#EA007B"])
    .dataLabelsEnabledSet(true)//是否直接显示扇形图数据
    .yAxisTitleSet(@"摄氏度")
    .seriesSet(@[element]);

    // Do any additional setup after loading the view.
    CGFloat chartViewWidth  = self.view.frame.size.width;
    CGFloat chartViewHeight = self.view.frame.size.height-250;
    AAChartView *aaChartView = [[AAChartView alloc] init];
    aaChartView.frame = CGRectMake(0, 60, chartViewWidth, chartViewHeight);
    //_aaChartView.scrollEnabled = NO;
    //// set the content height of aaChartView
    // _aaChartView.contentHeight = chartViewHeight;
    [self.view addSubview:aaChartView];
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
