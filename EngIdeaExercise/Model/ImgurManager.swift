//
//  ImgurImageManager.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 8/1/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import Foundation
import ImgurAnonymousAPI


class ImgurManager {
    
    static let shared = ImgurManager()
    private init() {}
    
    private let imgur = ImgurUploader(clientID: "2d9997b6ad1dbe4")

    /// Uploads img to imgur. Sends URL to URLManager
    public func upload(image: UIImage, completion: @escaping (_ result: URL?) -> Void)  {
    

        let uploadGroup = DispatchGroup()
        uploadGroup.enter()
        DispatchQueue.global(qos: .utility).async {
            self.imgur.upload(image, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let imgUrl = response.link
                        completion(imgUrl)
                    case .failure(let error):
                        print("Upload failed: \(error)")
                        completion(nil)
                    }
                }
            })
        }
    }
}
