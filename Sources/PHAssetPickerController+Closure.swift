import UIKit
import Photos

extension UIViewController {
    
    /// Present a image picker
    ///
    /// - Parameters:
    ///   - assetPicker: The image picker to present
    ///   - animated: Should presentation be animated
    ///   - select: Selection callback
    ///   - deselect: Deselection callback
    ///   - cancel: Cancel callback
    ///   - finish: Finish callback
    ///   - completion: Presentation completion callback
    public func presentPHAssetPicker(_ assetPicker: PHAssetPickerController,
                                     animated: Bool = true,
                                     select: ((_ asset: PHAsset) -> Void)?,
                                     deselect: ((_ asset: PHAsset) -> Void)?,
                                     cancel: ((Set<PHAsset>) -> Void)?,
                                     finish: ((Set<PHAsset>) -> Void)?,
                                     completion: (() -> Void)? = nil) {
        self.authorize {
            assetPicker.didSelect = select
            assetPicker.didDeselect = deselect
            assetPicker.didCancelWith = cancel
            assetPicker.didFinishWith = finish

            assetPicker.assetPickerControllerDelegate = assetPicker

            self.present(assetPicker,
                         animated: animated,
                         completion: completion)
        }
    }

    private func authorize(_ authorized: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async(execute: authorized)
            default:
                break
            }
        }
    }
}

extension PHAssetPickerController {
    public static var currentAuthorization : PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus()
    }
}

extension PHAssetPickerController: PHAssetPickerControllerDelegate {
    public func imagePicker(_ imagePicker: PHAssetPickerController,
                            didSelectAsset asset: PHAsset) {
        self.didSelect?(asset)
    }

    public func imagePicker(_ imagePicker: PHAssetPickerController,
                            didDeselectAsset asset: PHAsset) {
        self.didDeselect?(asset)
    }

    public func imagePicker(_ imagePicker: PHAssetPickerController,
                            didFinishWithAssets assets: Set<PHAsset>) {
        self.didFinishWith?(assets)
    }

    public func imagePicker(_ imagePicker: PHAssetPickerController,
                            didCancelWithAssets assets: Set<PHAsset>) {
        self.didCancelWith?(assets)
    }

    public func imagePicker(_ imagePicker: PHAssetPickerController,
                            didReachSelectionLimit count: Int) {
        
    }
}
