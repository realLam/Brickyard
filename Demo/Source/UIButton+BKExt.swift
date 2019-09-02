//
//  UIButton+BKExt.swift
//  Brickyard
//  
//  Created by lam on 2019/8/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - UIButton 扩展，添加闭包监听点击事件
public extension UIButton {
    
    private struct BKKeys {
        static let btnBlock = UnsafeRawPointer("BtnBlock")
    }
    
    private var actionBlock: ((UIButton) -> ())?{
        set{
            guard let block = newValue else { return }
            objc_setAssociatedObject(self, BKKeys.btnBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, BKKeys.btnBlock) as? (UIButton) -> ()) ?? nil
        }
    }
    
    @objc private func clickButton(_ sender: UIButton){
        self.actionBlock?(sender)        
    }
    
    /// 用闭包方式，监听按钮点击
    ///
    /// - Parameter action: 闭包
    func bk_addTarget(_ action: @escaping (UIButton) -> ()) {
        self.actionBlock = action
        addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
    }
}
