//
//  Album.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "Album.h"

@implementation Album
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.type = @"album";
    self.artists = dictionary[@"artists"];
    self.name = dictionary[@"name"];
    self.image = [[Image alloc] initWithDictionary:dictionary[@"images"][0]];
    self.id = dictionary[@"id"];
    return self;
}
@end
