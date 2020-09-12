//
//  LightWebAppController.m
//  lightWebCore
//
//  Created by 宋航 on 2020/8/28.
//

#import "LightWebAppController.h"
#import "LightWebCoreController.h"
#import "LightWebCapsuleView.h"
#import "LightWebMainView.h"
#import "LightWebLoadView.h"
#import "LightWebErrorView.h"
#import "LightWebLoadHelper.h"
#import "LightWebJavaScriptManager.h"
#import "LightWebWKWebView.h"
#import "LightWebPageConfig.h"
#import "LightWebNavView.h"
#import "LightWebAppInfoItem.h"
#import "LightWebJsonHelper.h"
#import "UIColor+LightWebCategory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LightWebJavaScriptMethod.h"
#import "LightWebRouterSystem.h"
#import "LightWebFileHelper.h"

API_AVAILABLE(ios(10.0))
@interface LightWebAppController ()<LightWebJavaScriptManagerDelegate,WKNavigationDelegate,LightWebCapsuleViewDelegate,LightWebNavViewDelegate>
@property (nonatomic,assign)int currentPos;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *extra;
@property (nonatomic,strong)NSString *showExtra;
@property (nonatomic,strong)NSString *popExtra;

@property(nonatomic, strong)LightWebLoadHelper *loadHelper;

@property(nonatomic, weak)LightWebMainView *appView;
@property(nonatomic, weak)LightWebWKWebView *webView;
@property(nonatomic, weak)LightWebNavView *navView;
@property(nonatomic, weak)LightWebCapsuleView *capsuleBtnView;
@property(nonatomic, weak)LightWebCoreController *coreController;

@property(nonatomic, strong)LightWebPageConfig *pageConfig;
@property(nonatomic, strong)LightWebAppInfoItem *appInfo;
@property(nonatomic, assign)UIStatusBarStyle statusBarStyle;

@property (nonatomic,assign)BOOL isInit;
@property (nonatomic,assign)BOOL isHidden;
@property (nonatomic,assign)BOOL isInBackGround;
@property(nonatomic, strong)UIPasteboard *pasteboard;
@property (nonatomic, strong)UIImpactFeedbackGenerator *impactLight;
@end

