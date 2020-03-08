import UIKit

@IBDesignable
public class ImageView: UIView {
    private let imageView: UIImageView = UIImageView(frame: .zero)

    override public var isUserInteractionEnabled: Bool {
        didSet { self.imageView.isUserInteractionEnabled = isUserInteractionEnabled }
    }

    override public var tintColor: UIColor! {
        didSet { self.imageView.tintColor = tintColor }
    }

    override public var contentMode: UIView.ContentMode {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.imageView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if let image = self.imageView.image {
            self.imageView.frame = ImageViewLayout.frameForImageWithSize(image.size,
                                                                    previousFrame: imageView.frame,
                                                                    inContainerWithSize: bounds.size,
                                                                    usingContentMode: contentMode)
        } else {
            self.imageView.frame = .zero
        }
    }
}

// MARK: UIImageView API
extension ImageView {

    public convenience init(image: UIImage?) {
        self.init(frame: .zero)
        self.imageView.image = image
    }

    public convenience init(image: UIImage?, highlightedImage: UIImage?) {
        self.init(frame: .zero)
        self.imageView.image = image
        self.imageView.highlightedImage = highlightedImage
    }

    @IBInspectable
    open var image: UIImage? {
        get { return self.imageView.image }
        set {
            self.imageView.image = newValue
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    @IBInspectable
    open var highlightedImage: UIImage? {
        get { return self.imageView.highlightedImage }
        set {
            self.imageView.highlightedImage = newValue
        }
    }

    @IBInspectable
    open var isHighlighted: Bool {
        get { return self.imageView.isHighlighted }
        set { self.imageView.isHighlighted = newValue }
    }

    open var animationImages: [UIImage]? {
        get { return imageView.animationImages }
        set { self.imageView.animationImages = newValue }
    }

    open var highlightedAnimationImages: [UIImage]? {
        get { return self.imageView.highlightedAnimationImages }
        set { self.imageView.highlightedAnimationImages = newValue }
    }

    open var animationDuration: TimeInterval {
        get { return self.imageView.animationDuration }
        set { self.imageView.animationDuration = newValue }
    }

    open var animationRepeatCount: Int {
        get { return self.imageView.animationRepeatCount }
        set { self.imageView.animationRepeatCount = newValue }
    }

    open func startAnimating() {
        self.imageView.startAnimating()
    }

    open func stopAnimating() {
        self.imageView.stopAnimating()
    }

    open var isAnimating: Bool {
        get { return self.imageView.isAnimating }
    }
}
