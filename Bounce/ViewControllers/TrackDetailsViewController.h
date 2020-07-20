//
//  TrackDetailsViewController.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/15/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) Track *track;
@end

NS_ASSUME_NONNULL_END
