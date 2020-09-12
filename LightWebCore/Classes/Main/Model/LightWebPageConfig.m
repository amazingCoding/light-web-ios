//
//  LightWebPageConfig.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebPageConfig.h"
#import "LightWebJsonHelper.h"

@implementation LightWebPageConfig
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    self.isHideNav = [LightWebJsonHelper getBoolByName:@"isHideNav" and:dict adnDef:NO];
    self.statusStyle = [LightWebJsonHelper getIntByName:@"statusStyle" and:dict adnDef:0];
    self.theme = [LightWebJsonHelper getIntByName:@"theme" and:dict adnDef:2];
    
    self.title = [LightWebJsonHelper getStringByName:@"title" and:dict adnDef:@""];
    self.titleColor = [LightWebJsonHelper getStringByName:@"titleColor" and:dict adnDef:@"#000000"];
    self.navBackgroundColor = [LightWebJsonHelper getStringByName:@"navBackgroundColor" and:dict adnDef:@"#FFFFFF"];
    self.backgroundColor = [LightWebJsonHelper getStringByName:@"backgroundColor" and:dict adnDef:@"#F1F1F1"];
    
    self.global = [LightWebJsonHelper getStringByName:@"global" and:dict adnDef:@""];
    
    self.isBounces = [LightWebJsonHelper getBoolByName:@"bounces" and:dict adnDef:YES];
    self.showCapsule = [LightWebJsonHelper getBoolByName:@"showCapsule" and:dict adnDef:YES];
    return self;
}
-(void)updateDict:(NSDictionary *)dict{
    NSArray *allKeys = [dict allKeys];
    if([allKeys containsObject:@"isHideNav"]) self.isHideNav = [LightWebJsonHelper getBoolByName:@"isHideNav" and:dict adnDef:NO];
    if([allKeys containsObject:@"statusStyle"]) self.statusStyle = [LightWebJsonHelper getIntByName:@"statusStyle" and:dict adnDef:0];
    if([allKeys containsObject:@"theme"]) self.theme = [LightWebJsonHelper getIntByName:@"theme" and:dict adnDef:2];
    
    if([allKeys containsObject:@"title"]) self.title = [LightWebJsonHelper getStringByName:@"title" and:dict adnDef:@""];
    if([allKeys containsObject:@"titleColor"]) self.titleColor = [LightWebJsonHelper getStringByName:@"titleColor" and:dict adnDef:@"#000000"];
    if([allKeys containsObject:@"navBackgroundColor"]) self.navBackgroundColor = [LightWebJsonHelper getStringByName:@"navBackgroundColor" and:dict adnDef:@"#FFFFFF"];
    if([allKeys containsObject:@"backgroundColor"]) self.backgroundColor = [LightWebJsonHelper getStringByName:@"backgroundColor" and:dict adnDef:@"#F1F1F1"];
    
    if([allKeys containsObject:@"bounces"]) self.isBounces = [LightWebJsonHelper getBoolByName:@"bounces" and:dict adnDef:YES];
    if([allKeys containsObject:@"showCapsule"]) self.showCapsule = [LightWebJsonHelper getBoolByName:@"showCapsule" and:dict adnDef:YES];
}
@end
