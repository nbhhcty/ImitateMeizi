//
//  ViewController.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DoubanNetwork.request(target: .category("All", 1),
                              success: { (response) in
                                print("response_type = \(type(of:response))")
                                print("response = \(response)")
                                let iterms = MeiziIterms.decodeJSON(from: response)
                                print("iterms = \(String(describing: iterms?.category))")
        }) { (error) in
            print("error = \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

