//
//  generate.swift
//  Lapsha
//
//  Created by Мурат Камалов on 26/07/2019.
//  Copyright © 2019 Мурат Камалов. All rights reserved.
//

import UIKit

class generate: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //button for generate some events 
    @IBAction func generate(_ sender: UIButton) {
        for i in 3300...3460{
             //if i%2 == 0{
            array.append(["start": i - 10, "end" : i + 10])
            //}
        }
        print(array.last,"next")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
