//
//  ViewController.swift
//  StartPageControlDemo
//
//  Created by zgzzzs on 2017/10/30.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var saveImageList = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        saveImageList.append("WechatIMG1")
        saveImageList.append("WechatIMG2")
        saveImageList.append("WechatIMG3")
        saveImageList.append("WechatIMG4")
        saveImageList.append("WechatIMG5")


        PageControlSwift.setUpPageControlView(imagesList: saveImageList, closure: { (pageNum) in

            print("第\(pageNum+1)页");

        }) {

            print("点击了Button")


        }


        self.view.backgroundColor = UIColor.blue;


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

