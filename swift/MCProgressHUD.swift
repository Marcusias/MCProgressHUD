//
//  MCProgressHUD.swift
//  app
//
//  Created by Marcus on 2017/12/5.
//  Copyright © 2017年 KZ. All rights reserved.
//

import UIKit

class MCProgressHUD: UIView {
    @objc private var currentWindow:UIWindow?
    private var viewBackground:UIView?
    private var toolbarHUD:UIToolbar?
    private var spinner:UIActivityIndicatorView?
    private var imageView:UIImageView?
    private var labelTitle:UILabel?
    private var titleFont: UIFont?
    private var titleColor: UIColor?
    private var spinnerColor: UIColor?
    private var hudColor: UIColor?
    private var hudBackgroundColor: UIColor?
    private var imageSuccess: UIImage?
    private var imageError: UIImage?

    static let shared = MCProgressHUD.init()
    //MARK: Display methods
    class func hideHUD() {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudHide()
        })
    }
    
    ///显示菊花
    class func show() {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate("", showImage: false, image:UIImage(), spin: true, hide: false, interaction: true)
            print("%@",self.shared)
        })
    }

    ///显示带文字的菊花,其他仍可交互
    class func show(_ title: String) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: false, image: UIImage(), spin: true, hide: false, interaction: true)
            print("%@",self.shared)
        })
    }
    ///显示带文字的菊花,其他交互可自定义
    class func show(_ title: String, interaction: Bool) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: false, image:UIImage(), spin: true, hide: false, interaction: interaction)
        })
    }
    class func showSuccess() {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate("", showImage: true, image: self.shared.imageSuccess!, spin: false, hide: true, interaction: true)
        })
    }
    
    ///显示图片加文字的成功,其他仍可交互
    class func showSuccess(_ title: String) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: true, image: self.shared.imageSuccess!, spin: false, hide: true, interaction: true)
        })
    }
    class func showSuccess(_ title: String, interaction: Bool) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: true, image: self.shared.imageSuccess!, spin: false, hide: true, interaction: interaction)
        })
    }
    
    //显示一个只有图片的失败
    class func showError() {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate("", showImage: true, image: self.shared.imageError!, spin: false, hide: true, interaction: true)
        })
    }
    
    ///显示图片加文字的失败,其他仍可交互
    
    class func showError(_ title: String) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: true, image: self.shared.imageError!, spin: false, hide: true, interaction: true)
        })
    }
    
    ///显示图片加文字的失败,其他交互自定义
    class func showError(_ title: String, interaction: Bool) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(title, showImage: true, image: self.shared.imageError!, spin: false, hide: true, interaction: interaction)
        })
    }
    ///显示一个只有文字的提示,其他仍可交互
    
    class func showMessage(_ message: String) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(message, showImage: false, image:UIImage(), spin: false, hide: true, interaction: true)
        })
    }
    
    ///显示一个只有文字提示,交互性可自定义
    class func showMessage(_ message: String, interaction: Bool) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.shared.hudCreate(message, showImage: false, image: UIImage(), spin: false, hide: true, interaction: true)
        })
    }
    
    // MARK: - Property methods
    ///自定义设置 文字字体
    class func titleFont(_ font: UIFont) {
        self.shared.titleFont = font
    }
    ///自定义设置 文字颜色
    class func titleColor(_ color: UIColor) {
        self.shared.titleColor = color
    }
    ///自定义设置 菊花颜色
    class func spinnerColor(_ color: UIColor) {
        self.shared.spinnerColor = color
    }
    ///自定义设置 hud颜色
    class func hudColor(_ color: UIColor) {
        self.shared.hudColor = color
    }
    ///自定义设置 背景颜色
    class func backgroundColor(_ color: UIColor) {
        self.shared.backgroundColor = color
    }
    ///自定义设置 成功图片
    class func imageSuccess(_ image: UIImage) {
        self.shared.imageSuccess = image
    }
    class func imageError(_ image: UIImage) {
        self.shared.imageError = image
    }
    // MARK: -
    /// 初始化
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        titleFont = UIFont.boldSystemFont(ofSize: 16)
        titleColor = UIColor.black
        spinnerColor = UIColor.gray
        hudColor = UIColor(white: 0.0, alpha: 0.1)
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        let bundle = Bundle(for: MCProgressHUD.self)
        imageSuccess = UIImage(named: "MCProgressHUD.bundle/img_success", in: bundle, compatibleWith: nil)
        imageError = UIImage(named: "MCProgressHUD.bundle/img_failture", in: bundle, compatibleWith: nil)
        currentWindow = UIApplication.shared.keyWindow
        viewBackground = nil
        toolbarHUD = nil
        spinner = nil
        imageView = nil
        labelTitle = nil
        alpha = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     创建toats
     @param status 文字内容
     @param image 图片
     @param spin 是否旋转
     @param hide 隐藏
     @param interaction 交互开关
     */
    private func hudCreate(_ status: String,showImage:Bool,image: UIImage, spin: Bool, hide: Bool, interaction: Bool) {
        if toolbarHUD == nil {
            toolbarHUD = UIToolbar(frame: CGRect.zero)
            toolbarHUD?.isTranslucent = true
            toolbarHUD?.backgroundColor = hudColor
            toolbarHUD?.layer.cornerRadius = 10
            toolbarHUD?.layer.masksToBounds = true
        }
        if toolbarHUD?.superview == nil {
            if interaction == false {
                viewBackground = UIView(frame:self.currentWindow?.frame ?? CGRect.zero)
                viewBackground?.backgroundColor = backgroundColor
                currentWindow?.addSubview(viewBackground ?? UIView())
                viewBackground?.addSubview(toolbarHUD ?? UIView())
            }
            else {
                currentWindow?.addSubview(toolbarHUD ?? UIView())
            }
        }
        if spinner == nil {
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinner?.color = spinnerColor
            spinner?.hidesWhenStopped = true
        }
        if spinner?.superview == nil {
            toolbarHUD?.addSubview(spinner ?? UIView())
        }
        if imageView == nil && showImage {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            imageView?.isHidden = !showImage
            imageView?.image = image
        }
        if imageView?.superview == nil && showImage {
            toolbarHUD?.addSubview(imageView ?? UIView())
        }
        if labelTitle == nil {
            labelTitle = UILabel(frame: CGRect.zero)
            labelTitle?.font = titleFont!
            labelTitle?.textColor = titleColor ?? UIColor.clear
            labelTitle?.backgroundColor = UIColor.clear
            labelTitle?.textAlignment = .center
            labelTitle?.baselineAdjustment = .alignCenters
            labelTitle?.numberOfLines = 0
        }
        if labelTitle?.superview == nil && status.count > 0{
            toolbarHUD?.addSubview(labelTitle ?? UIView())
        }
        labelTitle?.text = status
        labelTitle?.isHidden = (status.count < 1) ? true : false
        if spin {
            spinner?.startAnimating()
        }
        else {
            spinner?.stopAnimating()
        }
        hudSize(with: image, spin: spin, showImage: showImage)
        hudShow()
        if hide {
            timedHide()
        }
    }
    ///销毁 HUD
    private func hudDestroy() {
        NotificationCenter.default.removeObserver(self)
        labelTitle?.removeFromSuperview()
        labelTitle = nil
        imageView?.removeFromSuperview()
        imageView = nil
        spinner?.removeFromSuperview()
        spinner = nil
        toolbarHUD?.removeFromSuperview()
        toolbarHUD = nil
        viewBackground?.removeFromSuperview()
        viewBackground = nil
    }
    // MARK: -
    /**
     progressHUD 布局调整
     */
    private func hudSize(with image: UIImage, spin: Bool, showImage:Bool) {
        var rectLabel: CGRect = CGRect.zero
        var widthHUD: CGFloat = 100
        var heightHUD: CGFloat = 100
        if (labelTitle?.text?.count)! > 0{
            let attributes = [NSFontAttributeName: labelTitle?.font]
            let options: NSStringDrawingOptions = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
            rectLabel = labelTitle?.text?.boundingRect(with: CGSize(width: 200, height: 300), options: options, attributes: attributes as Any as? [String : Any] , context: nil) ?? CGRect.zero
            widthHUD = rectLabel.size.width + 50
            heightHUD = (spin == false && !showImage) ? rectLabel.size.height + 50 : rectLabel.size.height + 75
            if widthHUD < 100 {
                widthHUD = 100
            }
            if heightHUD < 100 && !(spin == false && !showImage) {
                heightHUD = 100
            }
            rectLabel.origin.x = (widthHUD - rectLabel.size.width) / 2
            rectLabel.origin.y = (spin == false && !showImage) ? (heightHUD - rectLabel.size.height) / 2 : (heightHUD - rectLabel.size.height) / 2 + 25
        }
        toolbarHUD?.bounds = CGRect(x: 0, y: 0, width: widthHUD, height: heightHUD)
        let imageX: CGFloat = widthHUD / 2
        let imageY: CGFloat = ((labelTitle?.text?.count)! < 1) ? heightHUD / 2 : 36
        spinner?.center = CGPoint(x: imageX, y: imageY)
        imageView?.center = (spinner?.center)!
        imageView?.isHidden = !showImage
        labelTitle?.frame = rectLabel
    }
    // MARK: -
    ///显示hud
    private func hudShow() {
        if self.alpha == 0 {
            self.alpha = 1
            let screen: CGRect = UIScreen.main.bounds
            let center = CGPoint(x: screen.size.width / 2, y: (screen.size.height) / 2)
            toolbarHUD?.center = CGPoint(x: center.x, y: center.y)
            toolbarHUD?.alpha = 0
            toolbarHUD?.transform = (toolbarHUD?.transform.scaledBy(x: 1.4, y: 1.4))!
            let options: UIViewAnimationOptions = [.allowUserInteraction, .curveEaseOut]
            UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: {() -> Void in
                self.toolbarHUD?.transform = (self.toolbarHUD?.transform.scaledBy(x: 1 / 1.4, y: 1 / 1.4))!
                self.toolbarHUD?.alpha = 1
            }) { _ in }
        }
    }
    
    ///隐藏hud
    private func hudHide() {
        if alpha == 1 {
            let options: UIViewAnimationOptions = [.allowUserInteraction, .curveEaseOut]
            UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: {() -> Void in
                self.toolbarHUD?.transform = (self.toolbarHUD?.transform.scaledBy(x: 0.7, y: 0.7))!
                self.toolbarHUD?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                self.hudDestroy()
                self.alpha = 0
            })
        }
    }
    
    ///定时隐藏hud
    private func timedHide() {
        let delay: TimeInterval = 0.04 * Double((labelTitle?.text?.count)!)  + 0.5
        let time = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline:time , execute: {(_: Void) -> Void in
            self.hudHide()
        })
    }

}
