import UIKit

extension CGSize {
    func resize(by scale: CGFloat) -> CGSize {
        return .init(width: self.width * scale,
                     height: self.height * scale)
    }
}
