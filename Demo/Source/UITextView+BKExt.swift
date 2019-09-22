//
//  UITextView+BKExt.swift
//  Brickyard
//
//  Created by lam on 2019/8/31.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - 扩展 UITextView，添加 placeholder 和 字数限制功能。
/*
 1、使用 SnapKit 进行布局。
 2、使用 objc/runtime 动态添加了 bk_placeholderLabel 等属性
 */
public extension UITextView {
    
    private struct Keys {
        static let bk_placeholderLabelKey = UnsafeRawPointer("bk_placeholderLabelKey")
        static let bk_placeholderKey = UnsafeRawPointer("bk_placeholderKey")
        static let bk_attributedTextKey = UnsafeRawPointer("bk_attributedTextKey")
        static let bk_wordCountLabelKey = UnsafeRawPointer("bk_wordCountLabelKey")
        static let bk_maxWordCountKey = UnsafeRawPointer("bk_maxWordCountKey")
    }
    
    /// 移除监听
    func bk_removeAllObservers() -> () {
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    /// bk_placeholder Label
    var bk_placeholderLabel: UILabel? {
        set{
            objc_setAssociatedObject(self, Keys.bk_placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            let obj =  objc_getAssociatedObject(self, Keys.bk_placeholderLabelKey) as? UILabel
            guard let placeholderLabel = obj else {
                let label = UILabel()
                label.numberOfLines = 0
                label.font = self.font
                label.textColor = UIColor.lightGray
                label.isUserInteractionEnabled = false
                label.translatesAutoresizingMaskIntoConstraints = false
                addSubview(label)
                // 添加约束。要约束宽，否则可能导致label不换行。
                addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 7)) 
                addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))                 
                addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1.0, constant: -14))
                addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 1.0, constant: -24))
                // 设置bk_placeholderLabel，自动调用set方法
                self.bk_placeholderLabel = label
                
                NotificationCenter.default.addObserver(self, selector: #selector(bk_textDidChange), name: UITextView.textDidChangeNotification, object: self)
                
                return label
            }
            return placeholderLabel
        }
    }
    
    /// bk_placeholder
    var bk_placeholder: String? {
        set {
            objc_setAssociatedObject(self, Keys.bk_placeholderKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let placeholder = newValue else { return }
            self.bk_placeholderLabel?.text = placeholder
        }
        get {
            return  objc_getAssociatedObject(self, Keys.bk_placeholderKey) as? String
        }
    }
    
    /// bk_placeholderAttributedText
    var bk_placeholderAttributedText: NSAttributedString? {
        set {
            objc_setAssociatedObject(self, Keys.bk_attributedTextKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let attr = newValue else { return }
            self.bk_placeholderLabel?.attributedText = attr
        }
        get {
            return  objc_getAssociatedObject(self, Keys.bk_attributedTextKey) as? NSAttributedString
        }
    }
    
    /// 字数的Label
    var bk_wordCountLabel: UILabel? {
        set{
            // 调用 setter 的时候会执行此处代码，将自定义的label通过runtime保存起来
            objc_setAssociatedObject(self, Keys.bk_wordCountLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            let obj =  objc_getAssociatedObject(self, Keys.bk_wordCountLabelKey) as? UILabel
            guard let wordCountLabel = obj else {
                let label = UILabel()
                label.textAlignment = .right
                label.font = self.font
                label.textColor = UIColor.lightGray
                label.isUserInteractionEnabled = false
                
                // 添加到视图中
                if let grandfatherView = self.superview {
                    // 这里添加到 self.superview。如果添加到self，发现自动布局效果不理想。
                    grandfatherView.addSubview(label)
                    
                    label.translatesAutoresizingMaskIntoConstraints = false
                    
                    grandfatherView.addConstraint(NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -7)) 
                    grandfatherView.addConstraint(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -7))
                } else {
                    print("请先将您的UITextView添加到视图中")
                }
                
                // 调用setter
                self.bk_wordCountLabel = label
                
                NotificationCenter.default.addObserver(self, selector: #selector(bk_maxWordCountAction), name: UITextView.textDidChangeNotification, object: self)
                
                return label
            }
            return wordCountLabel
        }
    }
    
    /// 限制的字数
    var bk_maxWordCount: NSNumber? {
        set {
            objc_setAssociatedObject(self, Keys.bk_maxWordCountKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let count = newValue?.intValue else { return }
            guard let label = self.bk_wordCountLabel else { return }
            label.text = "\(self.text.count)/\(count)"
            
        }
        get {
            return  objc_getAssociatedObject(self, Keys.bk_maxWordCountKey) as? NSNumber
        }
    }
    
    @objc private func bk_maxWordCountAction() -> () {
        
        guard let maxCount = self.bk_maxWordCount else { return }
        if self.text.count > maxCount.intValue {
            /// 输入的文字超过最大值
            self.text = (self.text as NSString).substring(to: maxCount.intValue)
            print("已经超过限制的字数了！");
        }
    }
    
    /// text 长度发生了变化
    @objc private func bk_textDidChange() -> () {
        
        if let placeholderLabel = self.bk_placeholderLabel {
            placeholderLabel.isHidden = (self.text.count > 0)
        }
        
        if let wordCountLabel = self.bk_wordCountLabel {
            guard let count = self.bk_maxWordCount?.intValue else { return }
            wordCountLabel.text = "\(self.text.count)/\(count)"
        }
        
    }
}
