//
//  ViewController.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/26.
//  Copyright © 2018年 hml. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var btn: UIButton = UIButton.init(frame: CGRect.init(x: 100,
                                                         y: 100,
                                                         width: 100,
                                                         height: 40),
                                      title: "按钮",
                                      color: .black)
    
    @objc func btnAction() {
        let vc: Test1ViewController = Test1ViewController()
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.btn)
        self.btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.btnAction()
        }
        
        let str: String = "KkM_EPNVgIGZ8Um0s3fOAO_PMEbFsmoJs8mkbJLYh89UO0hOQ7FngEPOC9ztACLC4znFswjxK-e0GuotP0Knp7SR4tNdh74FAcSmfH14kwfnRG6Wj3cQFtv9BJGVayvdk0RS4q1x-CKB5lMAUuL47cg5AvdV0UxS71pmICk3qQo="
        print("str.length = \(str.length)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

