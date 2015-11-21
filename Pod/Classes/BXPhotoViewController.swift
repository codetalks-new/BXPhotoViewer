//
//  BXPhotoViewerController.swift
//  Youjia
//
//  Created by Haizhen Lee on 15/11/10.
//  Copyright © 2015年 xiyili. All rights reserved.
//

import UIKit

public extension UIViewController{
  
  public func presentPhoto(photo:BXPhotoViewable,loadImageBlock block:BXLoadImageBlock?=nil){
    let vc = BXPhotoViewController(photo: photo)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "bx_dismissPhotoViewController:")
    vc.navigationItem.rightBarButtonItem = doneButton
    vc.automaticallyAdjustsScrollViewInsets = false
    vc.loadImageBlock = block
  
    let nvc = UINavigationController(rootViewController: vc)
    nvc.navigationBar.translucent = true
    nvc.navigationBar.tintColor = .whiteColor()
    nvc.navigationBar.barTintColor = UIColor.clearColor()
    nvc.navigationBar.backgroundColor = UIColor.clearColor()
    nvc.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    nvc.navigationBar.shadowImage = UIImage()
  
    presentViewController(nvc, animated: true, completion: nil)
  }
  
  func bx_dismissPhotoViewController(sender:AnyObject){
      dismissViewControllerAnimated(true, completion: nil)
  }
}

public typealias BXLoadImageBlock = ((URL:NSURL,completionHandler:((UIImage) -> Void)) -> Void  )
public class BXPhotoViewController: UIViewController {
    var photo:BXPhotoViewable?
    public var loadImageBlock:BXLoadImageBlock?
    var scrollView:BXImageScrollView = BXImageScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  
    var page:Int = 0
  
    public init(photo:BXPhotoViewable){
        self.photo = photo
        super.init(nibName: nil, bundle:nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        activityIndicator.tintColor = self.view.tintColor
        self.view.addSubview(scrollView)
        self.view.addSubview(activityIndicator)
    }
  
    override public func viewDidLoad() {
        super.viewDidLoad()
      if let image = photo?.photo {
        scrollView.displayImage(image)
      }else if let URL = photo?.photoURL{
        activityIndicator.startAnimating()
        if let loadBlock = loadImageBlock{
          loadBlock(URL: URL){[weak self] image in
            self?.scrollView.displayImage(image)
            self?.activityIndicator.stopAnimating()
          }
        }else{
          load(URL){[weak self] image in
            self?.scrollView.displayImage(image)
            self?.activityIndicator.stopAnimating()
          }
        }
      }
    }
  
  func load(imageURL:NSURL,toHandler handler:( (UIImage) -> Void)){
      let loadTask =  NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (data, resp, error) -> Void in
        if let data = data{
          if let image = UIImage(data: data){
            dispatch_async(dispatch_get_main_queue()){
              handler(image)
            }
          }
        }
      }
      loadTask.resume()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.frame = self.view.bounds
    activityIndicator.center = self.view.center
    NSLog("\(__FUNCTION__)")
  }
 
   // MARK: Rotate Support
  public override func shouldAutorotate() -> Bool {
    NSLog("\(__FUNCTION__)")
    return true
  }
  
  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    NSLog("\(__FUNCTION__)")
    return .AllButUpsideDown
  }


}
