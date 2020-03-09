import UIKit
import Photos

class AssetCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = UIImageView(frame: .zero)
    var configuration: Configuration! {
        didSet {
            self.selectionView
                .configuration = self.configuration
        }
    }
    var selectionIndex: Int? {
        didSet {
            self.selectionView
                .selectionIndex = self.selectionIndex
        }
    }

    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected
            else { return }
            
            self.updateAccessibilityLabel(self.isSelected)
            if UIView.areAnimationsEnabled {
                UIView.animate(withDuration: TimeInterval(0.1),
                               animations: { () -> Void in
                    self.updateAlpha(self.isSelected)

                                self.transform = .init(scaleX: 0.95,
                                                       y: 0.95)
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: TimeInterval(0.1),
                                   animations: { () -> Void in
                                    self.transform = .init(scaleX: 1.0,
                                                           y: 1.0)
                    }, completion: nil)
                })
            } else {
                self.updateAlpha(self.isSelected)
            }
        }
    }
    
    private let selectionOverlayView = UIView(frame: .zero)
    private let selectionView = SelectionView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.selectionIndex = nil
    }

    private func setupUI() {
        self.imageView
            .translatesAutoresizingMaskIntoConstraints = false
        self.imageView
            .contentMode = .scaleAspectFill
        self.imageView
            .clipsToBounds = true
        self.selectionOverlayView
            .backgroundColor = .lightGray
        self.selectionOverlayView
            .translatesAutoresizingMaskIntoConstraints = false
        self.selectionView
            .translatesAutoresizingMaskIntoConstraints = false
        self.contentView
            .addSubview(self.imageView)
        self.contentView
            .addSubview(self.selectionOverlayView)
        self.contentView
            .addSubview(self.selectionView)

        self.imageView
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.top
                               .bottom
                               .leading
                               .trailing
                               .equalToSuperview()
        }
        self.selectionOverlayView
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.top
                               .bottom
                               .leading
                               .trailing
                               .equalToSuperview()
        }
        self.selectionView
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.width
                               .height
                               .equalTo(25)
                constraintMaker.top
                               .trailing
                               .equalToSuperview()
                               .inset(4)
        }

        self.updateAlpha(self.isSelected)
        self.updateAccessibilityLabel(self.isSelected)
    }
    
    func updateAccessibilityLabel(_ selected: Bool) {
        self.accessibilityLabel = selected
                                ? "deselect image"
                                : "select image"
    }
    
    private func updateAlpha(_ selected: Bool) {
        if selected {
            self.selectionView.alpha = 1.0
            self.selectionOverlayView.alpha = 0.3
        } else {
            self.selectionView.alpha = 0.0
            self.selectionOverlayView.alpha = 0.0
        }
    }
}
