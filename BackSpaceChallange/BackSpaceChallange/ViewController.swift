 //
//  ViewController.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let test = CityDataMagager()
        
        test.loadData()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

