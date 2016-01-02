//
//  ViewController.swift
//  BXPhotoViewer
//
//  Created by banxi1988 on 11/10/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import BXPhotoViewer
import Photos



class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
  @IBOutlet weak var showPhotoCell: UITableViewCell!
  @IBOutlet weak var compressPhotoCell: UITableViewCell!
  @IBOutlet weak var chooseAssetThenCompress: UITableViewCell!
  
 
  func showPhoto(){
        let url = "http://ww4.sinaimg.cn/large/72973f93gw1exmgz9wywcj216o1kwnfs.jpg"
        let image = UIImage(named: "karry.jpg")!
      let photos : [BXPhotoViewable] = [url,image]
      let vc = BXPhotoViewerViewController(photos:photos)
      showViewController(vc, sender: self)
     
    }

  
  func showCompressPhoto(){
      let image = UIImage(named: "karry.jpg")!
    showCompressImage(image)
  }
  
  func showCompressPhoto(asset:PHAsset){
    PHCachingImageManager().requestImageDataForAsset(asset, options: nil) { (data, name, orintation, info) -> Void in
      NSLog("requestedImage:isMainThread:\(NSThread.isMainThread()))")
      self.showCompressImage(UIImage(data: data!)!)
    }
  }
  
  func showCompressImage(image:UIImage){
    let vc = BXPhotoInteractiveCompressViewController()
    vc.image = image
    presentViewController(vc, animated: true, completion: nil)
  }
  
  func chooseAssetThenCompressAsset(){
    let successBlock :ALImageFetchingInteractorSuccess = {
      (assets:[PHAsset]) in
      self.showCompressPhoto(assets[0])
    }
    ALImageFetchingInteractor().onSuccess(successBlock).fetch()
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    switch cell!{
    case  showPhotoCell:
      showPhoto()
    case compressPhotoCell:
       showCompressPhoto()
    case chooseAssetThenCompress:
      chooseAssetThenCompressAsset()
    default:break
    }
  }

}

extension ViewController:BXPhotoInteractiveCompressViewControllerDelegate{
  
  func photoInteractiveCompressViewControllerDidCanceled(controller: BXPhotoInteractiveCompressViewController) {
    
  }
  
  func photoInteractiveCompressViewController(controller: BXPhotoInteractiveCompressViewController, compressedImage: UIImage) {
    
  }
}

