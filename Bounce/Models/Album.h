//
//  Album.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album : NSObject
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger *popularity;
@property (nonatomic) Image *image;
@property (nonatomic) NSArray *genres;
@property (nonatomic) NSArray *artists;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
