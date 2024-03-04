import UIKit
import KhenshinProtocol

class BankSelectField: BaseField {

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Persona", "Empresa"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(BankSelectField.self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    private var collectionView: UICollectionView!
    private var banksPersonas: [GroupedOption] = []
    private var banksEmpresa: [GroupedOption] = []
    private var imageCache: [String: UIImage] = [:]
    private var isReadyToShow: Bool = false

    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setupUI() {
        setupSegmentedControl()
        setupCollectionView()

        if let groupedOptions = self.formItem!.groupedOptions, let options = groupedOptions.options {
            banksPersonas = options.filter { $0.tag == "Persona" }
            banksEmpresa = options.filter { $0.tag == "Empresa" }
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
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(BankCell.self, forCellWithReuseIdentifier: BankCell.reuseIdentifier)
        addSubview(collectionView)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
                        print("Error al cargar la imagen desde la URL: \(url)")
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
        collectionView.reloadData()
    }
}

extension BankSelectField: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard isReadyToShow else { return 0 }
        return segmentedControl.selectedSegmentIndex == 0 ? banksPersonas.count : banksEmpresa.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankCell.reuseIdentifier, for: indexPath) as? BankCell else {
            return UICollectionViewCell()
        }

        let bank = segmentedControl.selectedSegmentIndex == 0 ? banksPersonas[indexPath.item] : banksEmpresa[indexPath.item]
        cell.configure(with: bank, imageCache: imageCache)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBank = segmentedControl.selectedSegmentIndex == 0 ? banksPersonas[indexPath.item] : banksEmpresa[indexPath.item]
        print("Celda seleccionada: \(selectedBank.name)")
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
        stackView.alignment = .center
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
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            nameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(with bank: GroupedOption, imageCache: [String: UIImage]) {
        if let cachedImage = imageCache[bank.image ?? ""] {
            imageView.image = cachedImage
        } else {
            print("Error: La imagen no está en la caché")
        }

        nameLabel.text = bank.name
    }
}
