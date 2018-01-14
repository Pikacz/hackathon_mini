import UIKit


class BasicCollectionView: UICollectionView {
    private var fs: [() -> ()] = []
    private var duringUpdates: Bool = false
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
}


class BasicCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {}
}

