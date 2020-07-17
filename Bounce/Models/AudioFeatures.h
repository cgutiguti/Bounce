//
//  AudioFeatures.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioFeatures : NSObject
@property (nonatomic) NSString *id;
@property (nonatomic) Float64 *acousticness;
@property (nonatomic) Float64 *energy;
@property (nonatomic) Float64 *danceability;
@property (nonatomic) Float64 *loudness;
@property (nonatomic) Float64 *liveness;
@property (nonatomic) Float64 *instrumentalness;
@property (nonatomic) Float64 *speechiness;
@property (nonatomic) Float64 *valence;
@property (nonatomic) Float64 *tempo;
@property (nonatomic) NSInteger *key;
@property (nonatomic) NSInteger *mode;
@property (nonatomic) NSInteger *timeSig;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
