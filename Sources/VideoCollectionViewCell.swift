import UIKit
import SnapKit

class VideoCollectionViewCell: AssetCollectionViewCell {

    let gradientView = GradientView(frame: .zero)
    let durationLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.gradientView
            .translatesAutoresizingMaskIntoConstraints = false
        self.imageView
            .addSubview(self.gradientView)
        self.gradientView
            .colors = [.clear, .black]
        self.gradientView
            .locations = [0.0 , 0.7]

        self.gradientView
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.height
                               .equalTo(30)
                constraintMaker.leading
                               .trailing
                               .top
                               .equalToSuperview()
        }

        self.durationLabel
            .textAlignment = .right
        self.durationLabel
            .text = "0:03"
        self.durationLabel
            .textColor = .white
        self.durationLabel
            .font = UIFont.boldSystemFont(ofSize: 12)
        self.durationLabel
            .translatesAutoresizingMaskIntoConstraints = false
        self.gradientView
            .addSubview(self.durationLabel)

        self.durationLabel
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.top
                               .bottom
                               .equalToSuperview()
                               .inset(4)
                constraintMaker.leading
                               .trailing
                               .equalToSuperview()
                               .inset(8)
        }

    }
}
