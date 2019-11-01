//
//  Brickyard.swift
//  Demo
//
//  Created by lam on 2019/11/1.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

class Brickyard {
    
}

// MARK: - utils for Dictionary
extension Brickyard {
    
    /// 替换源字典的key
    /// - Parameter dic: 源字典 [String : Any]
    /// - Parameter mapArray: 数组 [[oldkey : newKey]]
    static func replaceDictionaryKeys(_ dic: [String : Any], by mapArray: [[String: String]]) -> [String : Any] {
        
        var newDic = dic
        // 遍历mapArray
        mapArray.forEach { (mapDic) in
            
            mapDic.forEach { (mapKey, mapValue) in
                // mapKey:将被替换的key, mapValue: 新key.
                
                // 遍历源字典
                dic.forEach { (dKey, dValue) in
                    
                    if mapKey == dKey {
                        newDic[mapValue as String] = dValue
                        newDic.removeValue(forKey: dKey)
                    }
                }                
            }
        }
        return newDic
    }
}
