//
//  LightWebJavaScriptMessage.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebJavaScriptManager.h"

@implementation LightWebJavaScriptManager
- (instancetype)initWithDelegate:(id <LightWebJavaScriptManagerDelegate>)scriptDelegate{
    self = [super init];
    if (self) {
        self.scriptDelegate = scriptDelegate;
    }
    return self;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if (![[message.body allKeys] containsObject:@"id"] || ![[message.body allKeys] containsObject:@"data"]) { return; }
    if(self.scriptDelegate){
        [self.scriptDelegate javaScriptMessageWithName:message.name andData:message.body];
    }
}
-(void)dealloc{
}
@end
