import UIKit

class NumberView: UILabel {
    
    override var tintColor: UIColor! {
        didSet {
            self.textColor = tintColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)

        self.font = UIFont.boldSystemFont(ofSize: 12)
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect)
    }
}
