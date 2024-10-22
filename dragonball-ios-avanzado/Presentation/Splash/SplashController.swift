import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if SecureDataStore.shared.getToken() != nil {
            navigationController?.pushViewController(HeroesListBuilder().build(), animated: true)
        } else {
            navigationController?.pushViewController(LoginBuilder().build(), animated: true)
        }
    }

}
