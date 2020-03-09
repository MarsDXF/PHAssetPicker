import UIKit
import Photos

final class AlbumsTableViewDataSource : NSObject {

    var configuration: Configuration!
    
    private let albums: [PHAssetCollection]
    private let scale: CGFloat
    private let imageManager = PHCachingImageManager.default()
    
    init(albums: [PHAssetCollection],
         scale: CGFloat = UIScreen.main.scale) {
        self.albums = albums
        self.scale = scale
        super.init()
    }
    


    func registerCells(in tableView: UITableView) {
        tableView.register(AlbumCell.self,
                           forCellReuseIdentifier: AlbumCell.identifier)
    }
}


extension AlbumsTableViewDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.albums.count > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier,
                                                 for: indexPath) as? AlbumCell
        else { return .init() }

        let album = self.albums[indexPath.row]

        cell.albumTitleLabel
            .text = album.localizedTitle ?? ""

        let fetchOptions = self.configuration.fetch.assets.options.copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1

        let imageSize = CGSize(width: 84,
                               height: 84).resize(by: self.scale)
        let imageContentMode: PHImageContentMode = .aspectFill

        guard let asset = PHAsset.fetchAssets(in: album,
                                              options: fetchOptions).firstObject
        else { return .init() }

        self.imageManager
            .requestImage(for: asset,
                          targetSize: imageSize, 
                          contentMode: imageContentMode,
                          options: self.configuration
                                       .fetch
                                       .preview
                                       .photoOptions) { image, _ in
                                        guard let image = image
                                        else { return }
                                        cell.albumImageView
                                            .image = image
        }

        return cell
    }
}
