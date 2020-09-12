//
//  LightWebNavView.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import <UIKit/UIKit.h>
#import "LightWebPageConfig.h"
NS_ASSUME_NONNULL_BEGIN
@protocol LightWebNavViewDelegate <NSObject>
@required
-(void)backEvent;
@end

@interface LightWebNavView : UIView
-(instancetype)initWith:(LightWebPageConfig *)pageConfig andDelegate:(id<LightWebNavViewDelegate>)delegate;
-(void)updatePageConfig:(LightWebPageConfig *)pageConfig;
@end

NS_ASSUME_NONNULL_END
