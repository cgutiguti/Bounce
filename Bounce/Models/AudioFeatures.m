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
    NSDictionary *keys = @{@-1: @"", @1: @"C", @2: @"D♭", @3: @"D", @4: @"E♭", @5: @"E", @6: @"F", @7: @"G", @8: @"A♭", @9: @"A", @10: @"B♭",  @11: @"B"};
    NSDictionary *modes = @{@0: @"Minor", @1: @"Major"};
    self.id = dictionary[@"id"];
    self.acousticness = [NSString stringWithFormat:@"%d", (int)([dictionary[@"acousticness"] doubleValue]*100)];
    self.danceability = [NSString stringWithFormat:@"%d", (int)([dictionary[@"danceability"] doubleValue]*100)];
    self.energy = [NSString stringWithFormat:@"%d", (int)([dictionary[@"energy"] doubleValue]*100)];
    self.instrumentalness = [NSString stringWithFormat:@"%d", (int)([dictionary[@"instrumentalness"] doubleValue]*100)];
    self.key = keys[dictionary[@"key"]];
    self.liveness = [NSString stringWithFormat:@"%d", (int)([dictionary[@"liveness"] doubleValue]*100)];
    self.loudness = [NSString stringWithFormat:@"%d", (int)[dictionary[@"loudness"] doubleValue]];
    self.mode = modes[dictionary[@"mode"]];
    self.speechiness = [NSString stringWithFormat:@"%d", (int)([dictionary[@"speechiness"] doubleValue]*100)];
    self.tempo = [NSString stringWithFormat:@"%d", (int)[dictionary[@"tempo"] doubleValue]];
    self.valence = [NSString stringWithFormat:@"%d", (int)([dictionary[@"valence"] doubleValue]*100)];
    self.timeSig = dictionary[@"timeSig"];
    
    return self;
}
@end
