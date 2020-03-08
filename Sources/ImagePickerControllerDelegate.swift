import Foundation
import Photos

public protocol ImagePickerControllerDelegate: class {

    func imagePicker(_ imagePicker: ImagePickerController,
                     didSelectAsset asset: PHAsset)
    func imagePicker(_ imagePicker: ImagePickerController,
                     didDeselectAsset asset: PHAsset)
    func imagePicker(_ imagePicker: ImagePickerController,
                     didFinishWithAssets assets: Set<PHAsset>)
    func imagePicker(_ imagePicker: ImagePickerController,
                     didCancelWithAssets assets: Set<PHAsset>)
    func imagePicker(_ imagePicker: ImagePickerController,
                     didReachSelectionLimit count: Int)
}
