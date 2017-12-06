//
//  MCProgressHUD.m
//  app
//
//  Created by Marcus on 2017/11/29.
//  Copyright © 2017年 Marcus. All rights reserved.
//

#import "MCProgressHUD.h"
@interface MCProgressHUD() {
    UIWindow *window;
    UIView *viewBackground;
    UIToolbar *toolbarHUD;
    UIActivityIndicatorView *spinner;
    UIImageView *imageView;
    UILabel *labelTitle;
}

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *spinnerColor;
@property (strong, nonatomic) UIColor *hudColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIImage *imageSuccess;
@property (strong, nonatomic) UIImage *imageError;

@end

@implementation MCProgressHUD

+ (MCProgressHUD *)shared {
    static dispatch_once_t once;
    static MCProgressHUD *progressHUD;
    
    dispatch_once(&once, ^{ progressHUD = [[MCProgressHUD alloc] init]; });
    
    return progressHUD;
}

#pragma mark - Display methods
///隐藏
+ (void)hideHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudHide];
    });
}
///显示菊花
+ (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:nil image:nil spin:YES hide:NO interaction:YES];
    });
}
///显示带文字的菊花,其他仍可交互
+ (void)show:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:nil spin:YES hide:NO interaction:YES];
    });
}
///显示带文字的菊花,其他交互可自定义
+ (void)show:(NSString *)title Interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:nil spin:YES hide:NO interaction:interaction];
    });
}

///显示一个只有图片的成功
+ (void)showSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:nil image:[self shared].imageSuccess spin:NO hide:YES interaction:YES];
    });
}
///显示图片加文字的成功,其他仍可交互
+ (void)showSuccess:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:[self shared].imageSuccess spin:NO hide:YES interaction:YES];
    });
}
///显示图片加文字的成功,其他交互自定义
+ (void)showSuccess:(NSString *)title Interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:[self shared].imageSuccess spin:NO hide:YES interaction:interaction];
    });
}

//显示一个只有图片的失败
+ (void)showError {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:nil image:[self shared].imageError spin:NO hide:YES interaction:YES];
    });
}
///显示图片加文字的失败,其他仍可交互
+ (void)showError:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:[self shared].imageError spin:NO hide:YES interaction:YES];
    });
}
///显示图片加文字的失败,其他交互自定义
+ (void)showError:(NSString *)title Interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:title image:[self shared].imageError spin:NO hide:YES interaction:interaction];
    });
}

///显示一个只有文字的提示,其他仍可交互
+ (void)showMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:message image:nil spin:NO hide:YES interaction:YES];
    });
}
///显示一个只有文字提示,交互性可自定义
+ (void) showMessage:(NSString *)message Interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hudCreate:message image:nil spin:NO hide:YES interaction:YES];
    });
}

#pragma mark - Property methods
///自定义设置 文字字体
+ (void)titleFont:(UIFont *)font            {    [self shared].titleFont        = font;        }
///自定义设置 文字颜色
+ (void)titleColor:(UIColor *)color        {    [self shared].titleColor        = color;    }
///自定义设置 菊花颜色
+ (void)spinnerColor:(UIColor *)color        {    [self shared].spinnerColor        = color;    }
///自定义设置 hud颜色
+ (void)hudColor:(UIColor *)color            {    [self shared].hudColor            = color;    }
///自定义设置 背景颜色
+ (void)backgroundColor:(UIColor *)color    {    [self shared].backgroundColor    = color;    }
///自定义设置 成功图片
+ (void)imageSuccess:(UIImage *)image        {    [self shared].imageSuccess        = image;    }
///自定义设置 失败图片
+ (void)imageError:(UIImage *)image            {    [self shared].imageError        = image;    }

#pragma mark -
/// 初始化
- (id)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    self.titleFont            = [UIFont boldSystemFontOfSize:16];
    self.titleColor        = [UIColor blackColor];
    self.spinnerColor        = [UIColor grayColor];
    self.hudColor            = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.backgroundColor    = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    NSBundle *bundle        = [NSBundle bundleForClass:[self class]];
    self.imageSuccess        = [UIImage imageNamed:@"MCProgressHUD.bundle/img_success" inBundle:bundle compatibleWithTraitCollection:nil];
    self.imageError            = [UIImage imageNamed:@"MCProgressHUD.bundle/img_failture" inBundle:bundle compatibleWithTraitCollection:nil];
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    
    viewBackground = nil; toolbarHUD = nil; spinner = nil; imageView = nil; labelTitle = nil;
    self.alpha = 0;
    return self;
}

#pragma mark -
/**
 创建toats
 @param status 文字内容
 @param image 图片
 @param spin 是否旋转
 @param hide 隐藏
 @param interaction 交互开关
 */
