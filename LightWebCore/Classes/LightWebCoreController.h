//
//  LightWebCoreController.h
//  lightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightWebCoreController : UINavigationController
@property(nonatomic,assign) BOOL isDev;
@property(nonatomic,assign) int maxRouter;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *rootFile;
-(instancetype)initWithURL:(NSString *)url isDev:(BOOL)isDev withMaxRouter:(int)maxRouter;
-(void)restart;
@end

NS_ASSUME_NONNULL_END
