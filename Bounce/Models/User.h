//
//  User.h
//  Bounce
//
//  Created by Carmen Gutierrez on 7/17/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *display_name;
@property (nonatomic) NSArray *images;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
