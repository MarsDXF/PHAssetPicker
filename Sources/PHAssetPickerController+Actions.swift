import UIKit

extension PHAssetPickerController {
    @objc
    func albumsButtonPressed(_ sender: UIButton) {
        self.albumsViewController
            .albums = self.albums

        self.present(self.albumsViewController,
                     animated: true)
    }

    @objc
    func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.assetPickerControllerDelegate?
            .imagePicker(self,
                         didFinishWithAssets: self.assetStore
                                                  .assets)
        self.dismiss(animated: true)
    }

    @objc
    func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.assetPickerControllerDelegate?
            .imagePicker(self,
                         didCancelWithAssets: self.assetStore
                                                  .assets)
        self.dismiss(animated: true)
    }
}
