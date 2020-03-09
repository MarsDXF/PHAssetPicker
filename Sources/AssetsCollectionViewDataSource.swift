import UIKit
import Photos

class AssetsCollectionViewDataSource : NSObject {
    
    var configuration: Configuration!

    private let fetchResult: PHFetchResult<PHAsset>
    private let imageManager = PHCachingImageManager.default()
    private let durationFormatter = DateComponentsFormatter()
    private let store: AssetStore

    private let scale: CGFloat
    private var targetSize: CGSize = .zero
    
    init(fetchResult: PHFetchResult<PHAsset>,
         store: AssetStore,
         scale: CGFloat = UIScreen.main.scale) {
        self.fetchResult = fetchResult
        self.store = store
        self.scale = scale
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = [.pad]
        durationFormatter.allowedUnits = [.minute, .second]
        super.init()
    }
    
    private func loadImage(for asset: PHAsset,
                           in cell: AssetCollectionViewCell?) {
        if let cell = cell, cell.tag != 0 {
            self.imageManager
                .cancelImageRequest(PHImageRequestID(cell.tag))
        }

        if let cell = cell {
            self.targetSize = cell.bounds
                                  .size
                                  .resize(by: self.scale)
        }

        cell?.tag = Int(self.imageManager
                            .requestImage(for: asset,
                                          targetSize: self.targetSize,
                                          contentMode: .aspectFill,
                                          options: self.configuration
                                                       .fetch
                                                       .preview
                                                       .photoOptions) { (image, _) in
                                                        guard let image = image
                                                        else { return }
                                                        cell?.imageView.image = image
        })
    }

    private static let assetCellIdentifier = "AssetCell"
    private static let videoCellIdentifier = "VideoCell"

    static func registerCellIdentifiersForCollectionView(_ collectionView: UICollectionView?) {
        collectionView?.register(AssetCollectionViewCell.self,
                                 forCellWithReuseIdentifier: self.assetCellIdentifier)
        collectionView?.register(VideoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: self.videoCellIdentifier)
    }
}

extension AssetsCollectionViewDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.fetchResult[indexPath.row]
        let areAnimationsEnabled = UIView.areAnimationsEnabled
        let cell: AssetCollectionViewCell

        UIView.setAnimationsEnabled(false)
        if asset.mediaType == .video {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.videoCellIdentifier,
                                                      for: indexPath) as! VideoCollectionViewCell
            let videoCell = cell as! VideoCollectionViewCell
            videoCell.durationLabel.text = durationFormatter.string(from: asset.duration)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.assetCellIdentifier,
                                                      for: indexPath) as! AssetCollectionViewCell
        }
        UIView.setAnimationsEnabled(areAnimationsEnabled)

        cell.accessibilityIdentifier = "Photo \(indexPath.item + 1)"
        cell.accessibilityTraits = UIAccessibilityTraits.button
        cell.isAccessibilityElement = true
        cell.configuration = self.configuration

        self.loadImage(for: asset,
                       in: cell)

        cell.selectionIndex = self.store.index(of: asset)

        return cell
    }

}

extension AssetsCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Touching asset should trigger prefetching
        // And prefetch image for that asset
        indexPaths.forEach {
            let asset = fetchResult[$0.row]
            loadImage(for: asset, in: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {

    }
}
