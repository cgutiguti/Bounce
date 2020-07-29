//
//  TrackDetailsViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/15/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//
@import AlertTransition;
//view controllers
#import "TrackDetailsViewController.h"
#import "ViewController.h"
//models
#import "AudioFeatures.h"
#import "Track.h"
//outside functions
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "SpotifyManager.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "AAChartKit.h"
//album rotation animation parameters
#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@interface TrackDetailsViewController ()
//storyboard outlets
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSigLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;
@property (weak, nonatomic) IBOutlet UILabel *loudnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *valenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *acousticLabel;
@property (weak, nonatomic) IBOutlet UILabel *danceLabel;
@property (weak, nonatomic) IBOutlet UIView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recordPlayerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//data
@property (strong, nonatomic) AudioFeatures *audioFeatures;
//personal state booleans
@property BOOL albumViewIsRotating;
@end

@implementation TrackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set up play button for playing song.
//    [self.delegate.appRemote connect];
//    [self.delegate.appRemote isConnected];
    UITapGestureRecognizer *playSongGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonClicked)];
    [self.playButton addGestureRecognizer:playSongGesture];
    UIColor *color = [UIColor colorWithRed:(29.0 / 255.0) green:(185.0 / 255.0) blue:(84.0 / 255.0) alpha:1.0];
    self.playButton.backgroundColor = color;
    self.playButton.layer.cornerRadius = self.playButton.frame.size.width/2;
    self.playButton.clipsToBounds = YES;
    //For each audio feature, make tapping on it bring up informational panel describing the feature.
    NSArray<UILabel *> *labelsArray = @[self.keyLabel, self.timeSigLabel, self.tempoLabel, self.loudnessLabel, self.valenceLabel, self.acousticLabel, self.danceLabel, self.energyLabel];
    SEL selectorArray[] = {@selector(keyClicked), @selector(timeSigClicked), @selector(tempoClicked), @selector(loudnessClicked), @selector(valenceClicked), @selector(acousticClicked), @selector(danceClicked), @selector(energyClicked)};
    for (int i = 0; i < labelsArray.count; i ++) {
        UILabel *label = labelsArray[i];
        SEL selector = selectorArray[i];
        [label setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
        [label addGestureRecognizer:gesture];
    }
    // Record Player View is the circle in the middle of the album that appears when the "record" is playing.
    self.recordPlayerView.hidden = YES;
    self.recordPlayerView.layer.cornerRadius = self.recordPlayerView.frame.size.width/2;
    self.recordPlayerView.clipsToBounds = YES;
    // Set up audio features data from request
    [[SpotifyManager shared] getAudioFeaturesForTrack:self.track.id accessToken:self.accessToken completion:^(NSDictionary * song, NSError * error) {
        AudioFeatures *audioFeatures = [[AudioFeatures alloc] initWithDictionary:song];
        self.audioFeatures = audioFeatures;
        self.acousticLabel.text = [NSString stringWithFormat:@"%@", audioFeatures.acousticness];
        self.danceLabel.text = [NSString stringWithFormat:@"%@",audioFeatures.danceability];
        self.energyLabel.text = [NSString stringWithFormat:@"%@",audioFeatures.energy];
        self.keyLabel.text = [[NSString stringWithFormat:@"%@ ",audioFeatures.key] stringByAppendingString:audioFeatures.mode];
        self.loudnessLabel.text = [NSString stringWithFormat:@"%@",audioFeatures.loudness];
        self.tempoLabel.text = [NSString stringWithFormat:@"%@",audioFeatures.tempo];
        self.valenceLabel.text = [NSString stringWithFormat:@"%@",audioFeatures.valence];
        self.timeSigLabel.text = [NSString stringWithFormat:@"%@/4", audioFeatures.timeSig];
        NSString *artistsList = @"";
        for (NSDictionary *artist in self.track.artists) {
            if(artistsList.length == 0) {
                artistsList = [artistsList stringByAppendingFormat:@"%@", artist[@"name"]];
            } else {
                artistsList = [artistsList stringByAppendingFormat:@", %@", artist[@"name"]];
            }
        }
        self.artistNameLabel.text = artistsList;
        self.songNameLabel.text = self.track.name;
        // Make album view have rounded edges
        NSURL *url = [NSURL URLWithString:self.track.album.image.url];
        [self.albumView setImageWithURL:url];
        self.albumView.layer.cornerRadius = 10;
        self.albumView.clipsToBounds = YES;
        [self formatAAChart];
    }];
    
}

