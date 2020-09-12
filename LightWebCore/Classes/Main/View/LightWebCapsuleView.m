//
//  LightWebCapsuleView.m
//  LightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebCapsuleView.h"
#import "LightWebFileHelper.h"
#import "UIColor+LightWebCategory.h"
#import "UIImage+LightWebCategory.h"
@interface LightWebCapsuleView()
@property(nonatomic,weak) UIButton *closeBtn;
@property(nonatomic,weak) UIButton *aboutBtn;
@end

@implementation LightWebCapsuleView

- (instancetype)initWithDelegate:(id<LightWebCapsuleViewDelegate>)delegate{
    self = [super init];
    if (self) {
        [self setUpClostBtn:delegate];
    }
    return self;
}
-(void)setUpClostBtn:(id<LightWebCapsuleViewDelegate>)delegate{
    NSBundle *resourceBundle = [LightWebFileHelper getBundle:self.classForCoder];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;;
    CGFloat statusH = [UIScreen mainScreen].bounds.size.height >= 812 ? 44.0 : 20.0;
    CGFloat HEIGHT = 30;
    CGFloat WIDTH = 40;
    CGFloat lineHeight = 20;
    CGFloat lineWidth = 0.5;
    CGFloat allWidth = (WIDTH * 2 + lineWidth); // 80.5
    CGFloat paddingRight = 12;
    self.frame = CGRectMake(width - allWidth - paddingRight, (44-HEIGHT) * 0.5 + statusH, allWidth, HEIGHT);
    
    self.layer.cornerRadius = HEIGHT * 0.5;
    self.layer.masksToBounds = YES;
    UIColor *lineColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.6];
    self.layer.borderColor = lineColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    // 关闭 按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeBtn = closeBtn;
    closeBtn.frame = CGRectMake(WIDTH + lineWidth, 0, WIDTH, HEIGHT);
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn setImage:[UIImage imageRenderingOrigin:@"circular" andBundle:resourceBundle] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    // about 按钮
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    aboutBtn.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    _aboutBtn = aboutBtn;
    aboutBtn.backgroundColor = UIColor.clearColor;
    [aboutBtn setImage:[UIImage imageRenderingOrigin:@"more" andBundle:resourceBundle] forState:UIControlStateNormal];
    [self addSubview:aboutBtn];
    // line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(WIDTH,(HEIGHT - lineHeight) * 0.5, lineWidth, lineHeight)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
    
    //delegate
    [closeBtn addTarget:delegate action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [aboutBtn addTarget:delegate action:@selector(aboutEvent) forControlEvents:UIControlEventTouchUpInside];
}

@end
