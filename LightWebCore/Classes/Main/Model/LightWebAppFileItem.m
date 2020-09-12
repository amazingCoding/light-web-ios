//
//  LightWebAppFileItem.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/29.
//

#import "LightWebAppFileItem.h"

@implementation LightWebAppFileItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [self init];
    self.downloadURL = dict[@"downloadURL"];
    self.version = dict[@"version"];
    return self;
}

@end
