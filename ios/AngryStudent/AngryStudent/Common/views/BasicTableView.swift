import UIKit


class BasicTableView: UITableView {
    private var fs: [() -> ()] = []
    private var duringUpdates: Bool = false
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {}
    
    
    func safeUpdates(_ f: @escaping () -> ()) {
        fs.append(f)
        tryFire()
    }
    
    
    private func tryFire() {
        guard fs.count > 0, !duringUpdates else { return }
        duringUpdates = true
        let f: () -> () = fs.removeFirst()
        CATransaction.begin()
        f()
        CATransaction.setCompletionBlock {
            self.duringUpdates = false
            self.tryFire()
        }
        CATransaction.commit()
    }
    
    
    func safeReload(completion: (() -> ())? = nil) {
        fs = []
        safeUpdates {
            super.reloadData()
            completion?()
        }
    }
    
    override func reloadData() {
        fs = []
        super.reloadData()
    }
}


class BasicTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {}
}


class BasicTableViewHeaderFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {}
}

