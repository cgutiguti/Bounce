//
//  Image.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject
@property (nonatomic) NSInteger *height;
@property (nonatomic) NSInteger *width;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *type;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
