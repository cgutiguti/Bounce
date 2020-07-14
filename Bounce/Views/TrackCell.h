//
//  TrackCell.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/13/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackCell : UITableViewCell
//@property (weak, nonatomic) SPTAppRemoteTrack *track;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtView;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistLabel;

@end

NS_ASSUME_NONNULL_END
