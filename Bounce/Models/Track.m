//
//  Track.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//
#import "Album.h"
#import "Track.h"

@implementation Track
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.type = @"track";
    self.id = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.album = [[Album alloc] initWithDictionary:dictionary[@"album"]];
    self.artists = dictionary[@"artists"];
    return self;
    
}
@end
