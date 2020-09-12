//
//  LightWebCoreController.m
//  lightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebCoreController.h"
#import "LightWebPanInteractiveTransition.h"
#import "LightWebDismissAnimation.h"
#import "LightWebAppController.h"
#import "LightWebFileHelper.h"
@interface LightWebCoreController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)LightWebPanInteractiveTransition *panInteractiveTransition;
@property (nonatomic,strong)LightWebDismissAnimation *dismissAnimation;
@end

@implementation LightWebCoreController
#pragma mark -- view
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.hidden = YES;
    self.transitioningDelegate = self;
    [self.panInteractiveTransition panToDismiss:self];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    #pragma clang diagnostic pop
    
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (void)dealloc{
    _panInteractiveTransition = nil;
    _dismissAnimation = nil;
}
#pragma mark -- 进入退出的过渡动画
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextFromViewKey];
        view.alpha = 0.5;
        view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextToViewKey];
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}
#pragma mark - UIViewControllerTransitioningDelegate
-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}
-(id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.panInteractiveTransition.isInteractive ? self.panInteractiveTransition : nil;
}
#pragma mark - 多个手势处理
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer*)otherGestureRecognizer{
   return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return self.childViewControllers.count == 1;
    }
    else{
        return self.childViewControllers.count > 1;
    }
}
#pragma mark -- 懒加载
- (LightWebPanInteractiveTransition *)panInteractiveTransition{
    if(!_panInteractiveTransition) _panInteractiveTransition = [[LightWebPanInteractiveTransition alloc] init];
    return _panInteractiveTransition;
}
- (LightWebDismissAnimation *)dismissAnimation{
    if(!_dismissAnimation) _dismissAnimation = [[LightWebDismissAnimation alloc] init];
    return _dismissAnimation;
}
#pragma mark -- 初始化
-(instancetype)initWithURL:(NSString *)url isDev:(BOOL)isDev withMaxRouter:(int)maxRouter{
    _url = url;
    _isDev = isDev;
    _maxRouter = maxRouter;
    LightWebAppController *vc = [[LightWebAppController alloc] initWithName:@"index" andCurrentPos:0 andExtra:nil];
    self = [super initWithRootViewController:vc];
    return self;
}
-(void)restart{
    // 强制重新下载
    _rootFile = nil;
    // 新建
    LightWebAppController *vc = [[LightWebAppController alloc] initWithName:@"index" andCurrentPos:0 andExtra:nil];
    NSArray *vcs = @[vc];
    [self setViewControllers:vcs animated:NO];
}
@end
