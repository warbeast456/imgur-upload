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

private let reuseImgCellIdentifier = "GalleryImgCellIdentifier"

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let imgur = ImgurUploader(clientID: "2d9997b6ad1dbe4")
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseImgCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        getPhotos()
//        self.collectionView!.reloadData()
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewwidth = view.frame.width
        let cellsPerLine = (UIDevice.current.orientation == UIDeviceOrientation.portrait) ? 3 : 5
        let cellsPerLineFloat = CGFloat(cellsPerLine)
        let spacing = (cellsPerLineFloat - 1)
        
        let cellWidth = (viewwidth - spacing) / cellsPerLineFloat
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseImgCellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.ImageView.image = imageArray[indexPath.row]

        return cell
    }
    
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
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        print("selected \(indexPath)")
        selectedCell.startProgressAnimation()
        upload(image: selectedCell.ImageView.image!)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func upload(image: UIImage) {
        var imgUrl: URL? = nil
        imgur.upload(image, completion: { result in
            switch result {
            case .success(let response):
                imgUrl = response.link
                print(imgUrl)
            case .failure(let error):
                print("Upload failed: \(error)")
            }
        })
        
    }
}
