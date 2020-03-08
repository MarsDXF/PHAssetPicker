import Foundation
import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    var colors: [UIColor]? {
        get {
            let layerColors = self.layer.colors as? [CGColor]
            return layerColors?.map { .init(cgColor: $0) }
        } set {
            self.layer
                .colors = newValue?.map { $0.cgColor }
        }
    }
    
    open var locations: [NSNumber]? {
        get {
            return self.layer.locations
        } set {
            self.layer.locations = newValue
        }
    }
}
