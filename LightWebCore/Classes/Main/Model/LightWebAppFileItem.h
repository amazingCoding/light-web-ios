//
//  LightWebAppFileItem.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebAppFileItem : NSObject
@property(nonatomic,strong) NSString *downloadURL;
@property(nonatomic,strong) NSString *version;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
