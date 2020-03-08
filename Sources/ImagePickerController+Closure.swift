import UIKit
import Photos

extension UIViewController {
    
    /// Present a image picker
    ///
    /// - Parameters:
    ///   - imagePicker: The image picker to present
    ///   - animated: Should presentation be animated
    ///   - select: Selection callback
    ///   - deselect: Deselection callback
    ///   - cancel: Cancel callback
    ///   - finish: Finish callback
    ///   - completion: Presentation completion callback
    public func presentImagePicker(_ imagePicker: ImagePickerController,
                                   animated: Bool = true,
                                   select: ((_ asset: PHAsset) -> Void)?,
                                   deselect: ((_ asset: PHAsset) -> Void)?,
                                   cancel: ((Set<PHAsset>) -> Void)?,
                                   finish: ((Set<PHAsset>) -> Void)?,
                                   completion: (() -> Void)? = nil) {
        self.authorize {
            imagePicker.didSelect = select
            imagePicker.didDeselect = deselect
            imagePicker.didCancelWith = cancel
            imagePicker.didFinishWith = finish

            imagePicker.imagePickerDelegate = imagePicker

            self.present(imagePicker,
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

extension ImagePickerController {
    public static var currentAuthorization : PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus()
    }
}

extension ImagePickerController: ImagePickerControllerDelegate {
    public func imagePicker(_ imagePicker: ImagePickerController,
                            didSelectAsset asset: PHAsset) {
        self.didSelect?(asset)
    }

    public func imagePicker(_ imagePicker: ImagePickerController,
                            didDeselectAsset asset: PHAsset) {
        self.didDeselect?(asset)
    }

    public func imagePicker(_ imagePicker: ImagePickerController,
                            didFinishWithAssets assets: Set<PHAsset>) {
        self.didFinishWith?(assets)
    }

    public func imagePicker(_ imagePicker: ImagePickerController,
                            didCancelWithAssets assets: Set<PHAsset>) {
        self.didCancelWith?(assets)
    }

    public func imagePicker(_ imagePicker: ImagePickerController,
                            didReachSelectionLimit count: Int) {
        
    }
}
