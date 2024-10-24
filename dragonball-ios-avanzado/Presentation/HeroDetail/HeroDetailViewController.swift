import UIKit
import MapKit

final class HeroDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var heroDescription: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
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
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TransformationViewCell.nib, forCellWithReuseIdentifier: TransformationViewCell.reuseIdentifier)
        
        configureMap()
        bind()
        viewModel.load(id: self.viewModel.hero.id)
        checkLocationAuthorizationStatus()
    }

    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load(id: self.viewModel.hero.id)
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
        collectionView.isHidden = true
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        
        errorContainer.isHidden = true
        
        heroDescription.isHidden = true
        collectionView.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        
        errorContainer.isHidden = true
        
        heroDescription.isHidden = false
        heroDescription.text = self.viewModel.hero.info
        collectionView.isHidden = false
        collectionView.reloadData()
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TransformationViewCell {
            let transformation = viewModel.transformations[indexPath.row]
            cell.setPhoto(transformation.photo)
            cell.setTransformationName(transformation.name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.row]
        //navigationController?.show(TransformationBuilder(transformation: transformation).build(), sender: self)
        self.present(TransformationBuilder(transformation: transformation).build(), animated: true)
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
