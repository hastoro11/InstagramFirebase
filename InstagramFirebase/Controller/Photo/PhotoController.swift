//
//  PhotoController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 07..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "datacell"
private let reuseHeaderIdentifier = "header"

class PhotoController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PhotoSelectorCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        setupBarButtons()
        fetchPhotos()
    }
    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    fileprivate func fetchPhotos() {
        let options = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: options)
        let size = CGSize(width: 200, height: 200)
        DispatchQueue.global(qos: .background).async {
            let requestImageOptions = PHImageRequestOptions()
            requestImageOptions.isSynchronous = true
            result.enumerateObjects { (asset, count, stop) in
                PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestImageOptions, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                    }
                    if self.selectedIndex == nil {
                        self.selectedIndex = count
                    }
                    
                    if count == result.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! PhotoSelectorCell
        if let selectedIndex = selectedIndex {
            PHImageManager.default().requestImage(for: assets[selectedIndex], targetSize: CGSize(width: 600, height: 600), contentMode: .default, options: nil) { (image, info) in
                if let image = image {
                    header.photoImageView.image = image
                }
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoSelectorCell
        let image = images[indexPath.item]
        cell.photoImageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}
