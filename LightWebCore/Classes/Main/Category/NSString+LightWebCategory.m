//
//  NSString+LightWebCategory.m
//  LightWebCore
//
//  Created by 宋航 on 2020/9/1.
//

#import "NSString+LightWebCategory.h"

@implementation NSString (LightWebCategory)
+ (NSString *)initWithDict:(NSDictionary *)dict{
    NSError *parseError = nil;
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
