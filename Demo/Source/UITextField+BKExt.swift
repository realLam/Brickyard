//
//  UITextField+BKExt.swift
//  Brickyard
//
//  Created by lam on 2019/8/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - UITextField 扩展，添加闭包监听text
extension UITextField {
        
    private struct BKKeys {
        static let textFieldBlock = UnsafeRawPointer("textFieldBlock")
    }
    
    private var block: ((UITextField) -> ())?{
        set{
            guard let block = newValue else { return }
            objc_setAssociatedObject(self, BKKeys.textFieldBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, BKKeys.textFieldBlock) as? (UITextField) -> ()) ?? nil
        }
    }
    
    @objc private func textAction(_ sender: UITextField){
        self.block?(sender)
    }
    
    /// 用闭包方式，监听text
    ///
    /// - Parameter action: 闭包
    func bk_addTarget(_ action: @escaping (UITextField) -> ()) {
        self.block = action
        addTarget(self, action: #selector(textAction(_:)), for: .editingChanged)
    }
}
