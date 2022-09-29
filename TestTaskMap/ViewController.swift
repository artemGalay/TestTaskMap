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

    @objc func addAddressButtonTapped() {
        alertAddAddress(title: "Add", placeholder: "Enter the address") { (text) in
            print(text)
        }

    }

    @objc func routeButtonTapped() {

    }

    @objc func resetButtonTapped() {

    }
}
