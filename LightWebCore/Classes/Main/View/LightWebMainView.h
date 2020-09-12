//
//  LightWebMainView.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebMainView : UIView
-(void)addView:(UIView *)view;
-(void)addWebView:(UIView *)view;
-(void)removeLoadAndShowWeb;
@end

NS_ASSUME_NONNULL_END
