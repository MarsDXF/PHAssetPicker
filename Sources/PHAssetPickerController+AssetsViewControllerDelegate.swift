import Foundation
import Photos

extension PHAssetPickerController: AssetsViewControllerDelegate {

    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didSelectAsset asset: PHAsset) {
        defer {
            self.updatedDoneButton()
            self.assetPickerControllerDelegate?
                .imagePicker(self,
                             didSelectAsset: asset)
        }

        guard self.configuration.selection.unselectOnReachingMax
           && self.assetStore.count > self.configuration.selection.max,
              let first = assetStore.removeFirst()
        else { return }

        assetsViewController.unselect(asset: first)
        self.assetPickerControllerDelegate?
            .imagePicker(self,
                         didDeselectAsset: first)
    }

    func assetsViewController(_ assetsViewController: AssetsViewController,
                              didDeselectAsset asset: PHAsset) {
        self.updatedDoneButton()
        self.assetPickerControllerDelegate?
            .imagePicker(self,
                         didDeselectAsset: asset)
    }
    
}
