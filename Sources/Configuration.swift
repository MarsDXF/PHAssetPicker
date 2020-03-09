import UIKit
import Photos

public class Configuration {

    public class Theme {
        /// What color to fill the circle with
        public lazy var selectionFillColor: UIColor = UIView().tintColor
        /// Color for the actual selection icon
        public lazy var selectionStrokeColor: UIColor = .white
        /// Shadow color for the circle
        public lazy var selectionShadowColor: UIColor = .black
        
        public enum SelectionStyle {
            case checked
            case numbered
        }
        
        /// The icon to display inside the selection oval
        public lazy var selectionStyle: SelectionStyle = .checked
    }

    public class Selection {
        /// Max number of selections allowed
        public lazy var max: Int = Int.max
        
        /// Min number of selections you have to make
        public lazy var min: Int = 1
        
        /// If it reaches the max limit, unselect the first selection, and allow the new selection
        public lazy var unselectOnReachingMax : Bool = false
    }

    public class List {
        /// How much spacing between cells
        public lazy var spacing: CGFloat = 2
        
        /// How many cells per row
        public lazy var cellsPerRow: (_ verticalSize: UIUserInterfaceSizeClass,
            _ horizontalSize: UIUserInterfaceSizeClass) -> Int = {
                (verticalSize: UIUserInterfaceSizeClass,
                horizontalSize: UIUserInterfaceSizeClass) -> Int in
                switch (verticalSize, horizontalSize) {
                case (.compact, .regular): // iPhone5-6 portrait
                    return 3
                case (.compact, .compact): // iPhone5-6 landscape
                    return 5
                case (.regular, .regular): // iPad portrait/landscape
                    return 7
                default:
                    return 3
                }
        }
    }

    public class Fetch {
        public class Album {
            /// Fetch options for albums/collections
            public lazy var options: PHFetchOptions = {
                let fetchOptions = PHFetchOptions()
                return fetchOptions
            }()

            /// Fetch results for asset collections you want to present to the user
            /// Some other fetch results that you might wanna use:
            ///  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: options),
            ///  PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options),
            ///  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: options),
            ///  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: options),
            ///  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: options),
            public lazy var fetchResults: [PHFetchResult<PHAssetCollection>] = [
                PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                        subtype: .albumCloudShared,
                                                        options: options),
            ]
        }

        public class Assets {
            /// Fetch options for assets

            /// Simple wrapper around PHAssetMediaType to ensure we only expose the supported types.
            public enum MediaTypes {
                case image
                case video

                fileprivate var assetMediaType: PHAssetMediaType {
                    switch self {
                    case .image:
                        return .image
                    case .video:
                        return .video
                    }
                }
            }
            public lazy var supportedMediaTypes: Set<MediaTypes> = [.image]

            public lazy var options: PHFetchOptions = {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]

                let rawMediaTypes = supportedMediaTypes.map { $0.assetMediaType.rawValue }
                let predicate = NSPredicate(format: "mediaType IN %@", rawMediaTypes)
                fetchOptions.predicate = predicate

                return fetchOptions
            }()
        }

        public class Preview {
            public lazy var photoOptions: PHImageRequestOptions = {
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true

                return options
            }()

            public lazy var livePhotoOptions: PHLivePhotoRequestOptions = {
                let options = PHLivePhotoRequestOptions()
                options.isNetworkAccessAllowed = true
                return options
            }()

            public lazy var videoOptions: PHVideoRequestOptions = {
                let options = PHVideoRequestOptions()
                options.isNetworkAccessAllowed = true
                return options
            }()
        }

        /// Album fetch configuration
        public lazy var album = Album()
        
        /// Asset fetch configuration
        public lazy var assets = Assets()

        /// Preview fetch configuration
        public lazy var preview = Preview()
    }

    /// Theme configuration
    public lazy var theme = Theme()
    
    /// Selection configuration
    public lazy var selection = Selection()
    
    /// List configuration
    public lazy var list = List()
    
    /// Fetch configuration
    public lazy var fetch = Fetch()

    public static let shared = Configuration()
}
