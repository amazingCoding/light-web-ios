//
//  LightWebPageConfig.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
    light = 0,
    dark,
    autoTheme,
} LightWebThemeTypes;
@interface LightWebPageConfig : NSObject
@property (nonatomic,assign) BOOL isHideNav;
@property (nonatomic,assign) LightWebThemeTypes statusStyle;
@property (nonatomic,assign) LightWebThemeTypes theme;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *titleColor;
@property (nonatomic,strong) NSString *navBackgroundColor;
@property (nonatomic,strong) NSString *backgroundColor;
@property (nonatomic,strong) NSString *global;
@property (nonatomic,assign) BOOL isBounces;
@property (nonatomic,assign) BOOL showCapsule;
@property (nonatomic,assign) BOOL needBack;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)updateDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