- (void) formatAAChart {
    CGFloat chartViewWidth  = self.view.frame.size.width;
    CGFloat chartViewHeight = 433;
    AAChartView *aaChartView = [[AAChartView alloc] init];
    aaChartView.frame = CGRectMake(0, 313, chartViewWidth, chartViewHeight);
    //_aaChartView.scrollEnabled = NO;
    //// set the content height of aaChartView
    // _aaChartView.contentHeight = chartViewHeight;
    [self.scrollView addSubview:aaChartView];
    [self.scrollView sendSubviewToBack:aaChartView];
    AASeriesElement *element1 = AASeriesElement.new
    .dataSet(@[@([self.audioFeatures.energy doubleValue]/100.0),
               @([self.audioFeatures.valence doubleValue]/100.0),
               @([self.audioFeatures.acousticness intValue]/100.0),
               @([self.audioFeatures.danceability doubleValue]/100.0),
               @(pow(2, [self.audioFeatures.loudness doubleValue]/6.0)),
             @([self.audioFeatures.tempo doubleValue]/150),
             @(1),
               @(1), @(1)])
    .stepSet(@true);
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeArea)
    .seriesSet(@[element1]);
    aaChartModel.yAxisMax = @(1.0);
    aaChartModel.inverted = YES;
    aaChartModel.markerRadius = @0;
    aaChartModel.legendEnabled = NO;
    aaChartModel.xAxisVisible = NO;
    aaChartModel.yAxisVisible = NO;
    aaChartModel.tooltipEnabled = NO;
    //aaChartModel.colorsTheme = @[@"#ffc069",@"#06caf4",@"#7dffc0"];
    aaChartModel.animationDuration = @(1200);
    aaChartView.alpha = 0.3;
    aaChartModel.dataLabelsEnabled = NO;
    aaChartModel.borderRadius = 0;
    aaChartModel.animationType = AAChartAnimationEaseOutCubic;

    aaChartModel.seriesSet(@[element1]);
    aaChartView.userInteractionEnabled = NO;
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
}

- (void) playButtonClicked {
//    self.appRemote = [ViewController shared].appRemote;
//    self.appRemote.connectionParameters.accessToken = self.accessToken;
//    [self.appRemote connect];
    NSString *songURI = [@"spotify:track:" stringByAppendingString:self.track.id];
    NSLog(@"Song URI: %@", songURI);
    [self playSong:songURI];
}

- (void) playSong:(NSString *)songURI {
//    self.appRemote.connectionParameters.accessToken = self.accessToken;
//    [self.appRemote connect];
//    [self.appRemote.playerAPI play:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
//            NSLog(@"Playing song.");
//       }];
    if (self.albumViewIsRotating){
        self.albumViewIsRotating = NO;
        [self.playButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
        [self continueRotationAnimation];
    } else {
        self.albumView.clipsToBounds = YES;
        self.albumViewIsRotating = YES;
        self.recordPlayerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.recordPlayerView.hidden = NO;
        [self.playButton setImage:[UIImage systemImageNamed:@"pause.fill"] forState:UIControlStateNormal];
        [self performRotationAnimated];
    }
}

- (void)performRotationAnimated {
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                         self.albumView.transform = CGAffineTransformMakeRotation(M_PI);
                         self.albumView.layer.cornerRadius =  self.albumView.frame.size.width/2;
            self.recordPlayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         
                     }
                     completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                              self.albumView.transform = CGAffineTransformMakeRotation(0);
                                          }
                                          completion:^(BOOL finished){
            [self continueRotationAnimation];
                        }];
            }];
}

- (void)continueRotationAnimation {
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                         self.albumView.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
            if (self.albumViewIsRotating) {
                [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                      self.albumView.transform = CGAffineTransformMakeRotation(0);
                                  }
                                  completion:^(BOOL finished){
                    [self continueRotationAnimation];
                }];
            } else {
                [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                      self.albumView.transform = CGAffineTransformMakeRotation(0);
                                      self.albumView.layer.cornerRadius =  10;
                    self.recordPlayerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                                  }
                                  completion:^(BOOL finished){
                    [self.albumView stopAnimating];
                    self.recordPlayerView.hidden = YES;
                }];
            }
            }];
}


- (void) keyClicked{
    [self presentAlertControllerWithTitle:@"Musical Key"
                                  message:@"The key the track is in. Integers map to pitches using standard Pitch Class notation. E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on."
                              buttonTitle:@"Close"];
    
}
- (void) timeSigClicked {
    [self presentAlertControllerWithTitle:@"Time Signature"
                                  message:@"An estimated overall time signature of a track. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure)."
                              buttonTitle:@"Close"];
}
- (void) tempoClicked {
    [self presentAlertControllerWithTitle:@"Tempo"
                                  message:@"The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration."
                              buttonTitle:@"Close"];
}
- (void) loudnessClicked {
    [self presentAlertControllerWithTitle:@"Loudness"
                                  message:@"The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typical range between -60 and 0 db."
                              buttonTitle:@"Close"];
}
- (void) valenceClicked{
    [self presentAlertControllerWithTitle:@"Valence"
                                  message:@"A measure from 0 to 100 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry)."
                              buttonTitle:@"Close"];
}
- (void) acousticClicked{
    [self presentAlertControllerWithTitle:@"Acousticness"
                                  message:@"A confidence measure from 0 to 100 of whether the track is acoustic. 100 represents high confidence the track is acoustic."
                              buttonTitle:@"Close"];
}
- (void) danceClicked{
    [self presentAlertControllerWithTitle:@"Danceability"
                                  message:@"Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 00 is least danceable and 100 is most danceable."
                              buttonTitle:@"Close"];
}
- (void) energyClicked{
    [self presentAlertControllerWithTitle:@"Energy"
                                  message:@"Energy is a measure from 0 to 100 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy."
                              buttonTitle:@"Close"];
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
