//
//  BXPhotoViewerViewController.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/19.
//
//

import UIKit

public class BXPhotoViewerViewController: UIPageViewController {
  var photos:[BXPhotoViewable]
  public init(photos:[BXPhotoViewable] = []){
    self.photos = photos
    super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  }

  required public init?(coder: NSCoder) {
    self.photos = []
    super.init(coder: coder)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.dataSource = self
    if let photo = photos.first{
      let firstVC = BXPhotoViewController(photo: photo)
      setViewControllers([firstVC], direction: .Forward, animated: true, completion: nil)
    }
  }

  public override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

}

// MARK: UIPageViewControllerDataSource
extension BXPhotoViewerViewController: UIPageViewControllerDataSource{
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    guard let photoVC = (viewController as? BXPhotoViewController) else {
      return nil
    }
    if photoVC.page < (photos.count - 1){
      return photoViewControllerOfPage(photoVC.page + 1)
    }
    return nil
    
  }
  
  func photoViewControllerOfPage(page:Int) -> BXPhotoViewController{
    let vc =  BXPhotoViewController(photo: photos[page])
    vc.page = page
    return vc
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    guard let photoVC = (viewController as? BXPhotoViewController) else {
      return nil
    }
    if photoVC.page > 0{
      return photoViewControllerOfPage(photoVC.page - 1)
    }
    return nil
  }
  
}
