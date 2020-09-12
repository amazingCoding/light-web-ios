//
//  LightWebRouterSystem.h
//  LightWebCore
//
//  Created by 宋航 on 2020/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
    push=0,
    pop,
    replace,
    setPopExtra,
    restart
} LightWebRouterType;
@interface LightWebRouterSystem : NSObject
@property (nonatomic,assign) LightWebRouterType action;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *extra;
@property (nonatomic,assign) int pos;
-(instancetype)initWith:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
