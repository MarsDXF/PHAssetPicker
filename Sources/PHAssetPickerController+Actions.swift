import UIKit

extension PHAssetPickerController {
    @objc
    func albumsButtonPressed(_ sender: UIButton) {
        self.albumsViewController
            .albums = self.albums

        self.albumsViewController
            .modalPresentationStyle = .popover
        self.albumsViewController
            .preferredContentSize = .init(width:300,
                                          height: 320)
        self.albumsViewController
            .popoverPresentationController?
            .sourceView = sender
        self.albumsViewController
            .popoverPresentationController?
            .delegate = self

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

extension PHAssetPickerController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

}
