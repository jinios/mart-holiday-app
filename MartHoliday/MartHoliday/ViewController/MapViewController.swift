//
//  MapViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 22..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol MartMapViewHolder {
    var mapView: NMapView? { get }
    var mapViewDelegate: MartMapDelegate! { get }
}

class MapViewController: UIViewController, MartMapViewHolder {

    var mapView: NMapView?
    var mapViewDelegate: MartMapDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ProgramDescription.MartLocation.rawValue
        
        mapView = NMapView()
        if let mapView = mapView {
            mapView.delegate = mapViewDelegate
            guard let keyInfo = KeyInfoLoader.loadNMapKeySet() else { return }
            guard let id = keyInfo.id as? String else { return }
            mapView.setClientId(id)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(mapView)
            mapView.frame = self.view.frame
            mapView.setMapGesture(enable: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        mapView?.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.viewDidDisappear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
