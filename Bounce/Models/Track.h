//
//  Track.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSObject
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *artists;
@property (nonatomic) Album *album;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
