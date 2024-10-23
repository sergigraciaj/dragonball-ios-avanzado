import UIKit

final class HeroDetailViewController: UIViewController {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var heroImage: AsyncImageView!
    @IBOutlet private weak var heroName: UILabel!
    @IBOutlet private weak var heroDescription: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorContainer: UIStackView!
    
    private let viewModel: HeroDetailViewModel
    private let hero: Hero
    
    init(hero: Hero, viewModel: HeroDetailViewModel) {
        self.hero = hero
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
        
        self.navigationItem.title = self.hero.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.load(id: self.hero.id)
    }

    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load(id: self.hero.id)
    }
    
    @IBAction func onTransformationButtonTapped(_ sender: Any) {
        print("transformation")
        //self.navigationController?.show(HeroTransformationListBuilder().build(hero: self.hero), sender: self)
    }
    
    // MARK: - States
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        
        errorContainer.isHidden = false
        errorLabel.text = reason
        
        heroImage.isHidden = true
        heroName.isHidden = true
        heroDescription.isHidden = true
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        
        errorContainer.isHidden = true
        
        heroImage.isHidden = true
        heroName.isHidden = true
        heroDescription.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        
        errorContainer.isHidden = true
        
        heroImage.isHidden = false
        heroImage.setDetailImage(self.hero.photo)
        heroName.isHidden = false
        heroName.text = self.hero.name
        heroDescription.isHidden = false
        heroDescription.text = self.hero.info
    }
}
