import Foundation
import Photos

public class AssetStore {

    public private(set) var assets: Set<PHAsset>

    public init(assets: Set<PHAsset> = []) {
        self.assets = assets
    }

    public var count: Int {
        self.assets.count
    }

    func contains(_ asset: PHAsset) -> Bool {
        return self.assets.contains(asset)
    }

    func append(_ asset: PHAsset) {
        self.assets
            .insert(asset)
    }

    func remove(_ asset: PHAsset) {
        self.assets
            .remove(asset)
    }
    
    func removeFirst() -> PHAsset? {
        return self.assets.removeFirst()
    }

    func index(of asset: PHAsset) -> Int? {
        return self.assets
                   .firstIndex(of: asset)?
                   .hashValue
    }

    func removeAll() {
        self.assets = []
    }
}
