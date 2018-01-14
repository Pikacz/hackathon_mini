import UIKit


class BasicViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView? {
        didSet {
            activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.backgroundColor = Color.black
        }
    }
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            guard oldValue != isLoading else { return }
            if isLoading {
                activityIndicator?.startAnimating()
            } else {
                activityIndicator?.stopAnimating()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = navTitle
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = nil
    }
    
    
    
    func display(error: Error) {
        print("TODO display error")
    }
    
    
    func showOkAlert(title: String?, message: String?, action: (() -> ())? = nil) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (_: UIAlertAction) in
            action?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    
}
