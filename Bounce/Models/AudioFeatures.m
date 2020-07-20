//
//  AudioFeatures.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "AudioFeatures.h"

@implementation AudioFeatures
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    NSDictionary *keys = @{@1: @"C", @2: @"D♭", @3: @"D", @4: @"E♭", @5: @"E", @6: @"F", @7: @"G", @8: @"A♭", @9: @"A", @10: @"B♭",  @11: @"B"};
    NSDictionary *modes = @{@0: @"Minor", @1: @"Major"};
    NSNumber *multiplier = [NSNumber numberWithInt:100];
    self.id = dictionary[@"id"];
    self.acousticness = dictionary[@"acousticness"] ;
    self.danceability = dictionary[@"danceability"];
    self.energy = dictionary[@"energy"];
    self.instrumentalness = dictionary[@"instrumentalness"];
    self.key = keys[dictionary[@"key"]];
    self.liveness = dictionary[@"liveness"];
    self.loudness = dictionary[@"loudness"];
    self.mode = modes[dictionary[@"mode"]];
    self.speechiness = dictionary[@"speechiness"];
    self.tempo = dictionary[@"tempo"];
    self.valence = dictionary[@"valence"];
    self.timeSig = dictionary[@"timeSig"];
    
    return self;
}
@end
