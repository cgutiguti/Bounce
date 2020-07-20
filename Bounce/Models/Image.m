//
//  Image.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "Image.h"

@implementation Image
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

//    self.height = dictionary[@"height"];
//    self.width = dictionary[@"width"];
    self.url = dictionary[@"url"];
    return self;
}
@end
