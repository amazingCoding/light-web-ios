//
//  LightWebErrorView.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebErrorView : UIView
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)reason addTarget:(nullable id)target reloadAction:(SEL)reloadAction closeAction:(SEL)closeAction;
@end

NS_ASSUME_NONNULL_END
