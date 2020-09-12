//
//  LightWebAppInfoItem.m
//  LightWebCore
//
//  Created by 宋航 on 2020/9/1.
//

#import "LightWebAppInfoItem.h"
#include <sys/utsname.h>

@implementation LightWebAppInfoItem

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}
-(void)setUpData{
    struct utsname systemInfo;
    uname(&systemInfo); // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = @{
                           // iPhone
                           @"iPhone5,3" : @"iPhone 5c",
                           @"iPhone5,4" : @"iPhone 5c",
                           @"iPhone6,1" : @"iPhone 5s",
                           @"iPhone6,2" : @"iPhone 5s",
                           @"iPhone7,1" : @"iPhone 6 Plus",
                           @"iPhone7,2" : @"iPhone 6",
                           @"iPhone8,1" : @"iPhone 6s",
                           @"iPhone8,2" : @"iPhone 6s Plus",
                           @"iPhone8,4" : @"iPhone SE",
                           @"iPhone9,1" : @"iPhone 7",
                           @"iPhone9,2" : @"iPhone 7 Plus",
                           @"iPhone10,1" : @"iPhone 8",
                           @"iPhone10,4" : @"iPhone 8",
                           @"iPhone10,2" : @"iPhone 8 Plus",
                           @"iPhone10,5" : @"iPhone 8 Plus",
                           @"iPhone10,3" : @"iPhone X",
                           @"iPhone10,6" : @"iPhone X",
                           @"iPhone11,2" : @"iPhone XS",
                           @"iPhone11,4" : @"iPhone XS Max",
                           @"iPhone11,6" : @"iPhone XS Max",
                           @"iPhone11,8" : @"iPhone XR",
                           @"iPhone12,1" : @"iPhone 11",
                           @"iPhone12,3" : @"iPhone 11 Pro",
                           @"iPhone12,5" : @"iPhone 11 Pro Max",
                           @"i386" : @"iPhone Simulator",
                           @"x86_64" : @"iPhone Simulator",
                           // iPad
                           @"iPad4,1" : @"iPad Air",
                           @"iPad4,2" : @"iPad Air",
                           @"iPad4,3" : @"iPad Air",
                           @"iPad5,3" : @"iPad Air 2",
                           @"iPad5,4" : @"iPad Air 2",
                           @"iPad6,7" : @"iPad Pro 12.9",
                           @"iPad6,8" : @"iPad Pro 12.9",
                           @"iPad6,3" : @"iPad Pro 9.7",
                           @"iPad6,4" : @"iPad Pro 9.7",
                           @"iPad6,11" : @"iPad 5",
                           @"iPad6,12" : @"iPad 5",
                           @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,3" : @"iPad Pro 10.5",
                           @"iPad7,4" : @"iPad Pro 10.5",
                           @"iPad7,5" : @"iPad 6",
                           @"iPad7,6" : @"iPad 6",
                           // iPad mini
                           @"iPad2,5" : @"iPad mini",
                           @"iPad2,6" : @"iPad mini",
                           @"iPad2,7" : @"iPad mini",
                           @"iPad4,4" : @"iPad mini 2",
                           @"iPad4,5" : @"iPad mini 2",
                           @"iPad4,6" : @"iPad mini 2",
                           @"iPad4,7" : @"iPad mini 3",
                           @"iPad4,8" : @"iPad mini 3",
                           @"iPad4,9" : @"iPad mini 3",
                           @"iPad5,1" : @"iPad mini 4",
                           @"iPad5,2" : @"iPad mini 4",
                           };
    
    NSString *name = dict[platform];
    _phoneName = name ? name : platform;
    _system = @"iOS";
    _systemVersion = [[UIDevice currentDevice] systemVersion];
    
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _webWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _statusBarHeight = _screenHeight >= 812 ? 44 : 20;
}
-(NSDictionary *)getInitMsg:(nullable NSString *)extra{
    NSDictionary *capsule = @{
        @"x":[NSNumber numberWithInt:_capsuleRect.origin.x],
        @"y":[NSNumber numberWithInt:_capsuleRect.origin.y],
        @"width":[NSNumber numberWithInt:_capsuleRect.size.width],
        @"height":[NSNumber numberWithInt:_capsuleRect.size.height],
    };
    
    NSDictionary *appInfo = @{
        @"phoneName":_phoneName,
        @"system":_system,
        @"systemVersion":_systemVersion,
        @"screenWidth":[NSNumber numberWithInt:_screenWidth],
        @"screenHeight":[NSNumber numberWithInt:_screenHeight],
        @"webWidth":[NSNumber numberWithInt:_webWidth],
        @"webHeight":[NSNumber numberWithInt:_webHeight],
        @"statusBarHeight":[NSNumber numberWithInt:_statusBarHeight],
        @"capsule":capsule
    };
    
    NSDictionary *routerInfo = @{
        @"maxRouters":[NSNumber numberWithInt:_maxRouters],
        @"currentPos":[NSNumber numberWithInt:_currentPos],
    };
    return @{
        @"appInfo":appInfo,
        @"routerInfo":routerInfo,
        @"extra":extra ? extra : [NSNull null],
        @"currentTheme":[NSNumber numberWithInt:_currentTheme],
    };
}
-(NSDictionary *)getPageMsg{
    return @{
        @"webWidth":[NSNumber numberWithInt:_webWidth],
        @"webHeight":[NSNumber numberWithInt:_webHeight],
        @"currentTheme":[NSNumber numberWithInt:_currentTheme],
    };
}
@end
