//
//  LightWebLoadHelper.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebLoadHelper : NSObject
-(void)startLoadWithUrl:(NSString *)url andMustLoad:(BOOL)mustLoad ProgressBlock:(nullable void (^)(CGFloat progress))ProgressBlock SuccessHandler:(nullable void (^)(NSString * _Nullable rootDir))successHandler ErrorHandler:(nullable void (^)(NSError * _Nullable error))errorHandler;
-(void)stopLoad;
@end

NS_ASSUME_NONNULL_END
