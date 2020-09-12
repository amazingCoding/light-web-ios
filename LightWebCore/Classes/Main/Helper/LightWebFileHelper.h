//
//  FileHelper.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebFileHelper : NSObject
+(BOOL)FileIsExists:(NSString *)file andIsDir:(BOOL)isDir;
+(void)createDirIfNoting:(NSString *)file;
+(void)resetDir:(NSString *)file;
+(BOOL)createPlist:(NSDictionary *)dict andPath:(NSString *)path;
+(BOOL)delIfExists:(NSString *)file andIsDir:(BOOL)isDir;
+(NSBundle *)getBundle:(Class)aClass;
@end

NS_ASSUME_NONNULL_END
