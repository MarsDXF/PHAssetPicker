import Foundation
import Photos

extension ImagePickerController: AssetsViewControllerDelegate {
    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didSelectAsset asset: PHAsset) {
        defer {
            self.updatedDoneButton()
            self.imagePickerDelegate?
                .imagePicker(self,
                             didSelectAsset: asset)
        }

        guard self.configuration.selection.unselectOnReachingMax
           && self.assetStore.count > self.configuration.selection.max,
              let first = assetStore.removeFirst()
        else { return }

        assetsViewController.unselect(asset: first)
        self.imagePickerDelegate?
            .imagePicker(self,
                         didDeselectAsset: first)
    }

    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didDeselectAsset asset: PHAsset) {
        self.updatedDoneButton()
        self.imagePickerDelegate?
            .imagePicker(self,
                         didDeselectAsset: asset)
    }
}
