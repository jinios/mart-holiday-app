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

class MapViewController: UIViewController, NMapPOIdataOverlayDelegate, NMapViewDelegate {
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) {
            guard let addressToShow = addressToShow else { return }
            MapSetter.tryGeoRequestTask(address: addressToShow) { geo in
                DispatchQueue.main.async {
                    mapView.showMarker(at: geo)
                    mapView.setCenter(point: geo)
                    mapView.setMapEnlarged(true, mapHD: true)
                    mapView.mapViewMode = .vector
                }
            }
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }


    var mapView: NMapView?
    var addressToShow: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = NMapView()
        if let mapView = mapView {
            mapView.delegate = self
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
