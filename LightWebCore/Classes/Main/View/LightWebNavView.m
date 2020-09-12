//
//  LightWebNavView.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/31.
//

#import "LightWebNavView.h"
#import "LightWebFileHelper.h"
#import "UIImage+LightWebCategory.h"
#import "UIColor+LightWebCategory.h"
@interface LightWebNavView()
@property(nonatomic,weak) UIView *navView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UIButton *backBtn;
@end
@implementation LightWebNavView
-(instancetype)initWith:(LightWebPageConfig *)pageConfig andDelegate:(id<LightWebNavViewDelegate>)delegate{
    self = [super init];
    if (self) {
        [self setUpNavWithTitle:pageConfig andDelegate:delegate];
    }
    return self;
}

-(void)setUpNavWithTitle:(LightWebPageConfig *)pageConfig andDelegate:(id<LightWebNavViewDelegate>)delegate{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;;
    CGFloat statusH = [UIScreen mainScreen].bounds.size.height >= 812 ? 44.0 : 20.0;
    self.frame = CGRectMake(0, 0, width, statusH + 44);
    // 顶部 nav
    UIView *navView = [[UIView alloc] initWithFrame:self.bounds];
    _navView = navView;
    navView.layer.masksToBounds = YES;
    [self addSubview:navView];
    // 返回按钮
    if(pageConfig.needBack){
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(0, statusH, 44, 44);
        [backBtn addTarget:delegate action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:backBtn];
        _backBtn = backBtn;
    }
    // 中间 title
    CGFloat titleLabelX = 104;
    // 侧边按钮长 80 左右边距 12
    CGFloat titleLabelWidth = width - 104 - titleLabelX;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, statusH, titleLabelWidth, 44)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [navView addSubview:titleLabel];
    
    // 设置内容
    [self updatePageConfig:pageConfig];
}
-(void)updatePageConfig:(LightWebPageConfig *)pageConfig{
    // 返回按钮
    if(pageConfig.needBack && _backBtn){
        NSBundle *resourceBundle = [LightWebFileHelper getBundle:self.classForCoder];
        UIImage *image = [UIColor isColorDeep:pageConfig.navBackgroundColor] ? [UIImage imageRenderingOrigin:@"back_w" andBundle:resourceBundle] : [UIImage imageRenderingOrigin:@"back" andBundle:resourceBundle];image = [UIColor isColorDeep:pageConfig.navBackgroundColor] ?  [UIImage imageRenderingOrigin:@"back_w" andBundle:resourceBundle] : [UIImage imageRenderingOrigin:@"back" andBundle:resourceBundle];
        [_backBtn setImage:image forState:UIControlStateNormal];
    }
    // 设置内容
    _navView.backgroundColor = [UIColor colorWithHexString:pageConfig.navBackgroundColor];
    _titleLabel.text = pageConfig.title;
    _titleLabel.textColor = [UIColor colorWithHexString:pageConfig.titleColor];
}
@end
