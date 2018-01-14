import UIKit


class OnboardingViewController: BasicViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    isLoading = true
    ApiService.defaultInstance.createUser().then {
      () -> Void in
      ApiService.defaultInstance.statrtSpammingLocation()
      
      
      self.present(TabBarViewController(nibName: nil, bundle: nil), animated: true)
      }.always {
        self.isLoading = false
    }
  }
}
