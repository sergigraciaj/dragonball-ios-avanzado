import UIKit
import MapKit

final class HeroDetailViewController: UIViewController {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var heroDescription: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet weak var mapView: MKMapView!

    private var locationManager: CLLocationManager = CLLocationManager()
    
    private let viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
        
        self.navigationItem.title = self.viewModel.hero.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        bind()
        viewModel.load(id: self.viewModel.hero.id)
        checkLocationAuthorizationStatus()
    }

    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load(id: self.viewModel.hero.id)
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
        
        heroDescription.isHidden = true
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        
        errorContainer.isHidden = true
        
        heroDescription.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        
        errorContainer.isHidden = true
        
        heroDescription.isHidden = false
        heroDescription.text = self.viewModel.hero.info
        
        updateMapAnnotations()
    }
    
    private func updateMapAnnotations() {
        let oldAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(oldAnnotations)
        self.mapView.addAnnotations(viewModel.annotations)
        
        if let annotaion = viewModel.annotations.first {
            mapView.region = MKCoordinateRegion(center: annotaion.coordinate,
                                                latitudinalMeters: 100000,
                                                longitudinalMeters: 100000)
        }
    }

    private func checkLocationAuthorizationStatus() {
        let authorizationStatus = locationManager.authorizationStatus
        switch authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

extension HeroDetailViewController: MKMapViewDelegate {
    
    // Indicamos la custom view para una aannotatio del tipo HeroAnnotation, no para otras como la del user
    // El punto azul que sale en el mapa de la ubicación del dispositivo
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HeroAnnotation else {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier)  {
            return annotationView
        }
        let annotationView = HeroAnnotationView(annotation: annotation,
                                                reuseIdentifier: HeroAnnotationView.identifier)
        
        return annotationView
    }
    
    
    /// Nos indica que el eusuario a pulsado el accesoryView por si quisiéramos realizar alguna acción.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("Call accesory Tapped")
    }
}
