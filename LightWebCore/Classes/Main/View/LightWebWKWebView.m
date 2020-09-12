//
//  LightWebWKWbView.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebWKWebView.h"
#import "LightWebJavaScriptMethod.h"
#import "NSString+LightWebCategory.h"
static NSString* const WEB_APP_VERSION = @"webApp/ios/0.1";
@interface LightWebWKWebView()
@property (nonatomic,strong)NSArray *jsMethods;
@property (nonatomic,assign)BOOL needDebug;
@end
@implementation LightWebWKWebView

-(instancetype)initWith:(LightWebJavaScriptManager *)jsDelegate andNeedDebug:(BOOL)needDebug{
    self = [super initWithFrame:CGRectZero];
    WKWebViewConfiguration *config = self.configuration;
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 1;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    NSArray *jsMethods = [LightWebJavaScriptMethod getJavaScriptMethods];
    for (NSString *methodName in jsMethods) {
        [config.userContentController addScriptMessageHandler:jsDelegate name:methodName];
    }
    if (needDebug) { [self creatDebugScript]; }
    self.jsMethods = jsMethods;
    
    self.customUserAgent = WEB_APP_VERSION;
    
    return  self;
}
-(void)evaluateJsByID:(int)ID andRes:(nullable id)resDic andState:(int)state andFlag:(BOOL)flag{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSNumber  numberWithInt:state] forKey:@"state"];
    NSString *javaScript = @"";
    NSString *jsFlag = flag ? @"true" : @"false";
    if(state == 0){
        [dict setValue:resDic == nil ? [NSNull null]:resDic forKey:@"data"];
        NSString *resStr = [NSString initWithDict:dict];
        javaScript = [NSString stringWithFormat:@"window[%@].exec(%d,%@,null,%@)",_globalName,ID,resStr,jsFlag];
    }
    else{
        [dict setValue:resDic == nil ? [NSNull null]:resDic forKey:@"errorMsg"];
        NSString *resStr = [NSString initWithDict:dict];
        javaScript = [NSString stringWithFormat:@"window[%@].exec(%d,null,%@,%@)",_globalName,ID,resStr,jsFlag];
    }
//    NSLog(@"== javaScript %@",javaScript);
    [self evaluateJavaScript:javaScript completionHandler:nil];
}
-(void)pusJavaScriptByName:(NSString *)name andRes:(nullable id)resDic{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInt:0] forKey:@"state"];
    [dict setValue:resDic == nil ? [NSNull null]:resDic forKey:@"data"];
    NSString *resStr = [NSString initWithDict:dict];
    NSString *javaScript = [NSString stringWithFormat:@"window[%@].pub('%@',%@)",_globalName,name,resStr];
    NSLog(@"== javaScript %@",javaScript);
    [self evaluateJavaScript:javaScript completionHandler:nil];
}
-(void)creatDebugScript{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"LightWebCore.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    NSString *jsFile = [resourceBundle pathForResource:@"vconsole" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:script];
}
-(void)appBecomeActive{
    [self pusJavaScriptByName:[LightWebJavaScriptMethod active] andRes:nil];
}
-(void)appBecomeNotActive{
    [self pusJavaScriptByName:[LightWebJavaScriptMethod backGround] andRes:nil];
}
-(void)dealloc{
    for (NSString *methodName in _jsMethods) {
        [self.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }
    [self.configuration.userContentController removeAllUserScripts];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
