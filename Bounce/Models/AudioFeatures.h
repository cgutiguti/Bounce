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
@property (nonatomic) NSString *acousticness;
@property (nonatomic) NSString *energy;
@property (nonatomic) NSString *danceability;
@property (nonatomic) NSString *loudness;
@property (nonatomic) NSString *liveness;
@property (nonatomic) NSString *instrumentalness;
@property (nonatomic) NSString *speechiness;
@property (nonatomic) NSString *valence;
@property (nonatomic) NSString *tempo;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *mode;
@property (nonatomic) NSString *timeSig;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
