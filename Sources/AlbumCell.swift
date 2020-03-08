import UIKit
import SnapKit

final class AlbumCell: UITableViewCell {

    let albumImageView = UIImageView(frame: .zero)
    let albumTitleLabel = UILabel(frame: .zero)

    override var isSelected: Bool {
        didSet {
            self.accessoryType = self.isSelected
                               ? .checkmark
                               : .none
        }
    }

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionStyle = .none
        self.albumImageView
            .image = nil
        self.albumTitleLabel
            .text = nil
    }

    private func setupUI() {
        self.selectionStyle = .none
        self.albumImageView
            .translatesAutoresizingMaskIntoConstraints = false
        self.albumImageView
            .contentMode = .scaleAspectFill
        self.albumImageView
            .clipsToBounds = true
        self.contentView
            .addSubview(self.albumImageView)

        self.albumTitleLabel
            .translatesAutoresizingMaskIntoConstraints = false
        self.albumTitleLabel
            .numberOfLines = 0
        
        self.contentView
            .addSubview(self.albumTitleLabel)

        self.albumImageView
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.top
                               .bottom
                               .equalToSuperview()
                               .inset(8)
                constraintMaker.width
                               .height
                               .equalTo(84)
                constraintMaker.leading
                               .equalToSuperview()
                               .inset(8)
        }

        self.albumTitleLabel
            .snp
            .makeConstraints { constraintMaker in
                constraintMaker.leading
                               .equalToSuperview()
                               .inset(100)
                constraintMaker.trailing
                               .top
                               .bottom
                               .equalToSuperview()
        }
    }

    static let identifier = "AlbumCell"
}
