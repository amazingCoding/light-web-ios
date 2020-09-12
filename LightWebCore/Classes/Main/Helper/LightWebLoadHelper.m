//
//  LightWebLoadHelper.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebLoadHelper.h"
#import "LightWebFileHelper.h"
#import "LightWebAppFileItem.h"
#import "SSZipArchive.h"
typedef void(^LightWebProgressBlock)(CGFloat progress);
typedef void(^LightWebSuccessHandler)(NSString *rootDir);
typedef void(^LightWebErrorHandler)(NSError* error);
static NSString* const cacheRootName = @"lightWeb";
static NSString* const cacheConfigFileName = @"config.plist";

@interface LightWebLoadHelper()<NSURLSessionDownloadDelegate>
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong)LightWebProgressBlock progressBlock;
@property(nonatomic,strong)LightWebSuccessHandler successHandler;
@property(nonatomic,strong)LightWebErrorHandler errorHandler;
@property(nonatomic,strong)NSString *loadURL;
@property(nonatomic,strong)NSString *version;
@property(nonatomic,strong)NSString *rootDir;
@property(nonatomic,strong)NSString *appZipURL;
@end
@implementation LightWebLoadHelper

- (void)dealloc{
    [self stopLoad];
}
-(void)stopLoad{
    if(_downloadTask){
        [_downloadTask cancel];
        _downloadTask = nil;
    }
}
-(void)startLoadWithUrl:(NSString *)url andMustLoad:(BOOL)mustLoad ProgressBlock:(nullable void (^)(CGFloat progress))ProgressBlock SuccessHandler:(nullable void (^)(NSString * _Nullable rootDir))successHandler ErrorHandler:(nullable void (^)(NSError * _Nullable error))errorHandler{
    _progressBlock = ProgressBlock;
    _successHandler = successHandler;
    _errorHandler = errorHandler;
    // 分解 URL
    // mustLoad = YES 直接删除 file 再下载
    // mustLoad = NO —— 判断 root/config.plist 是否存在 —— 存在则读取 version 值 和 URL[1] 是否一致 —— 直接打开
    // 下载 - 解压（其他线程执行）
    NSArray *urlArr = [url componentsSeparatedByString:@"?"];
    NSString *name = [NSString stringWithFormat:@"%lu",(unsigned long)[urlArr[0] hash]];
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *appDir =[NSString stringWithFormat:@"%@/%@",cachePath,cacheRootName]; // XX/lightWeb
    NSString *rootDir =[NSString stringWithFormat:@"%@/%@",appDir,name]; // XX/lightWeb/hashcode
    NSString *version = @"";
    if (urlArr.count > 1) { version = urlArr[1]; }
    _version = version;
    _rootDir = rootDir;
    
    BOOL hasSameVersion = NO;
    if (!mustLoad) {
        NSString *configFile =[NSString stringWithFormat:@"%@/%@",rootDir,cacheConfigFileName]; // XX/lightWeb/hashcode/config.plist
        if([LightWebFileHelper FileIsExists:configFile andIsDir:NO]){
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:configFile]];
            LightWebAppFileItem *appFile = [[LightWebAppFileItem alloc] initWithDict:dict];
            if([version isEqualToString:appFile.version]) hasSameVersion = YES;
        }
    }
    _loadURL = url;
    // 下载
    if(mustLoad || !hasSameVersion){
//        NSLog(@"下载");
        // 确保 lightWeb 存在
        [LightWebFileHelper createDirIfNoting:appDir];
        // reset rootDir 目录
        [LightWebFileHelper resetDir:rootDir];
        // 取消之前的下载
        [self stopLoad];
        // 启动 session
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:url]];
        [_downloadTask resume];
    }
    else{
//        NSLog(@"本地");
        successHandler(rootDir);
    }
}
-(void)unZip{
    // 开新线程来解压，太大的解压包会导致系统卡停太久认为程序死掉了
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [SSZipArchive unzipFileAtPath:weakSelf.appZipURL toDestination:weakSelf.rootDir progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.errorHandler(error);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dict = @{
                        @"downloadURL":weakSelf.loadURL,
                        @"version":weakSelf.version,
                    };
                    // 写入配置 & 删除 zip 包
                    NSString *plistPath = [NSString stringWithFormat:@"%@/%@",weakSelf.rootDir,cacheConfigFileName];
                    [LightWebFileHelper createPlist:dict andPath:plistPath];
                    [LightWebFileHelper delIfExists:weakSelf.appZipURL andIsDir:NO];
                    weakSelf.successHandler(weakSelf.rootDir);
                });

            }
        }];
    });
}
#pragma mark - NSURLSessionDelegate
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
//    /** 把data task 转换成 download task. */
//  completionHandler(NSURLSessionResponseBecomeDownload);
//}
// 每次写入调用(会调用多次)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    // 下载进度
    if (_progressBlock) {
        CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite; NSLog(@"%f",progress);
        _progressBlock(progress);
    }
}
// 下载完成调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
    _appZipURL = [NSString stringWithFormat:@"%@/app.zip",_rootDir];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:_appZipURL] error:nil];
    [self unZip];
}
// 任务完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error && _errorHandler) {
        _errorHandler(error);
    }
}

@end
