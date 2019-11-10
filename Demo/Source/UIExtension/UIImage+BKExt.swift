//
//  UIImage+BKExt.swift
//  Brickyard
//
//  Created by lam on 2019/9/21.
//

import UIKit
import AVFoundation

extension UIImage {
    
    /// 获取视频的第一帧图像
    ///
    /// - Parameter videoUrl: 视频地址
    /// - Returns: 视频图像
    static func bk_image(fromVideoUrl url: URL) -> UIImage? {
        
        let opt = [AVURLAssetPreferPreciseDurationAndTimingKey: false]; 
        let urlAsset = AVURLAsset(url: url, options: opt)
        let generator = AVAssetImageGenerator(asset: urlAsset)
        generator.appliesPreferredTrackTransform = true      
        let time = CMTimeMake(value: 0, timescale: 10)
        guard let cgImg = try? generator.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: cgImg)
    }
    
}
