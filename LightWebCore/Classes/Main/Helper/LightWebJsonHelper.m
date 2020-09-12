//
//  LightWebJsonHelper.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebJsonHelper.h"

@implementation LightWebJsonHelper
+(BOOL)getBoolByName:(NSString *)name and:(NSDictionary *)dict adnDef:(BOOL)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [dict[name] intValue] != 0; }
}
+(NSString *)getStringByName:(NSString *)name and:(NSDictionary *)dict adnDef:(NSString *)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [NSString stringWithFormat:@"%@",dict[name]]; }
}
+(int)getIntByName:(NSString *)name and:(NSDictionary *)dict adnDef:(int)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [dict[name] intValue]; }
}
@end
