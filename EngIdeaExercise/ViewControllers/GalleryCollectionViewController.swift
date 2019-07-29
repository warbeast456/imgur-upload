//
//  GalleryCollectionViewController.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 7/25/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import UIKit
import Photos
import ImgurAnonymousAPI
import Foundation

private let reusableImgCellIdentifier = "GalleryImgCellIdentifier"

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let imgur = ImgurUploader(clientID: "2d9997b6ad1dbe4")
    var imageArray = [UIImage]() {didSet {collectionView.reloadData()}}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reusableImgCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        getPhotos()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewwidth = view.frame.width
        let cellsPerLine = (UIDevice.current.orientation == UIDeviceOrientation.portrait) ? 3 : 5
        let cellsPerLineFloat = CGFloat(cellsPerLine)
        let spacing = (cellsPerLineFloat - 1)
        
        let cellWidth = (viewwidth - spacing) / cellsPerLineFloat
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableImgCellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.ImageView.image = imageArray[indexPath.row]
        return cell
    }
    
    ///Downloads images from device's gallery
    private func getPhotos() {
        let imagegManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imagegManager.requestImage(for: fetchResult[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, error in
                    guard let img = image else {
                        return
                    }
                    self.imageArray.append(img)
                })
            }
        } else {
            //Downloads images on the first start, after photos access is granted
            let retry = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.getPhotos()
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        handleUpload(cell: selectedCell)
    }

    /// Uploads img to imgur. Returns URL or nil if failed
    private func handleUpload(cell: GalleryCollectionViewCell) {
        
        cell.startProgressAnimation()
        let image = cell.ImageView.image!
        var imgUrl: URL? = nil
        
        DispatchQueue.global(qos: .utility).async {
            self.imgur.upload(image, completion: { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        imgUrl = response.link
                        cell.stopProgressAnimation()
                        UserURLCache.save(imgUrl!.absoluteString)
                    case .failure(let error):
                        print("Upload failed: \(error)")
                    }
                }
            })
        }
    }
}
