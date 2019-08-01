//
//  GalleryCollectionViewController.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 7/25/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import UIKit
import Foundation

private let reusableImgCellIdentifier = "GalleryImgCellIdentifier"

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let images = UserImageManager.shared
    let uploader = ImgurManager.shared
    var URLs = URLManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reusableImgCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        images.updatePhotos()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let cellsPerLine = (UIDevice.current.orientation == UIDeviceOrientation.portrait) ? 3 : 5
        let cellsPerLineFloat = CGFloat(cellsPerLine)
        let spacing = cellsPerLineFloat - 1
        
        let cellWidth = (viewWidth - spacing) / cellsPerLineFloat
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserImageManager.shared.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableImgCellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.ImageView.image = images.images[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        guard selectedCell.didUploaded == false else {
            selectedCell.stopProgressAnimation()
            return
        }
        selectedCell.startProgressAnimation()
        uploader.upload(image: selectedCell.ImageView.image!, completion: { result in
            guard let url = result
                else {
                    print("failed to get URL")
                    return
            }
            self.URLs.saved.append(url)
            selectedCell.stopProgressAnimation()
            selectedCell.didUploaded = true
        })
        
    }
}
