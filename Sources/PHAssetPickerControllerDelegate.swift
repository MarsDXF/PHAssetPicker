import Foundation
import Photos

public protocol PHAssetPickerControllerDelegate: class {

    func imagePicker(_ imagePicker: PHAssetPickerController,
                     didSelectAsset asset: PHAsset)
    func imagePicker(_ imagePicker: PHAssetPickerController,
                     didDeselectAsset asset: PHAsset)
    func imagePicker(_ imagePicker: PHAssetPickerController,
                     didFinishWithAssets assets: Set<PHAsset>)
    func imagePicker(_ imagePicker: PHAssetPickerController,
                     didCancelWithAssets assets: Set<PHAsset>)
    func imagePicker(_ imagePicker: PHAssetPickerController,
                     didReachSelectionLimit count: Int)
}
