import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("splash")
        if SecureDataStore.shared.getToken() != nil {
            // go to heroes
        } else {
            navigationController?.pushViewController(LoginBuilder().build(), animated: true)
        }
    }

}
