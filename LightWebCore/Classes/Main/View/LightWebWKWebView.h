//
//  LightWebWKWbView.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <WebKit/WebKit.h>
#import "LightWebJavaScriptManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface LightWebWKWebView : WKWebView
@property (nonatomic,strong)NSString *globalName;
-(instancetype)initWith:(LightWebJavaScriptManager *)jsDelegate andNeedDebug:(BOOL) needDebug;
-(void)evaluateJsByID:(int)ID andRes:(nullable id)resDic andState:(int)state andFlag:(BOOL)flag;
-(void)pusJavaScriptByName:(NSString *)name andRes:(nullable id)resDic;
-(void)creatDebugScript;
@end

NS_ASSUME_NONNULL_END
