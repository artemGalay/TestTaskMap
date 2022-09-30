//
//  ViewController.swift
//  TestTaskMap
//
//  Created by Артем Галай on 29.09.22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private lazy var addAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addAddress"), for: .normal)
        button.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var routeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "route"), for: .normal)
        button.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var annotationsArray = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(mapView)
        mapView.addSubview(addAddressButton)
        mapView.addSubview(routeButton)
        mapView.addSubview(resetButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            addAddressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAddressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            addAddressButton.heightAnchor.constraint(equalToConstant: 70),
            addAddressButton.widthAnchor.constraint(equalToConstant: 100),

            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            routeButton.heightAnchor.constraint(equalToConstant: 90),
            routeButton.widthAnchor.constraint(equalToConstant: 160),

            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            resetButton.heightAnchor.constraint(equalToConstant: 80),
            resetButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func alertAddAddress(title: String, placeholder: String, completionHandler: @escaping (String) -> Void) {

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (action) in

            let textFieldText = alertController.textFields?.first
            guard let text = textFieldText?.text else { return }
            completionHandler(text)
        }

        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
        }

        let alertCancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }

        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)

        present(alertController, animated: true, completion: nil)
    }

    private func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(alertOk)

        present(alertController, animated: true, completion: nil)
    }

    private func setupPlacemark(addressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("Санкт-Петербург, Некрасова 20") { [unowned self] (placemarks, error) in
            if let error = error {
                print(error)
                alertError(title: "Error", message: "The server is unavailable")
                return
            }

            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first

            let annotation = MKPointAnnotation()
            annotation.title = "\(addressPlace)"
            guard let placemaksLocation = placemark?.location else { return }
            annotation.coordinate = placemaksLocation.coordinate

            annotationsArray.append(annotation)

            if annotationsArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }

    private func createDirectionReqest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)

        let reqest = MKDirections.Request()
        reqest.source = MKMapItem(placemark: startLocation)
        reqest.destination = MKMapItem(placemark: destinationLocation)
        reqest.transportType = .walking
        reqest.requestsAlternateRoutes = true

        let diraction = MKDirections(request: reqest)
        diraction.calculate { (responce, error) in
            if let error = error {
                print(error)
                return
            }
            guard let responce = responce else {
                self.alertError(title: "Error", message: "The route isn't available")
                return
            }

            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
            }

            self.mapView.addOverlay(minRoute.polyline)
        }
    }

    @objc func addAddressButtonTapped() {
        alertAddAddress(title: "Add", placeholder: "Enter the address") { [unowned self] (text) in
            setupPlacemark(addressPlace: text)
        }
    }

    @objc func routeButtonTapped() {

    }

    @objc func resetButtonTapped() {

    }
}
