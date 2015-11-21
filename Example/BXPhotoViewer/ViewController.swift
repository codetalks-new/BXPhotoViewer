//
//  ViewController.swift
//  BXPhotoViewer
//
//  Created by banxi1988 on 11/10/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import BXPhotoViewer



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let url = "http://ww4.sinaimg.cn/large/72973f93gw1exmgz9wywcj216o1kwnfs.jpg"
        let image = UIImage(named: "karry.jpg")!
      let photos : [BXPhotoViewable] = [url,image]
      let vc = BXPhotoViewerViewController(photos:photos)
      showViewController(vc, sender: self)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

