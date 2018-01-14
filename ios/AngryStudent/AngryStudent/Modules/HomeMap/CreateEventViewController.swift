import UIKit
import IndoorwaySdk


class CreateEventViewController: BasicViewController {
    
    
    @IBOutlet private weak var iconLbl: UILabel! {
        didSet {
            iconLbl.text = R.string.create_event_icon_lbl^
            iconLbl.font = Font.subtitle
            iconLbl.textColor = Color.blueDark
        }
    }
    @IBOutlet private weak var iconSelectView: SelectIconView!
    @IBOutlet private weak var nameLbl: UILabel! {
        didSet {
            nameLbl.text = R.string.create_event_name_lbl^
            nameLbl.font = Font.subtitle
            nameLbl.textColor = Color.blueDark
        }
    }
    @IBOutlet private weak var nameField: UITextField! {
        didSet {
            nameField.placeholder = R.string.create_event_name_placeholder^
            nameField.font = Font.standard
            nameField.textColor = Color.blueDark
        }
    }
    @IBOutlet private weak var descriptionLbl: UILabel! {
        didSet {
            descriptionLbl.text = R.string.create_event_description_lbl^
            descriptionLbl.font = Font.subtitle
            descriptionLbl.textColor = Color.blueDark
        }
    }
    @IBOutlet private weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.text = ""
            descriptionTextView.layer.borderWidth = CGFloat(1.0)
            descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            descriptionTextView.layer.cornerRadius = CGFloat(8.0)
            descriptionTextView.font = Font.standard
            descriptionTextView.textColor = Color.blueDark
        }
    }
    @IBOutlet private weak var createBtn: UIButton! {
        didSet {
            createBtn.setTitle(R.string.create_event_create_btn^, for: UIControlState.normal)
            
            createBtn.setTitleColor(Color.white, for: UIControlState.normal)
            createBtn.titleLabel?.font = Font.subtitle
            createBtn.backgroundColor = Color.blue
            createBtn.layer.cornerRadius = CGFloat(26.0)
          createBtn.addTarget(self, action: #selector(submmit), for: UIControlEvents.touchUpInside)
        }
    }
    
    
  var room: IndoorwayObjectInfo!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      print("KUPA: \(room.roomName)")
      print(R.string.create_event_title^)
        navTitle = R.string.create_event_title[room.roomName!]
    }
  
  
  // MARK: private
  @objc private func submmit() {
    let name: String = nameField.text!
    let description: String = descriptionTextView.text!
    let icon: String = iconSelectView.selectedIcon
    let roomId: String = room.objectId
    
    
    isLoading = true
    ApiService.defaultInstance.createEvent(
      name: name,
      description: description,
      icon: icon,
      roomId: roomId
    ).then {
      () -> Void in
      self.navigationController?.popViewController(animated: true)
    }.always {
      self.isLoading = true
    }
  }
}




fileprivate let cellId: String = "a"


fileprivate let imageNames: [String] = [
  "Book",
  "balloon",
  "horse",
  "education",
  "Book",
]

class SelectIconView: BasicView, UICollectionViewDataSource {
    private var collectionView: UICollectionView!
    
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
  
  
  
  var selectedIcon: String {
    guard let index: Int = collectionView.indexPathsForSelectedItems?.first?.row else {
      return ""
    }
    return imageNames[index]
    
  }
    
    override func initialize() {
        super.initialize()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        //    flowLayout.minimumInteritemSpacing = CGFloat(8.0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        
        
        
        collectionView.register(SelectIconCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: UICollectionViewScrollPosition.top
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        flowLayout.itemSize = CGSize(width: bounds.height, height: bounds.height)
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: CGFloat(90.0))
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SelectIconCell
      
        cell.display(image: UIImage(named: imageNames[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
}






class SelectIconCell: BasicCollectionViewCell {
    private let imageView: UIImageView = UIImageView()
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(imageView)
        contentView.layer.borderWidth = CGFloat(2.0)
        contentView.layer.borderColor = Color.gray.cgColor
        contentView.layer.cornerRadius = CGFloat(8.0)
        imageView.tintColor = Color.blue
        imageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = CGFloat(16.0)
        let y: CGFloat = CGFloat(16.0)
        let w: CGFloat = contentView.bounds.width - CGFloat(2.0) * x
        let h: CGFloat = contentView.bounds.height - CGFloat(2.0) * y
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? Color.blue.cgColor : Color.gray.cgColor
        }
    }
    
    func display(image: UIImage?) {
        imageView.image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
}
