import Foundation
import Photos

extension ImagePickerController: AlbumsViewControllerDelegate {
    func didDismissAlbumsViewController(_ albumsViewController: AlbumsViewController) {
        self.rotateButtonArrow()
    }
    
    func albumsViewController(_ albumsViewController: AlbumsViewController,
                              didSelectAlbum album: PHAssetCollection) {
        self.select(album: album)
        albumsViewController.dismiss(animated: true)
    }

    func select(album: PHAssetCollection) {
        self.assetsViewController
            .showAssets(in: album)
        self.albumButton
            .setTitle((album.localizedTitle ?? "") + " ",
                      for: .normal)
        self.albumButton
            .sizeToFit()
    }
}
