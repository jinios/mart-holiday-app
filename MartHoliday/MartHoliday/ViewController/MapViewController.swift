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
    var mapViewDelegate: MartMapDelegate! { get set }
}

class MapViewController: UIViewController, MartMapViewHolder {

    var mapView: NMapView?
    var addressToShow: String?
    var mapViewDelegate: MartMapDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewDelegate = MartMapDelegate(address: addressToShow!)

        mapView = NMapView()
        if let mapView = mapView {
            mapView.delegate = mapViewDelegate
            guard let keyInfo = MapSetter.loadNMapKeySet() else { return }
            guard let id = keyInfo.id as? String else { return }
            mapView.setClientId(id)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(mapView)
            mapView.frame = self.view.frame
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
