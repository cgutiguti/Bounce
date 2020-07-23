//
//  Artist.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//
#import "Image.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Artist : NSObject
@property (nonatomic) Image *image;
@property (nonatomic) NSArray *genres;
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *popularity;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
