import UIKit
import Photos

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ albumsViewController: AlbumsViewController,
                              didSelectAlbum album: PHAssetCollection)
}

class AlbumsViewController: UIViewController {

    var albums: [PHAssetCollection] = []
    weak var delegate: AlbumsViewControllerDelegate?
    var configuration: Configuration! {
        didSet { self.dataSource?.configuration = self.configuration }
    }

    private var dataSource: AlbumsTableViewDataSource?
    private let tableView = UITableView(frame: .zero,
                                        style: .grouped)
    private let lineView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = .init(albums: self.albums)
        self.dataSource?
            .configuration = self.configuration

        self.setupUI()
    }

    private func setupUI() {
        self.tableView
            .frame = view.bounds
        self.tableView
            .autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.tableView
            .rowHeight = UITableView.automaticDimension
        self.tableView
            .estimatedRowHeight = 100
        self.tableView
            .separatorStyle = .none
        self.tableView
            .sectionHeaderHeight = .leastNormalMagnitude
        self.tableView
            .sectionFooterHeight = .leastNormalMagnitude
        self.tableView
            .showsVerticalScrollIndicator = false
        self.tableView
            .showsHorizontalScrollIndicator = false
        self.tableView
            .register(AlbumCell.self,
                      forCellReuseIdentifier: AlbumCell.identifier)
        self.tableView
            .dataSource = self.dataSource
        self.tableView
            .delegate = self
        self.view
            .addSubview(self.tableView)
    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let album = self.albums[indexPath.row]
        self.delegate?
            .albumsViewController(self,
                                  didSelectAlbum: album)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
