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

// MARK: - utils for Clean Cache
extension Brickyard {
    
    /// 获取缓存大小
    /// - Parameter completionHandler: 结果回调
    class func fileSizeOfCache(completionHandler: @escaping (_ size: String) -> ()) {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        // 取出文件夹下所有文件数组
        guard let fileArr = FileManager.default.subpaths(atPath: cachePath) else { return }
        
        let manager = FileManager.default
        
        // 开启子线程
        DispatchQueue.global().async {
            
            // 快速枚举出所有文件名 计算文件大小
            var size = 0
            for file in fileArr {
                // 把文件名拼接到路径中
                let path = cachePath + "/\(file)"
                // 取出文件属性
                let floder = try! manager.attributesOfItem(atPath: path)
                
                // 用元组取出文件大小属性
                for (key, value) in floder {
                    // 累加文件大小
                    if key == FileAttributeKey.size {
                        size += (value as AnyObject).integerValue
                    }
                }
            }
            
            // 换算
            var str : String = ""
            var realSize : Int = size
            if realSize < 1024  {
                str = str.appendingFormat("%dB", realSize)
            }else if size > 1024 && size < 1024 *  1024  {
                realSize = realSize / 1024
                str = str.appendingFormat("%dKB", realSize)
            }else if size > 1024 * 1024 && size < 1024 *  1024  * 1024  {
                realSize = realSize / 1024 / 1024
                str = str.appendingFormat("%dM", realSize)
            }
            
            // 回到主线程 执行闭包
            DispatchQueue.main.async(execute: {
                completionHandler(str)
            })
        }
    }
    
    
    /// 清空缓存
    /// - Parameter completionHandler: 结果回调
    class func clearCache(completionHandler: @escaping () -> ()) {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        // 取出文件夹下所有文件数组
        guard let fileArr = FileManager.default.subpaths(atPath: cachePath) else { return }
        
        let manager = FileManager.default
        
        // 开启子线程
        DispatchQueue.global().async {
            
            // 遍历删除
            for file in fileArr {
                
                let path = cachePath + "/\(file)"
                
                if manager.fileExists(atPath: path) {
                    do {
                        try manager.removeItem(atPath: path)
                    } catch {
                        
                    }
                }
            }
            
            //回到主线程 执行闭包
            DispatchQueue.main.async(execute: {
                completionHandler()
            })
        }
    }
}
