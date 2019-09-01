//
//  UITextView+BKExt.swift
//  Brickyard
//
//  Created by lam on 2019/8/31.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SnapKit


// MARK: - 扩展 UITextView，添加 placeholder 和 字数限制功能。
/*
 1、使用 SnapKit 进行布局。
 2、使用 objc/runtime 动态添加了 bk_placeholderLabel 等属性
 */
extension UITextView {
    
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
            let obj =  objc_getAssociatedObject(self, Keys.bk_placeholderLabelKey)
            guard let placeholderLabel = obj else {
                let label = UILabel()
                label.numberOfLines = 0
                label.font = self.font
                label.textColor = UIColor.lightGray
                label.isUserInteractionEnabled = false
                addSubview(label)
                self.bk_placeholderLabel = label
                label.snp.makeConstraints { (make) in
                    make.left.right.top.equalToSuperview().inset(7)
                    make.bottom.equalToSuperview().inset(40)
                    // 宽要比父view小，否则可能会左右滑动
                    make.width.lessThanOrEqualToSuperview().offset(-20)
                }
                NotificationCenter.default.addObserver(self, selector: #selector(bk_textDidChange), name: UITextView.textDidChangeNotification, object: self)
                return label
            }
            return (placeholderLabel as? UILabel)!
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
            let obj =  objc_getAssociatedObject(self, Keys.bk_wordCountLabelKey)
            guard let wordCountLabel = obj else {
                let label = UILabel()
                label.textAlignment = .right
                label.font = self.font
                label.textColor = UIColor.lightGray
                label.isUserInteractionEnabled = false
                // 调用setter
                self.bk_wordCountLabel = label
                // 添加到视图中
                if let grandfatherView = self.superview {
                    // 这里添加到 self.superview。如果添加到self，发现自动布局效果不理想。
                    grandfatherView.addSubview(label)
                    label.snp.makeConstraints { (make) in
                        make.bottom.right.equalTo(self).inset(7)
                    }
                } else {
                    print("请先将您的UITextView添加到视图中")
                }
                NotificationCenter.default.addObserver(self, selector: #selector(bk_maxWordCountAction), name: UITextView.textDidChangeNotification, object: self)
                return label
            }
            return (wordCountLabel as? UILabel)!
        }
    }
    
    /// 限制的字数
    var bk_maxWordCount: NSNumber? {
        set {
            objc_setAssociatedObject(self, Keys.bk_maxWordCountKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let count = newValue else { return }
            self.bk_wordCountLabel?.text = "\(self.text.count)/\(count)"
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
