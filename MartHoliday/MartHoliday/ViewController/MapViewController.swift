//
//  MapViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 22..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap

public let DEFAULT_MAP_ZOOM: Double = 15.0
public let DEFAULT_MAP_MARKER_IMAGE: NMFOverlayImage = NMF_MARKER_IMAGE_LIGHTBLUE

class MapViewController: UIViewController {

    var mapView: MartMapView?
    var centerPoint: GeoPoint? // 0일때 그냥 기본 맵뷰

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ProgramDescription.MartLocation.rawValue
        guard let centerPoint = self.centerPoint else { return }
        self.mapView = MartMapView(frame: self.view.frame, center: centerPoint)
        if let mapView = self.mapView {
            self.view.addSubview(mapView)
            self.mapView?.addDefaultMarker()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
