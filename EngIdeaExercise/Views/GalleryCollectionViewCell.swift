//
//  GalleryCollectionViewCell.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 7/28/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    var ImageView: UIImageView {didSet {setNeedsDisplay()}}
    var ProgressView: UIActivityIndicatorView
    var downloadedStatusImage: UIImageView

    
    override init(frame: CGRect) {
        self.ImageView = UIImageView()
        self.ProgressView = UIActivityIndicatorView()
        self.downloadedStatusImage = UIImageView(image: #imageLiteral(resourceName: "downloaded"))
        super.init(frame: frame)
        backgroundColor = .green
        autoresizesSubviews = true
        setupImageView()
        setupDowloadedStatusImage()
        setupProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        addSubview(ImageView)
        ImageView.anchorTo(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)

    }
    
    func setupDowloadedStatusImage() {
        addSubview(downloadedStatusImage)
        downloadedStatusImage.anchorTo(top: topAnchor, left: nil, bottom: nil, right: rightAnchor)
        downloadedStatusImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        downloadedStatusImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        downloadedStatusImage.alpha = 0
    }
    
    func setupProgressView() {
        addSubview(ProgressView)
        ProgressView.anchorTo(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    ///Starts progress animation
    public func startProgressAnimation() {
        ProgressView.startAnimating()
    }
    
    /// Displays sucsessfull upload, stops progress animation
    public func stopProgressAnimation() {
        ProgressView.stopAnimating()
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.downloadedStatusImage.alpha = 1
                        
        },
                       completion: { finished in
                        UIView.animate(withDuration: 1,
                                       delay: 0,
                                       options: [.curveEaseInOut],
                                       animations: {
                                        self.downloadedStatusImage.alpha = 0
                                        
                        },
                                       completion: { finished in
                        })
        })
    }
    
}
