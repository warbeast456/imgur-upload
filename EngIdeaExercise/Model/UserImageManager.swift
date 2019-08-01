//
//  UserImageManager.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 8/1/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import Foundation
import Photos

class UserImageManager {
    
    static let shared = UserImageManager()
    private init() {}
    
    var images = [UIImage]()
    
    var count: Int {return images.count}
    
    ///Downloads images from device's gallery
    
    public func updatePhotos() {
        let imagegManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for i in 0 ..< fetchResult.count {
                imagegManager.requestImage(for: fetchResult[i],
                                           targetSize: CGSize(width: 200, height: 200),
                                           contentMode: .aspectFill,
                                           options: requestOptions,
                                           resultHandler: { image, error in
                                            guard let img = image else {
                                                return
                                            }
                                            self.images.append(img)
                })
            }
        }
    }
    
}