@implementation LightWebAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setUpView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_webView && _isInit && _isHidden){
        _isHidden = NO;
        [_webView pusJavaScriptByName:[LightWebJavaScriptMethod viewShow] andRes:_showExtra];
        _showExtra = nil;
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_webView && _isInit) {
        _isHidden = YES;
        [_webView pusJavaScriptByName:[LightWebJavaScriptMethod viewHide] andRes:nil];
    }
}
- (void)dealloc{
    if(_loadHelper) [_loadHelper stopLoad];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (!_statusBarStyle) {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    }
    else{
        return _statusBarStyle;
    }
}
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            // bug ? https://stackoverflow.com/questions/59139757/traitcollectiondidchange-strange-behavior
            if (_webView && _isInit && _pageConfig.theme == autoTheme) {
                int newTheme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? 1 : 0;
                if(newTheme != _appInfo.currentTheme){
                    NSDictionary *dict = @{ @"theme" : [NSNumber numberWithInt:newTheme] };
                    _appInfo.currentTheme = newTheme;
                    [_webView pusJavaScriptByName:[LightWebJavaScriptMethod sceneMode] andRes:dict];
                }
                
            }
        }
    }
}
-(instancetype)initWithName:(NSString *)name andCurrentPos:(int)pos andExtra:(nullable NSString *)extra{
    self = [super init];
    _currentPos = pos;
    _name = name;
    _extra = extra;
    return self;
}
#pragma mark -- get / set
-(UIImpactFeedbackGenerator *)impactLight API_AVAILABLE(ios(10.0)){
    if (!_impactLight) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
        _impactLight = impactLight;
        [_impactLight prepare];
    }
    return _impactLight;
}
-(UIPasteboard *)pasteboard{
    if (!_pasteboard) { _pasteboard = [UIPasteboard generalPasteboard]; }
    return  _pasteboard;
}
- (LightWebNavView *)navView{
    if(_navView == nil){
        LightWebNavView *navView = [[LightWebNavView alloc] initWith:_pageConfig andDelegate:self];
        [_appView addSubview:navView];
        _navView = navView;
    }
    return _navView;
}
- (LightWebAppInfoItem *)appInfo{
    if (_appInfo == nil) {
        LightWebCoreController *coreController =  self.coreController;
        _appInfo = [[LightWebAppInfoItem alloc] init];
        _appInfo.maxRouters = coreController.maxRouter;
        _appInfo.currentPos = _currentPos;
        _appInfo.currentTheme = 0;
        _appInfo.capsuleRect = _capsuleBtnView.frame;
    }
    return _appInfo;
}
- (LightWebCoreController *)coreController{
    if(_coreController == nil){
        _coreController = (LightWebCoreController *)self.navigationController;
    }
    return _coreController;
}
- (void)setShowExtra:(NSString *)showExtra{
    _showExtra = showExtra;
}
- (void)changeTheme{
    // 主题处理：
    if (@available(iOS 13.0, *)) {
        if(_pageConfig.theme != autoTheme){
            self.overrideUserInterfaceStyle = _pageConfig.theme == light ? UIUserInterfaceStyleLight : UIUserInterfaceStyleDark;
        }
        _appInfo.currentTheme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? 1 : 0;
        NSLog(@"init traitCollection : --- %ld",(long)self.traitCollection.userInterfaceStyle);
    }
    else{
        _appInfo.currentTheme = 0;
    }
}
#pragma mark -- UI
-(void)setUpView{
    // 创建 APP view
    LightWebMainView *appView = [[LightWebMainView alloc] initWithFrame:self.view.bounds];
    _appView = appView;
    [self.view addSubview:appView];
    // 创建 capsuleBtn
    LightWebCapsuleView *capsuleBtnView = [[LightWebCapsuleView alloc] initWithDelegate:self];
    _capsuleBtnView = capsuleBtnView;
    [self.view addSubview:capsuleBtnView];
    // 渲染 load 页面
    [_appView addView:[self getLoadView]];
    // 判断是否下载好： pos = 0 & pos != 0 的区别
    if(self.coreController.rootFile != nil){
        [self setUpWebView];
    }
    else{
        [self download];
    }
}
-(UIView *)getLoadView{
    return [[LightWebLoadView alloc] initWithFrame:self.view.bounds];
}
-(UIView *)getErrorView:(NSString *)error{
    return [[LightWebErrorView alloc] initWithFrame:self.view.bounds andText:error addTarget:self reloadAction:@selector(reloadEvent) closeAction:@selector(closeEvent)];
}
-(void)setUpWebView{
    // 判断 name 文件是否存在
    NSString *htmlFile = [NSString stringWithFormat:@"%@/%@.html",self.coreController.rootFile,self.name];
    if(![LightWebFileHelper FileIsExists:htmlFile andIsDir:NO]){
        [self.appView addView:[self getErrorView:@"missing html file"]];
        return;
    }
    // 加入webview 透明度最低
    LightWebJavaScriptManager *javaScriptManager = [[LightWebJavaScriptManager alloc] initWithDelegate:self];
    LightWebWKWebView *webView = [[LightWebWKWebView alloc] initWith:javaScriptManager andNeedDebug:self.coreController.isDev];
    webView.navigationDelegate = self;
    if (@available(iOS 11.0, *)) { webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; }
    else { self.automaticallyAdjustsScrollViewInsets = NO; }
    NSURL *baseUrl = [NSURL fileURLWithPath: self.coreController.rootFile isDirectory: YES];
    NSURL *htmlURL = [NSURL fileURLWithPath:htmlFile isDirectory:NO];
    [webView loadFileURL:htmlURL allowingReadAccessToURL:baseUrl];
    [webView setAlpha:0];
    // 设置 滚动响应优先
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
    [_appView addWebView:webView];
    _webView = webView;
}
-(void)changWebView{
    CGRect frame = _appView.bounds;
    // 设置 UI
    if(!_pageConfig.isHideNav){
        if(_navView != nil){
            [_navView updatePageConfig:_pageConfig];
            [_navView setHidden:NO];
        }
        frame.origin.y = self.navView.bounds.size.height;
        frame.size.height = frame.size.height - self.navView.bounds.size.height;
    }
    else{
        if(_navView != nil) [_navView setHidden:YES];
    }
    _webView.frame = frame;
    // statusBar stle
    if(_pageConfig.statusStyle == dark){
        if (@available(iOS 13.0, *)) { _statusBarStyle = UIStatusBarStyleDarkContent; }
        else { _statusBarStyle =  UIStatusBarStyleDefault; }
    }
    else{ _statusBarStyle = UIStatusBarStyleLightContent; }
    [self setNeedsStatusBarAppearanceUpdate];
    // bounces
    _webView.scrollView.bounces = _pageConfig.isBounces;
    // 背景色
    _webView.scrollView.backgroundColor = [UIColor colorWithHexString:_pageConfig.backgroundColor];
    self.appInfo.webHeight = frame.size.height;
}
#pragma mark -- Btn 事件
-(void)closeEvent{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)aboutEvent{
    
}
-(void)reloadEvent{
    [self download];
}
-(void)backEvent{
    if(_pageConfig && _pageConfig.needBack){
        int pos = _currentPos - 1;
        [self popToVc:pos andExtra:nil];
    }
}
#pragma mark -- other
-(BOOL)checkFileExists:(NSString *)file{
    NSString *htmlFile = [NSString stringWithFormat:@"%@/%@.html",self.coreController.rootFile,file];
    return [LightWebFileHelper FileIsExists:htmlFile andIsDir:NO];
}
-(void)popToVc:(int)pos andExtra:(nullable NSString *)extra{
    // 回调 指定位置 vc 的 show 事件
    LightWebAppController *vc = [self.coreController.viewControllers objectAtIndex:pos];
    NSString *res = extra ? extra : _popExtra;
    [vc setShowExtra:res];
    [self.coreController popToViewController:vc animated:YES];
}
#pragma mark -- download
-(void)download{
    // 下载
    NSString *downLoadURL = self.coreController.url;
    _loadHelper = [[LightWebLoadHelper alloc] init];
    __weak typeof(self) weakSelf = self;
    [_loadHelper startLoadWithUrl:downLoadURL andMustLoad:NO ProgressBlock:^(CGFloat progress) {
        
    } SuccessHandler:^(NSString * _Nullable rootDir) {
        weakSelf.coreController.rootFile = rootDir;
        [weakSelf setUpWebView];
    } ErrorHandler:^(NSError * _Nullable error) {
        [weakSelf.appView addView:[weakSelf getErrorView:error.localizedDescription]];
    }];
}
#pragma mark -- LightWebJavaScriptManagerDelegate
-(void)appBecomeActive{
    _isInBackGround = NO;
    [_webView pusJavaScriptByName:[LightWebJavaScriptMethod active] andRes:nil];
}
-(void)appBecomeNotActive{
    _isInBackGround = YES;
    [_webView pusJavaScriptByName:[LightWebJavaScriptMethod backGround] andRes:nil];
}
-(void)javaScriptMessageWithName:(NSString *)name andData:(NSDictionary *)data{
    int ID = [data[@"id"] intValue];
    NSDictionary *reqData = data[@"data"];
    int pos = [LightWebJavaScriptMethod getMethodPos:name];
    switch (pos) {
        case 0:{
            [self webViewInit:reqData andCallBackID:ID];
            break;
        }
        case 1:{
            [self webPageChange:reqData andCallBackID:ID];
            break;
        }
        case 2:{
             [self webRouter:reqData andCallBackID:ID];
            break;
        }
        case 3:{
            [self webVibrate:reqData andCallBackID:ID];
            break;
        }
        case 4:{
            [self webSetClipboard:reqData andCallBackID:ID];
            break;
        }
        case 5:{
            [self webGetClipboard:reqData andCallBackID:ID];
            break;
        }
        default:{
            break;
        }
    }
}
-(void)webViewInit:(NSDictionary *)data andCallBackID:(int)ID{
    _pageConfig = [[LightWebPageConfig alloc] initWithDict:data];
    _pageConfig.needBack = _currentPos > 0;
    _webView.globalName = _pageConfig.global;
    [self changWebView];
    // 主题处理：
    [self changeTheme];
    // return js
    [_webView evaluateJsByID:ID andRes:[_appInfo getInitMsg:_extra] andState:0 andFlag:NO];
    _extra = nil;
    // 展示 webview
    [_appView removeLoadAndShowWeb];
    _isInit = YES;
    // 绑定 监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeNotActive) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
-(void)webPageChange:(NSDictionary *)data andCallBackID:(int)ID{
    [_pageConfig updateDict:data];
    [self changWebView];
    // 主题处理：
    [self changeTheme];
    // return js
    [_webView evaluateJsByID:ID andRes:[_appInfo getPageMsg] andState:0 andFlag:NO];
    
}
-(void)webVibrate:(NSDictionary *)data andCallBackID:(int)ID{
    BOOL isLong = [LightWebJsonHelper getBoolByName:@"isLong" and:data adnDef:YES];
    if(isLong){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else{
        if (@available(iOS 10.0, *)) [self.impactLight impactOccurred];
    }
    [_webView evaluateJsByID:ID andRes:nil andState:0 andFlag:NO];
}
-(void)webSetClipboard:(NSDictionary *)data andCallBackID:(int)ID{
    NSString *text = [LightWebJsonHelper getStringByName:@"text" and:data adnDef:@""];
    self.pasteboard.string = text;
    if ([self.pasteboard.string isEqualToString:text]) {
        [_webView evaluateJsByID:ID andRes:nil andState:0 andFlag:NO];
    }
    else{
        [_webView evaluateJsByID:ID andRes:@"失败" andState:-1 andFlag:NO];
    }
}
-(void)webGetClipboard:(NSDictionary *)data andCallBackID:(int)ID{
    [_webView evaluateJsByID:ID andRes:self.pasteboard.string andState:0 andFlag:NO];
}
-(void)webRouter:(NSDictionary *)data andCallBackID:(int)ID{
    LightWebRouterSystem *routerSystem = [[LightWebRouterSystem alloc] initWith:data];
    NSString *error = nil;
    switch (routerSystem.action) {
        case push:{
            if(_currentPos >= self.coreController.maxRouter -1){ error = @"max router limit"; }
            else{
                if([self checkFileExists:routerSystem.name]){
                    LightWebAppController *vc = [[LightWebAppController alloc] initWithName:routerSystem.name andCurrentPos:_currentPos+1 andExtra:routerSystem.extra];
                    [self.coreController pushViewController:vc animated:YES];
                }
                else{
                    error = [NSString stringWithFormat:@"missing %@ file",routerSystem.name];
                }
            }
            break;
        }
        case pop:{
            if(_currentPos == 0){ error = @"it is the first page"; }
            else{
                if(routerSystem.pos > -1 && routerSystem.pos >= _currentPos){ error = @"it is error pos to pop"; }
                else{
                    int pos = _currentPos - 1;
                    if(routerSystem.pos > -1) pos = routerSystem.pos;
                    [self popToVc:pos andExtra:routerSystem.extra];
                }
            }
            break;
        }
        case replace:{
            if(routerSystem.pos > -1 && routerSystem.pos >= _currentPos){ error = @"it is an error pos to replace"; }
            else{
                if([self checkFileExists:routerSystem.name]){
                    int pos = _currentPos;
                    if(routerSystem.pos > -1) pos = routerSystem.pos;
                    LightWebAppController *vc = [[LightWebAppController alloc] initWithName:routerSystem.name andCurrentPos:pos andExtra:routerSystem.extra];
                    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.coreController.viewControllers];
                    for (int i = 0; i < vcs.count; i++) {
                        if(i == pos){ vcs[i] = vc; }
                        else if (i > pos){
                            [vcs removeObjectAtIndex:i];
                        }
                    }
                    [self.coreController setViewControllers:vcs animated:NO];
                }
                else{ error = [NSString stringWithFormat:@"missing %@ file",routerSystem.name]; }
            }
            break;
        }
        case setPopExtra:{
            if(_currentPos == 0){  error = @"first page can not set popRouterExtra";  }
            else{
                _popExtra = routerSystem.extra;
                [_webView evaluateJsByID:ID andRes:nil andState:0 andFlag:NO];
            }
            break;
        }
        case restart:{
            [self.coreController restart];
            break;
        }
        default:{
            break;
        }
    }
    if(error != nil) [_webView evaluateJsByID:ID andRes:error andState:-1 andFlag:NO];
}
@end
