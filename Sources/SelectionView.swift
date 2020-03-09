import UIKit

class SelectionView: UIView {
    var configuration: Configuration!
    
    var selectionIndex: Int? {
        didSet {
            guard let numberView = icon as? NumberView,
                  let selectionIndex = selectionIndex
            else { return }

            numberView.text = (selectionIndex + 1).description
            self.setNeedsDisplay()
        }
    }
    
    private lazy var icon: UIView = {
        switch configuration.theme.selectionStyle {
        case .checked:
            return CheckmarkView()
        case .numbered:
            return NumberView()
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        let shadow2Offset = CGSize(width: 0.1, height: -0.1);
        let shadow2BlurRadius: CGFloat = 2.5;

        let selectionFrame = bounds;

        let group = selectionFrame.insetBy(dx: 3, dy: 3)

        let selectedOvalPath = UIBezierPath(ovalIn: .init(x: group.minX + floor(group.width * 0.0 + 0.5),
                                                          y: group.minY + floor(group.height * 0.0 + 0.5),
                                                          width: floor(group.width * 1.0 + 0.5) - floor(group.width * 0.0 + 0.5),
                                                          height: floor(group.height * 1.0 + 0.5) - floor(group.height * 0.0 + 0.5)))
        context?.saveGState()
        context?.setShadow(offset: shadow2Offset,
                           blur: shadow2BlurRadius,
                           color: self.configuration
                                      .theme
                                      .selectionShadowColor
                                      .cgColor)
        self.configuration
            .theme
            .selectionFillColor
            .setFill()
        selectedOvalPath.fill()
        context?.restoreGState()
        
        self.configuration
            .theme
            .selectionStrokeColor
            .setStroke()
        selectedOvalPath.lineWidth = 1
        selectedOvalPath.stroke()
        
        let largestSquareInCircleInsetRatio: CGFloat = 0.5 - (0.25 * sqrt(2))
        let dx = group.size.width * largestSquareInCircleInsetRatio
        let dy = group.size.height * largestSquareInCircleInsetRatio
        self.icon.frame = group.insetBy(dx: dx, dy: dy)
        self.icon.tintColor = self.configuration
                                  .theme
                                  .selectionStrokeColor
        self.icon
            .draw(self.icon.frame)
    }
}
