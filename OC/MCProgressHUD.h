//
//  MCProgressHUD.h
//  app
//
//  Created by Marcus on 2017/11/29.
//  Copyright © 2017年 Marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProgressHUD : UIView
#pragma mark -
#pragma mark 方法封装
///隐藏
+ (void)hideHUD;

///显示菊花
+ (void)show;
///显示带文字的菊花,其他仍可交互
+ (void)show:(NSString *)status;
///显示带文字的菊花,其他交互可自定义
+ (void)show:(NSString *)status Interaction:(BOOL)interaction;

///显示一个只有图片的成功
+ (void)showSuccess;
///显示图片加文字的成功,其他仍可交互
+ (void)showSuccess:(NSString *)status;
///显示图片加文字的成功,其他交互自定义
+ (void)showSuccess:(NSString *)status Interaction:(BOOL)interaction;

//显示一个只有图片的失败
+ (void)showError;
///显示图片加文字的失败,其他仍可交互
+ (void)showError:(NSString *)status;
///显示图片加文字的失败,其他交互自定义
+ (void)showError:(NSString *)status Interaction:(BOOL)interaction;

///显示一个只有文字的提示,其他仍可交互
+ (void)showMessage:(NSString *)message;
///显示一个只有文字提示,交互性可自定义
+ (void) showMessage:(NSString *)message Interaction:(BOOL)interaction;
#pragma mark -
#pragma mark 自定义HUD属性
///自定义设置 文字字体
+ (void)titleFont:(UIFont *)font;
///自定义设置 字体颜色
+ (void)titleColor:(UIColor *)color;
///自定义设置 菊花颜色
+ (void)spinnerColor:(UIColor *)color;
///自定义设置 hud颜色
+ (void)hudColor:(UIColor *)color;
///自定义设置 背景颜色
+ (void)backgroundColor:(UIColor *)color;
///自定义设置 成功图片
+ (void)imageSuccess:(UIImage *)image;
///自定义设置 失败图片
+ (void)imageError:(UIImage *)image;
@end
