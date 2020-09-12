//
//  LightWebCapsuleView.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LightWebCapsuleViewDelegate <NSObject>
@required
-(void)closeEvent;
-(void)aboutEvent;
@end
@interface LightWebCapsuleView : UIView
-(instancetype)initWithDelegate:(id<LightWebCapsuleViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
