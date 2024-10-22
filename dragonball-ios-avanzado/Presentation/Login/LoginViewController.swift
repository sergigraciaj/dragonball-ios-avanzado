import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.signIn(usernameField.text, passwordField.text)
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
                print("login successfull")
                //self?.navigationController?.setViewControllers([HeroesListBuilder().build()], animated: true)
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            }
        }
    }
    
    // MARK: - State rendering functions
    private func renderSuccess() {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = true
    }
    
    private func renderError(_ reason: String) {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        signInButton.isHidden = true
        spinner.startAnimating()
        errorLabel.isHidden = true
    }
}
