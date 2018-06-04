//
//  DetailViewController.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/2/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    
    let cityDataMagager = CityDataMagager()
    var itemToShow:[(info:String,value:String)] = []
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemToShow = cityDataMagager.getCityDetailInformation()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.mapType = MKMapType.standard
        guard let location = CityDataMagager.currentCitySelected?.location else { return }
        if  cityDataMagager.validateLocation(location: location) {
            let span = MKCoordinateSpanMake(15, 15)
            let region =  MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            let annonation = MKPointAnnotation()
            annonation.coordinate = location
            annonation.title = CityDataMagager.currentCitySelected?.name ?? ""
            annonation.subtitle = CityDataMagager.currentCitySelected?.country ?? ""
            mapView.addAnnotation(annonation)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemToShow.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Information"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "informationCell")
        let cellInfo = itemToShow[indexPath.item]
        cell.textLabel?.text = cellInfo.info
        cell.detailTextLabel?.text = cellInfo.value
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
