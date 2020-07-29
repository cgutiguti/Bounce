//
//  AffinitiesViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/23/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

//outside functions
#import "AffinitiesViewController.h"
#import "SpotifyManager.h"
#import "AAChartKit.h"
//models
#import "Track.h"
#import "Artist.h"

@interface AffinitiesViewController ()
//data
@property (nonatomic, strong) NSMutableArray *dataSet;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property int numBatchesCompleted;
@property int numBatchesExpected;


@end

@implementation AffinitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistsData = [[NSMutableArray alloc] init];
    self.genresData = [[NSMutableArray alloc] init];
    self.dataSet =[[NSMutableArray alloc] init];
    self.dataDictionary = [[NSMutableDictionary alloc] init];
    self.numBatchesCompleted = 0;
  
    self.tracksData = [self.tracksData subarrayWithRange:NSMakeRange(30, 30)];
    [self getArtistsFromTracks];
    [self batchArtists];
//    [self createDataDict];
    
}

- (void)getArtistsFromTracks {
    for (NSDictionary *track in self.tracksData) {
        NSString *artistID = track[@"track"][@"artists"][0][@"id"];
        [self.artistsData addObject:artistID];
    }
}

- (void)batchArtists {
    int i = 0;
    int range = 25;
    self.numBatchesExpected = self.artistsData.count/range;
    while (i + range < self.artistsData.count) {
        NSArray<NSString *> *artistBatch = [self.artistsData subarrayWithRange:NSMakeRange(i, range)];
        [self fetchBatchedArtists:artistBatch];
        i += range;
    }
}

- (void)fetchBatchedArtists:(NSArray<NSString *> *)artistBatch {
    NSString *artistIDList = @"";
    for (NSString *artistID in artistBatch) {
        artistIDList = [[artistIDList stringByAppendingString:@","] stringByAppendingString:artistID];
    }
    [[SpotifyManager shared] getSeveralArtists:[artistIDList substringFromIndex:1] accessToken:self.accessToken completion:^(NSDictionary * artistArray, NSError * error) {
        if (artistArray) {
            for (NSDictionary *artist in artistArray[@"artists"]) {
                NSArray *genres = artist[@"genres"];
                [self.genresData addObjectsFromArray:genres];
                for (NSString *genre in genres) {
                    if ([self.dataDictionary objectForKey:genre] == nil) { //if there isn't yet a key, create a key with value 1.
                        [self.dataDictionary setValue:@1 forKey:genre];
                    } else { // if there is already a key, add 1 to its value.
                        int value = [[self.dataDictionary valueForKey:genre] intValue];;
                        [self.dataDictionary setValue:@(value+1) forKey:genre];
                    }
                }
            }
            self.numBatchesCompleted ++;
            [self createDataDict];
        }
    }];
}

- (void)createDataDict {
    if (self.numBatchesCompleted == self.numBatchesExpected){
        //create an array out of the dictionary
        NSArray *keys = [self.dataDictionary allKeys];
        for (NSString *key in keys) {
            [self.dataSet addObject:@[key, [self.dataDictionary objectForKey:key]]];
        }
        [self setUpChartView];
    }
}

- (void)setUpChartView {
    AASeriesElement *element = AASeriesElement.new
    .nameSet(@"Number of Tracks")
    .innerSizeSet(@"0%")
    .sizeSet(@200)
    .borderWidthSet(@0)
    .allowPointSelectSet(true)
    .statesSet(AAStates.new
               .hoverSet(AAHover.new
                         .enabledSet(false)
                         ))
    .dataSet(self.dataSet);
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .colorsThemeSet(@[@"#0c9674",@"#7dffc0",@"#ff3333",@"#facd32",@"#ffffa0",@"#EA007B"])
    .dataLabelsEnabledSet(true)
    .yAxisTitleSet(@"Title")
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
