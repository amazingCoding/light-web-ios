//
//  FileHelper.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebFileHelper.h"
static NSString* const cacheRootName = @"lightWeb";
@implementation LightWebFileHelper

+(BOOL)FileIsExists:(NSString *)file andIsDir:(BOOL)isDir{
    NSString *dirPath = file;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    return (existed && !isDir);
}
+(void)createDirIfNoting:(NSString *)file{
    if(![LightWebFileHelper FileIsExists:file andIsDir:YES]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+(void)resetDir:(NSString *)file{
    if([LightWebFileHelper FileIsExists:file andIsDir:YES]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:file error:nil];
    }
    [LightWebFileHelper createDirIfNoting:file];
}
+(BOOL)createPlist:(NSDictionary *)dict andPath:(NSString *)path{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:path contents:nil attributes:nil];
    return [dict writeToFile:path atomically:YES];
}
+(BOOL)delIfExists:(NSString *)file andIsDir:(BOOL)isDir{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:file isDirectory:&isDir];
    if(existed){
        return [fileManager removeItemAtPath:file error:nil];
    }
    return existed;
}
+(NSBundle *)getBundle:(Class)aClass{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"LightWebCore.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    return resourceBundle;
}
@end
