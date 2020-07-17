//
//  Playlist.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Playlist : NSObject
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *images;
@property (nonatomic) User *owner;
@property (nonatomic) NSArray *tracks;
@property (nonatomic) Boolean *public;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
