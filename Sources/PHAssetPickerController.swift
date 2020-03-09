import UIKit
import Photos

// MARK: - ImagePickerController

public class PHAssetPickerController: UINavigationController {

    // MARK: - Properties

    public weak var assetPickerControllerDelegate: PHAssetPickerControllerDelegate?
    public var configuration = Configuration()
    public var doneButton = UIBarButtonItem(title: localizedDone,
                                            style: .done,
                                            target: nil,
                                            action: nil)
    public var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                              target: nil,
                                              action: nil)
    public var albumButton = UIButton(type: .custom)
    public var assetStore = AssetStore(assets: [])

    var didSelect: ((_ asset: PHAsset) -> Void)?
    var didDeselect: ((_ asset: PHAsset) -> Void)?
    var didCancelWith: ((_ assets: Set<PHAsset>) -> Void)?
    var didFinishWith: ((_ assets: Set<PHAsset>) -> Void)?
    
    let assetsViewController: AssetsViewController
    let albumsViewController = AlbumsViewController()

    lazy var albums: [PHAssetCollection] = {
        let fetchOptions = self.configuration
                               .fetch
                               .assets
                               .options
                               .copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1

        return self.configuration
                   .fetch
                   .album
                   .fetchResults
                   .filter { $0.count > 0 }
                   .flatMap { $0.objects(at: IndexSet(integersIn: 0 ..< $0.count)) }
                   .filter { PHAsset.fetchAssets(in: $0, options: fetchOptions).count > 0 }
    }()

    public init() {
        self.assetsViewController = AssetsViewController(store: self.assetStore)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.albumsViewController
            .configuration = self.configuration
        self.assetsViewController
            .configuration = self.configuration

        self.albumsViewController
            .delegate = self
        self.assetsViewController
            .delegate = self
        
        self.viewControllers = [self.assetsViewController]

        let firstViewController = self.viewControllers.first
        self.albumButton
            .setTitleColor(self.albumButton.tintColor,
                           for: .normal)
        self.albumButton
            .titleLabel?
            .font = .systemFont(ofSize: 16)
        self.albumButton
            .titleLabel?
            .adjustsFontSizeToFitWidth = true

        self.albumButton
            .semanticContentAttribute = .forceRightToLeft
        self.albumButton
            .addTarget(self,
                       action: #selector(PHAssetPickerController.albumsButtonPressed(_:)),
                       for: .touchUpInside)
        firstViewController?.navigationItem
                            .titleView = self.albumButton

        self.doneButton
            .target = self
        self.doneButton
            .action = #selector(self.doneButtonPressed(_:))
        firstViewController?.navigationItem
            .rightBarButtonItem = self.doneButton

        self.cancelButton
            .target = self
        self.cancelButton
            .action = #selector(self.cancelButtonPressed(_:))
        firstViewController?.navigationItem
            .leftBarButtonItem = self.cancelButton
        
        self.updatedDoneButton()
        self.updateAlbumButton()

        if let firstAlbum = self.albums.first {
            self.select(album: firstAlbum)
        }
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.assetStore
            .assets
            .forEach {
                self.assetsViewController
                    .unselect(asset: $0)
        }
        self.assetStore
            .removeAll()

        self.updatedDoneButton()
        self.updateAlbumButton()
    }

    func updatedDoneButton() {
        self.doneButton
            .title = self.assetStore.count > 0
                   ? Self.localizedDone + " (\(self.assetStore.count))"
                   : Self.localizedDone
      
        self.doneButton
            .isEnabled = self.assetStore
                             .count >= self.configuration
                                           .selection
                                           .min
    }

    func updateAlbumButton() {
        self.albumButton
            .isHidden = self.albums
                            .count < 2
    }

    private static let UIKitBundle = Bundle(for: UIViewController.self)
    private static let localizedDone = UIKitBundle.localizedString(forKey: "Done",
                                                                   value: "Done",
                                                                   table: "")
}
