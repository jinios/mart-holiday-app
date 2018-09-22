//
//  MapViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 22..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol MartMapViewHolder {
    var mapView: NMapView? { get set }
    var mapViewDelegate: MartMapDelegate? { get set }
    func setDelegate(mapView: NMapView, mapViewDelegate: MartMapDelegate)
}

class MapViewController: UIViewController, MartMapViewHolder {

    var mapViewDelegate: MartMapDelegate?
    var mapView: NMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mapView = mapView else { return }
        guard let mapViewDelegate = mapViewDelegate else { return }
        setDelegate(mapView: mapView, mapViewDelegate: mapViewDelegate)
        self.view.addSubview(mapView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDelegate(mapView: NMapView, mapViewDelegate: MartMapDelegate) {
        mapView.setDelegate(mapViewDelegate)
    }

}
