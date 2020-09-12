//
//  LightWebJavaScriptMessage.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LightWebJavaScriptManagerDelegate <NSObject>
@required
-(void)javaScriptMessageWithName:(NSString *)name andData:(NSDictionary *)data;
@end

@interface LightWebJavaScriptManager : NSObject<WKScriptMessageHandler>
- (instancetype)initWithDelegate:(id <LightWebJavaScriptManagerDelegate>)scriptDelegate;
@property (nonatomic,weak) id<LightWebJavaScriptManagerDelegate>scriptDelegate;
@end

NS_ASSUME_NONNULL_END