- (void)hudCreate:(NSString *)status image:(UIImage *)image spin:(BOOL)spin hide:(BOOL)hide interaction:(BOOL)interaction {
    if (toolbarHUD == nil) {
        toolbarHUD = [[UIToolbar alloc] initWithFrame:CGRectZero];
        toolbarHUD.translucent = YES;
        toolbarHUD.backgroundColor = self.hudColor;
        toolbarHUD.layer.cornerRadius = 10;
        toolbarHUD.layer.masksToBounds = YES;
        [self registerNotifications];
    }
    
    if (toolbarHUD.superview == nil) {
        if (interaction == NO) {
            viewBackground = [[UIView alloc] initWithFrame:window.frame];
            viewBackground.backgroundColor = self.backgroundColor;
            [window addSubview:viewBackground];
            [viewBackground addSubview:toolbarHUD];
        }
        else [window addSubview:toolbarHUD];
    }
    
    if (spinner == nil) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = self.spinnerColor;
        spinner.hidesWhenStopped = YES;
    }
    
    if (spinner.superview == nil) [toolbarHUD addSubview:spinner];
    
    if (imageView == nil &&image != nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        imageView.image = image;
        imageView.hidden = (image == nil) ? YES : NO;
    }
    
    if (imageView.superview == nil && image != nil) [toolbarHUD addSubview:imageView];
    
    if (labelTitle == nil) {
        labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        labelTitle.font = self.titleFont;
        labelTitle.textColor = self.titleColor;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        labelTitle.numberOfLines = 0;
    }
    
    if (labelTitle.superview == nil) [toolbarHUD addSubview:labelTitle];
    labelTitle.text = status;
    labelTitle.hidden = (status == nil) ? YES : NO;
    
    if (spin) [spinner startAnimating]; else [spinner stopAnimating];
    [self hudSizeWithImage:image spin:spin];
    [self hudPosition:nil];
    [self hudShow];
    if (hide) [self timedHide];
}

///注册 通知
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidShowNotification object:nil];
}

///销毁 HUD
- (void)hudDestroy {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [labelTitle removeFromSuperview];        labelTitle = nil;
    [imageView removeFromSuperview];        imageView = nil;
    [spinner removeFromSuperview];            spinner = nil;
    [toolbarHUD removeFromSuperview];        toolbarHUD = nil;
    [viewBackground removeFromSuperview];    viewBackground = nil;
}

#pragma mark -

/**
 progressHUD 布局调整
 */
- (void)hudSizeWithImage:(UIImage *)image spin:(BOOL)spin {
    CGRect rectLabel = CGRectZero;
    CGFloat widthHUD = 100, heightHUD = 100;
    
    if (labelTitle.text != nil) {
        NSDictionary *attributes = @{NSFontAttributeName:labelTitle.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        rectLabel = [labelTitle.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];
        
        widthHUD = rectLabel.size.width + 50;
        heightHUD =(spin == NO && image == nil)? rectLabel.size.height + 50 : rectLabel.size.height + 75;
        
        if (widthHUD < 100) widthHUD = 100;
        if (heightHUD < 100&&!(spin == NO && image == nil)) heightHUD = 100;
        
        rectLabel.origin.x = (widthHUD - rectLabel.size.width) / 2;
        rectLabel.origin.y = (spin == NO && image == nil)? ((heightHUD - rectLabel.size.height))/2:(heightHUD - rectLabel.size.height) / 2 + 25;
    }
    
    toolbarHUD.bounds = CGRectMake(0, 0, widthHUD, heightHUD);
    
    CGFloat imageX = widthHUD/2;
    CGFloat imageY = (labelTitle.text == nil) ? heightHUD/2 : 36;
    imageView.center = spinner.center = CGPointMake(imageX, imageY);
    labelTitle.frame = rectLabel;
}

- (void)hudPosition:(NSNotification *)notification {
    CGFloat heightKeyboard = 0;
    NSTimeInterval duration = 0;
    
    if (notification != nil) {
        NSDictionary *info = [notification userInfo];
        CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        if ((notification.name == UIKeyboardWillShowNotification) || (notification.name == UIKeyboardDidShowNotification)) {
            heightKeyboard = keyboard.size.height;
        }
    }
    else heightKeyboard = [self keyboardHeight];
    
    CGRect screen = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(screen.size.width/2, (screen.size.height-heightKeyboard)/2);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        toolbarHUD.center = CGPointMake(center.x, center.y);
    } completion:nil];
    
    if (viewBackground != nil) viewBackground.frame = window.frame;
}


- (CGFloat)keyboardHeight {
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if ([[testWindow class] isEqual:[UIWindow class]] == NO) {
            for (UIView *possibleKeyboard in [testWindow subviews]) {
                if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
                    return possibleKeyboard.bounds.size.height;
                }
                else if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"]) {
                    for (UIView *hostKeyboard in [possibleKeyboard subviews]) {
                        if ([[hostKeyboard description] hasPrefix:@"<UIInputSetHost"]) {
                            return hostKeyboard.frame.size.height;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

#pragma mark -
///显示hud
- (void)hudShow{
    if (self.alpha == 0) {
        self.alpha = 1;
        toolbarHUD.alpha = 0;
        toolbarHUD.transform = CGAffineTransformScale(toolbarHUD.transform, 1.4, 1.4);
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            toolbarHUD.transform = CGAffineTransformScale(toolbarHUD.transform, 1/1.4, 1/1.4);
            toolbarHUD.alpha = 1;
        } completion:nil];
    }
}
///隐藏hud
- (void)hudHide {
    if (self.alpha == 1) {
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            toolbarHUD.transform = CGAffineTransformScale(toolbarHUD.transform, 0.7, 0.7);
            toolbarHUD.alpha = 0;
        }
                         completion:^(BOOL finished) {
                             [self hudDestroy];
                             self.alpha = 0;
                         }];
    }                             
}
///定时隐藏hud
- (void)timedHide {
    NSTimeInterval delay = labelTitle.text.length * 0.04 + 0.5;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){ [self hudHide]; });
}

@end
