//
//  LightWebMainView.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebMainView.h"
#import "LightWebWKWebView.h"
#import "LightWebPageConfig.h"

@interface LightWebMainView()
@property (nonatomic,weak)LightWebWKWebView *webView;
@property (nonatomic,weak)UIView *myView;
@end
@implementation LightWebMainView

-(void)addView:(UIView *)view{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:view];
    _myView = view;
}
-(void)addWebView:(LightWebWKWebView *)view{
    [view setAlpha:0.0];
    [self addSubview:view];
    _webView = view;
}
-(void)removeLoadAndShowWeb{
    if (_myView) {
        [_myView removeFromSuperview];
        _myView = nil;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.35f animations:^{
            [weakSelf.webView setAlpha:1.0f];
        }];
    }
}

@end
