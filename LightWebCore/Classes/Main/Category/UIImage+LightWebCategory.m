//
//  UIImage+LightWebCategory.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "UIImage+LightWebCategory.h"

@implementation UIImage (LightWebCategory)
+(UIImage *)imageRenderingOrigin:(NSString *)imageName andBundle:(NSBundle *)resourceBundle{
    UIImage *img = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
