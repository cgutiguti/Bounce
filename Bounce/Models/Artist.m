//
//  Artist.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "Artist.h"

@implementation Artist
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.id = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.type = @"artist";
    NSDictionary *images = dictionary[@"images"];
    if (images.count != 0){
        self.image = [[Image alloc] initWithDictionary:dictionary[@"images"][0]];
    }
    self.genres = dictionary[@"genres"];
    self.popularity = dictionary[@"popularity"];
    return self;
}
@end
