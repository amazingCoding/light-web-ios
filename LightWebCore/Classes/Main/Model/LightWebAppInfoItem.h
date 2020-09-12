//
//  LightWebAppInfoItem.h
//  LightWebCore
//
//  Created by 宋航 on 2020/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebAppInfoItem : NSObject
@property (nonatomic,strong)NSString *phoneName;
@property (nonatomic,strong)NSString *system;
@property (nonatomic,strong)NSString *systemVersion;

@property (nonatomic,assign)int screenWidth;
@property (nonatomic,assign)int screenHeight;
@property (nonatomic,assign)int webWidth;
@property (nonatomic,assign)int webHeight;
@property (nonatomic,assign)int statusBarHeight;

@property (nonatomic,assign)CGRect capsuleRect;

@property (nonatomic,assign)int currentTheme;
@property (nonatomic,assign)int maxRouters;
@property (nonatomic,assign)int currentPos;
-(NSDictionary *)getInitMsg:(nullable NSString *)extra;
-(NSDictionary *)getPageMsg;
@end

NS_ASSUME_NONNULL_END
