//
//  JavaScriptMethod.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebJavaScriptMethod.h"
static NSString* const METHO_PREFIX = @"lightWeb_";
@implementation LightWebJavaScriptMethod
+(NSArray *)getJavaScriptMethods{
    NSArray *javaScriptMethods = @[
        @"lightWeb_init",
        @"lightWeb_page_config",
        @"lightWeb_router_config",
        @"lightWeb_vibrate",
        @"lightWeb_set_clipboard",
        @"lightWeb_get_clipboard",
    ];
    return javaScriptMethods;
}
+(int)getMethodPos:(NSString *)method{
    NSArray *methods = [LightWebJavaScriptMethod getJavaScriptMethods];
    int pos = -1;
    for (int i = 0; i < methods.count; i++) {
        if([methods[i] isEqual:method]){
            pos = i;
            break;
        }
    }
    return pos;
}
+(NSString *)active{
    return [NSString stringWithFormat:@"%@appActive",METHO_PREFIX];
}
+(NSString *)backGround{
    return [NSString stringWithFormat:@"%@appBackGround",METHO_PREFIX];
}
+(NSString *)viewShow{
    return [NSString stringWithFormat:@"%@viewShow",METHO_PREFIX];
}
+(NSString *)viewHide{
    return [NSString stringWithFormat:@"%@viewHide",METHO_PREFIX];
}
+(NSString *)sceneMode{
    return [NSString stringWithFormat:@"%@sceneMode",METHO_PREFIX];
}

@end
