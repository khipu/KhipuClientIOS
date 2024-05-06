import UIKit
import RxSwift
import KhenshinProtocol

class BankSelectField: BaseField {
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Messages.PERSON, Messages.COMPANY])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private var banksPersonas: [GroupedOption] = []
    private var banksEmpresa: [GroupedOption] = []
    private var imageCache: [String: UIImage] = [:]
    private var isReadyToShow: Bool = false
    public var selectedBank: GroupedOption?
    private var value: String!
    private var selectedIndexPath: IndexPath?

    private let disposeBag = DisposeBag()

    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setupUI() {
        setupSegmentedControl()
        setupCollectionView()

        if let groupedOptions = self.formItem?.groupedOptions, let options = groupedOptions.options {
            banksPersonas = options.filter { $0.tag == Messages.PERSON }
            banksEmpresa = options.filter { $0.tag == Messages.COMPANY }
            downloadImages(for: banksPersonas)
            downloadImages(for: banksEmpresa)
        }
    }


    private func setupSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }

    private func setupCollectionView() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        collectionView.register(BankCell.self, forCellWithReuseIdentifier: BankCell.reuseIdentifier)
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])

        /*collectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }

                let selectedBank = self.segmentedControl.selectedSegmentIndex == 0 ?
                    self.banksPersonas[indexPath.item] :
                    self.banksEmpresa[indexPath.item]
                
                self.value = selectedBank.value
                self.selectedIndexPath = indexPath

                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)*/
    }

    private func downloadImages(for banks: [GroupedOption]) {
        let group = DispatchGroup()

        for bank in banks {
            group.enter()

            if let imageUrl = bank.image, let url = URL(string: imageUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageCache[bank.image ?? ""] = image
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            self.isReadyToShow = true
            self.collectionView.reloadData()
        }
    }


    @objc private func segmentedControlValueChanged() {
        selectedIndexPath = nil
        collectionView.reloadData()
    }

    override func getValue() -> String {
        return self.value
    }

    override func validate() -> Bool {
        guard let text = self.value else { return false }
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension BankSelectField: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isReadyToShow ? (segmentedControl.selectedSegmentIndex == 0 ? banksPersonas.count : banksEmpresa.count) : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankCell.reuseIdentifier, for: indexPath) as? BankCell else {
            return UICollectionViewCell()
        }

        let bank = segmentedControl.selectedSegmentIndex == 0 ? banksPersonas[indexPath.item] : banksEmpresa[indexPath.item]
        let isSelected = indexPath == selectedIndexPath
        cell.configure(with: bank, imageCache: imageCache, isSelected: isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight: CGFloat = 25
        let bank = segmentedControl.selectedSegmentIndex == 0 ? banksPersonas[indexPath.item] : banksEmpresa[indexPath.item]
        let nameLabelHeight: CGFloat = 25
        let containerHeight = nameLabelHeight + defaultHeight

        return CGSize(width: collectionView.frame.width - 20, height: containerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousSelectedIndexPath = selectedIndexPath
        selectedIndexPath = indexPath

        if let previousSelectedIndexPath = previousSelectedIndexPath {
            collectionView.reloadItems(at: [previousSelectedIndexPath, indexPath])
        } else {
            collectionView.reloadItems(at: [indexPath])
        }

        let selectedBank = segmentedControl.selectedSegmentIndex == 0 ? banksPersonas[indexPath.item] : banksEmpresa[indexPath.item]
        self.value = selectedBank.value
    }
}

class BankCell: UICollectionViewCell {
    static let reuseIdentifier = "BankCell"

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            nameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(with bank: GroupedOption, imageCache: [String: UIImage], isSelected: Bool) {
        if let cachedImage = imageCache[bank.image ?? ""] {
            imageView.image = cachedImage
        }

        nameLabel.text = bank.name
        containerView.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.lightGray.cgColor
        containerView.layer.backgroundColor =  isSelected ? UIColor(red: 0.592, green: 0.764, blue: 0.941, alpha: 1.0).cgColor : UIColor.white.cgColor
    }
}
