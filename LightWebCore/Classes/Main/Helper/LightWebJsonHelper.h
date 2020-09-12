//
//  LightWebJsonHelper.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebJsonHelper : NSObject
+(BOOL)getBoolByName:(NSString *)name and:(NSDictionary *)dict adnDef:(BOOL)def;
+(NSString *)getStringByName:(NSString *)name and:(NSDictionary *)dict adnDef:(NSString *)def;
+(int)getIntByName:(NSString *)name and:(NSDictionary *)dict adnDef:(int)def;
@end

NS_ASSUME_NONNULL_END
