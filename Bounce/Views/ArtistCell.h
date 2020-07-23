//
//  ArtistCell.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/21/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArtistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) Artist *artist;
@end

NS_ASSUME_NONNULL_END
