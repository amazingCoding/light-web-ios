//
//  JavaScriptMethod.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebJavaScriptMethod : NSObject
+(NSArray *)getJavaScriptMethods;
+(int)getMethodPos:(NSString *)method;
+(NSString *)active;
+(NSString *)backGround;
+(NSString *)viewShow;
+(NSString *)viewHide;

+(NSString *)sceneMode;
@end

NS_ASSUME_NONNULL_END
