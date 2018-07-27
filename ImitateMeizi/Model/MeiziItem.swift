//
//  MeiziItem.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/27.
//  Copyright © 2018年 hml. All rights reserved.
//

import UIKit

struct MeiziIterm: Codable {
    var category:String = ""
    var group_url:String = ""
    var image_url:String = ""
    var objectId:String = ""
    var thumb_url:String = ""
    var title:String = ""
}

struct MeiziIterms: Codable {
    var category:String = ""
    var page:Int = 0
    var results:[MeiziIterm] = []
}
