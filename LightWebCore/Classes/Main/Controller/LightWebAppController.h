//
//  LightWebAppController.h
//  lightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebAppController : UIViewController
-(instancetype)initWithName:(NSString *)name andCurrentPos:(int)pos andExtra:(nullable NSString *)extra;
- (void)setShowExtra:(NSString *)showExtra;
@end

NS_ASSUME_NONNULL_END
