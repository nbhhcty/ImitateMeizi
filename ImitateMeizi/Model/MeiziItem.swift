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

//    category = ZaHui;
//    "group_url" = "https://www.dbmeinv.com:443/dbgroup/1736776";
//    "image_url" = "https://wx3.sinaimg.cn/large/0060lm7Tgy1ftbzuqwn06j30dw0dv0u4.jpg";
//    objectId = 5b4cc6d29f54540031fc0465;
//    "thumb_url" = "https://wx3.sinaimg.cn/small/0060lm7Tgy1ftbzuqwn06j30dw0dv0u4.jpg";
//    title = "\U9760\U8c31\U662f\U4ec0\U4e48\U5b9a\U4e49\U5462";
}

struct MeiziIterms: Codable {
    var category:String = ""
    var page:Int = 0
    var results:[MeiziIterm] = []
}
