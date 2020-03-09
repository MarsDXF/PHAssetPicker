import UIKit
import Photos

protocol AssetsViewControllerDelegate: class {
    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didSelectAsset asset: PHAsset)
    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didDeselectAsset asset: PHAsset)
}

class AssetsViewController: UIViewController {

    weak var delegate: AssetsViewControllerDelegate?
    var configuration: Configuration! {
        didSet {
            self.dataSource?
                .configuration = self.configuration
        }
    }

    private let store: AssetStore
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private var fetchResult = PHFetchResult<PHAsset>() {
        didSet {
            self.dataSource = .init(fetchResult: self.fetchResult,
                                    store: self.store)
        }
    }
    private var dataSource: AssetsCollectionViewDataSource? {
        didSet {
            self.dataSource?
                .configuration = self.configuration
            self.collectionView
                .dataSource = self.dataSource
        }
    }

    private let selectionFeedback = UISelectionFeedbackGenerator()

    init(store: AssetStore) {
        self.store = store
        super.init(nibName: nil,
                   bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCollectionViewLayout(for: self.traitCollection)
    }

    private func setupUI() {
        self.view = self.collectionView
        self.title = " "
        self.view
            .backgroundColor = .groupTableViewBackground
        self.collectionView
            .allowsMultipleSelection = true
        self.collectionView
            .bounces = true
        self.collectionView
            .alwaysBounceVertical = true
        self.collectionView
            .delegate = self
        AssetsCollectionViewDataSource.registerCellIdentifiersForCollectionView(collectionView)
    }

    func showAssets(in album: PHAssetCollection) {
        self.fetchResult = PHAsset.fetchAssets(in: album,
                                               options: configuration.fetch.assets.options)
        self.collectionView
            .reloadData()
        let selections = self.store.assets
        self.syncSelections(selections)
        self.collectionView
            .setContentOffset(.zero,
                              animated: false)
    }

    private func syncSelections(_ assets: Set<PHAsset>) {
        self.collectionView.allowsMultipleSelection = true

        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            self.collectionView
                .deselectItem(at: indexPath,
                              animated: false)
        }

        for asset in assets {
            let index = self.fetchResult.index(of: asset)
            guard index != NSNotFound else { continue }
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.updateSelectionIndexForCell(at: indexPath)
        }
    }

    func unselect(asset: PHAsset) {
        let index = self.fetchResult
                        .index(of: asset)
        guard index != NSNotFound
        else { return }
        let indexPath = IndexPath(item: index,
                                  section: 0)
        self.collectionView
            .deselectItem(at:indexPath,
                          animated: false)

        for indexPath in self.collectionView.indexPathsForSelectedItems ?? [] {
            self.updateSelectionIndexForCell(at: indexPath)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateCollectionViewLayout(for: traitCollection)
    }

    private func updateCollectionViewLayout(for traitCollection: UITraitCollection) {
        guard let collectionViewFlowLayout = self.collectionView
                                                 .collectionViewLayout as? UICollectionViewFlowLayout
        else  { return }

        let itemSpacing = self.configuration
                              .list
                              .spacing
        let itemsPerRow = self.configuration
                              .list
                              .cellsPerRow(traitCollection.verticalSizeClass,
                                           traitCollection.horizontalSizeClass)
        let itemWidth = (self.collectionView
                             .bounds
                             .width - .init(itemsPerRow - 1) * itemSpacing)
                      / .init(itemsPerRow)
        let itemSize = CGSize(width: itemWidth,
                              height: itemWidth)

        collectionViewFlowLayout.minimumLineSpacing = itemSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
        collectionViewFlowLayout.itemSize = itemSize
    }

    private func updateSelectionIndexForCell(at indexPath: IndexPath) {
        guard self.configuration
                  .theme
                  .selectionStyle == .numbered
        else { return }
        guard let cell = self.collectionView
                             .cellForItem(at: indexPath) as? AssetCollectionViewCell
        else { return }

        let asset = self.fetchResult
                        .object(at: indexPath.row)
        cell.selectionIndex = self.store.index(of: asset)
    }
}

extension AssetsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.selectionFeedback.selectionChanged()

        let asset = self.fetchResult
                        .object(at: indexPath.row)
        self.store
            .append(asset)
        self.delegate?
            .assetsViewController(self,
                                  didSelectAsset: asset)

        self.updateSelectionIndexForCell(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        self.selectionFeedback.selectionChanged()
        
        let asset = self.fetchResult
                        .object(at: indexPath.row)
        self.store
            .remove(asset)
        self.delegate?
            .assetsViewController(self,
                                  didDeselectAsset: asset)
        
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            self.updateSelectionIndexForCell(at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard self.store
                  .count < self.configuration
                               .selection
                               .max
                        || self.configuration
                               .selection
                               .unselectOnReachingMax
        else { return false }
        self.selectionFeedback
            .prepare()

        return true
    }
}

extension AssetsViewController: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.fetchResult)
        else { return }

        DispatchQueue.main.async {
            if changes.hasIncrementalChanges {
                self.collectionView
                    .performBatchUpdates({
                    self.fetchResult = changes.fetchResultAfterChanges

                    if let removed = changes.removedIndexes,
                        removed.count > 0 {
                        let removedItems = removed.map { IndexPath(item: $0, section:0) }
                        let removedSelections = self.collectionView
                                                    .indexPathsForSelectedItems?
                                                    .filter { removedItems.contains($0) }
                        removedSelections?.forEach {
                            self.delegate?
                                .assetsViewController(self,
                                                      didDeselectAsset: changes.fetchResultBeforeChanges.object(at: $0.row))
                        }
                        self.collectionView
                            .deleteItems(at: removedItems)
                    }
                    if let inserted = changes.insertedIndexes,
                        inserted.count > 0 {
                        self.collectionView
                            .insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
                    }
                    if let changed = changes.changedIndexes,
                        changed.count > 0 {
                        self.collectionView
                            .reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView
                            .moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                     to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                self.fetchResult = changes.fetchResultAfterChanges
                self.collectionView
                    .reloadData()
            }

            self.syncSelections(self.store.assets)
        }
    }
}
