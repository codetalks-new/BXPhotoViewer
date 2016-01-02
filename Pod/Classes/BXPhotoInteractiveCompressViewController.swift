//
//  BXPhotoInteractiveCompressViewController.swift
//  Pods
//
//  Created by Haizhen Lee on 15/12/4.
//
//

import Foundation

public protocol BXPhotoInteractiveCompressViewControllerDelegate: class{
  func photoInteractiveCompressViewControllerDidCanceled(controller:BXPhotoInteractiveCompressViewController)
  func photoInteractiveCompressViewController(controller:BXPhotoInteractiveCompressViewController,compressionQuality:CGFloat, compressedImage:UIImage)
}

// Build for target uicontroller
import UIKit
import PinAutoLayout

// -BXPhotoInteractiveCompressViewController:vc
// preview[e0]:v; cancel[t20,l15,w52,a1]:b;ok[t20,r15,w52,a1]:b;quality[l8,r8,b20]:sl

public class BXPhotoInteractiveCompressViewController : UIViewController {
  
  public weak var delegate: BXPhotoInteractiveCompressViewControllerDelegate?
  
  public let previewView = BXImageScrollView(frame:CGRectZero)
  public let cancelButton = UIButton(type:.System)
  public let okButton = UIButton(type:.System)
  public let qualitySlider = UISlider(frame:CGRectZero)
  public let imageInfoLabel = UILabel(frame: CGRectZero)
 
  public var image:UIImage?
  
  var previewImage:UIImage?{
    didSet{
      if let image = previewImage {
        previewView.displayImage(image)
      }
    }
  }
  
  public convenience init(){
    self.init(nibName: nil, bundle: nil)
  }
  // must needed for iOS 8
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  var allOutlets :[UIView]{
    return [previewView,cancelButton,okButton,qualitySlider,imageInfoLabel]
  }
  var allUIButtonOutlets :[UIButton]{
    return [cancelButton,okButton]
  }
  var allUISliderOutlets :[UISlider]{
    return [qualitySlider]
  }
  var allUIViewOutlets :[UIView]{
    return [previewView]
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      self.view.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
  }
  
  func installConstaints(){
    previewView.pinEdge(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    
    cancelButton.pinAspectRatio(1)
    pinTopLayoutGuide(cancelButton,margin:8)
    cancelButton.pinWidth(52)
    cancelButton.pinLeading(15)
    
    okButton.pinAspectRatio(1)
    okButton.pinTrailing(15)
    pinTopLayoutGuide(okButton,margin:8)
    okButton.pinWidth(52)
    
    qualitySlider.pinTrailing(8)
    pinBottomLayoutGuide(qualitySlider,margin:20)
    qualitySlider.pinLeading(8)
    
    imageInfoLabel.pinAboveSibling(qualitySlider, margin: 8)
    imageInfoLabel.pinHeight(36)
    imageInfoLabel.pinHorizontal(0)
    
  }
  
  public var minimumQuality:CGFloat{
    set{
      qualitySlider.minimumValue = Float(newValue)
    }get{
      return CGFloat(qualitySlider.minimumValue)
    }
  }
  
  public var maximumQuality:CGFloat{
    get{
      return CGFloat(qualitySlider.maximumValue)
    }set{
      qualitySlider.maximumValue = Float(newValue)
    }
  }
  
  public var defaultQuality: CGFloat = 0.6{
    didSet{
      qualitySlider.value = Float(defaultQuality)
    }
  }
  
  func setupAttrs(){
    
    qualitySlider.minimumValue = 0.2
    qualitySlider.maximumValue = 0.8
    qualitySlider.addTarget(self, action: "onQualityValueChanged:", forControlEvents: .ValueChanged)
    
    imageInfoLabel.font = UIFont.systemFontOfSize(14)
    imageInfoLabel.textColor = UIColor.whiteColor()
    imageInfoLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
    
    cancelButton.setTitle("取消", forState: .Normal)
    okButton.setTitle("确定", forState: .Normal)
    
    cancelButton.addTarget(self, action: "onCancel:", forControlEvents: .TouchUpInside)
    okButton.addTarget(self, action: "onOk:", forControlEvents: .TouchUpInside)
//    image
  }
  
  @IBAction func onCancel(sender:AnyObject){
   self.delegate?.photoInteractiveCompressViewControllerDidCanceled(self)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onOk(sender:AnyObject){
    if let image = previewImage{
      self.delegate?.photoInteractiveCompressViewController(self, compressionQuality: CGFloat(qualitySlider.value), compressedImage: image)
      dismissViewControllerAnimated(true, completion: nil)
    }else{
      onCancel(sender)
    }
  }
  
  
  public override func loadView(){
    super.loadView()
    self.view.backgroundColor = UIColor.blackColor()
    commonInit()
  }

 
  @IBAction func onQualityValueChanged(sender:UISlider){
    updatePreviewImageByQuality(sender.value)
  }
  
  func updatePreviewImageByQuality(quality:Float){
    guard let rawImage = image else {
      imageInfoLabel.text = "没有图片。"
      return
    }
    if let data = UIImageJPEGRepresentation(rawImage, CGFloat(quality)) {
      if let image = UIImage(data: data){
        previewImage = image
        previewView.setNeedsDisplay()
        let x = Int(image.size.width)
        let y = Int(image.size.height)
        let imageInfo = "大小：\(data.length / 1024 ) KB; 宽高：\(x)x\(y)"
        imageInfoLabel.text = imageInfo
      }
    }
  }
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    updatePreviewImageByQuality(qualitySlider.value)
  }
 
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if let image = previewImage{
      previewView.displayImage(image)
    }
  }
  
  
}

