//
//  LightWebRouterSystem.m
//  LightWebCore
//
//  Created by 宋航 on 2020/9/1.
//

#import "LightWebRouterSystem.h"
#import "LightWebJsonHelper.h"
#import "NSString+LightWebCategory.h"
@implementation LightWebRouterSystem
-(instancetype)initWith:(NSDictionary *)dict{
    self = [super init];
    self.action = [LightWebJsonHelper getIntByName:@"action" and:dict adnDef:0];
    self.name = [LightWebJsonHelper getStringByName:@"name" and:dict adnDef:@""];
    if([[dict allKeys] containsObject:@"extra"]){
        if([dict[@"extra"] isKindOfClass:[NSDictionary class]]){
            self.extra = [NSString initWithDict:dict[@"extra"]];
        }
        else{
            self.extra = [LightWebJsonHelper getStringByName:@"extra" and:dict adnDef:@""];
        }
    }
    self.pos = [LightWebJsonHelper getIntByName:@"pos" and:dict adnDef:-1];
    BOOL isToRoot = [LightWebJsonHelper getBoolByName:@"isToRoot" and:dict adnDef:NO];
    if (isToRoot) self.pos = 0;
    return self;
}
@end
