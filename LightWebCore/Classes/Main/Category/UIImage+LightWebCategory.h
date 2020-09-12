//
//  UIImage+LightWebCategory.h
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LightWebCategory)
+(UIImage *)imageRenderingOrigin:(NSString *)imageName andBundle:(NSBundle *)resourceBundle;
@end

NS_ASSUME_NONNULL_END
