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

