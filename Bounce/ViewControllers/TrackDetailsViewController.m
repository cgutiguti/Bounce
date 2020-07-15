//
//  TrackDetailsViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/15/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "TrackDetailsViewController.h"

@interface TrackDetailsViewController ()
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
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;

@end

@implementation TrackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.keyLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *keyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyClicked)];
    [self.keyLabel addGestureRecognizer:keyGesture];
    
    [self.timeSigLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *timeSigGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeSigClicked)];
    [self.keyLabel addGestureRecognizer:timeSigGesture];
    
    [self.tempoLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tempoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tempoClicked)];
    [self.keyLabel addGestureRecognizer:tempoGesture];
    
    [self.loudnessLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *loudnessGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loudnessClicked)];
    [self.keyLabel addGestureRecognizer:loudnessGesture];
    
    [self.valenceLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *valenceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(valenceClicked)];
    [self.keyLabel addGestureRecognizer:valenceGesture];
    
    [self.acousticLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *acousticGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acousticClicked)];
    [self.keyLabel addGestureRecognizer:acousticGesture];
    
    [self.danceLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *danceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(danceClicked)];
    [self.keyLabel addGestureRecognizer:danceGesture];
    
    [self.energyLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *energyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(energyClicked)];
    [self.keyLabel addGestureRecognizer:energyGesture];
}

- (void) keyClicked{
    [self presentAlertControllerWithTitle:@"Musical Key"
                                  message:@""
                              buttonTitle:@"Close"];
    
}
- (void) timeSigClicked {
    [self presentAlertControllerWithTitle:@"Time Signature"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) tempoClicked {
    [self presentAlertControllerWithTitle:@"Tempo"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) loudnessClicked {
    [self presentAlertControllerWithTitle:@"Loudness"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) valenceClicked{
    [self presentAlertControllerWithTitle:@"Valence"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) acousticClicked{
    [self presentAlertControllerWithTitle:@"Acousticness"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) danceClicked{
    [self presentAlertControllerWithTitle:@"Danceability"
                                  message:@""
                              buttonTitle:@"Close"];
}
- (void) energyClicked{
    [self presentAlertControllerWithTitle:@"Energy"
                                  message:@""
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
