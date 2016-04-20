//
//  BXImageScrollView.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/18.
//
// Taken from Apple ImageScrollView

import UIKit


extension CGRect{
  
  init(center center:CGPoint,width:CGFloat,height:CGFloat){
    let x = center.x - width * 0.5
    let y = center.y - height * 0.5
    origin = CGPoint(x: x, y: y)
    size = CGSize(width: width, height: height)
  }
}

public class BXImageScrollView: UIScrollView {
  var zoomView: UIImageView?
  var pointToCenterAfterResize:CGPoint = CGPointZero
  var scaleToRestoreAfterResize: CGFloat = 0
  var imageSize = CGSizeZero
  override public var frame:CGRect{
    set{
        let sizeChanging = frame != newValue
        if sizeChanging{
          prepareToResize()
        }
      super.frame = newValue
      if sizeChanging{
        recoverFromResizing()
      }
    } get{
        return super.frame
    }
    
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit(){
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    bouncesZoom = true
    decelerationRate = UIScrollViewDecelerationRateFast
    delegate = self
    setupDoubleTapRecognizer()
  }
  
  func setupDoubleTapRecognizer(){
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
    doubleTapRecognizer.numberOfTapsRequired = 2
    doubleTapRecognizer.delaysTouchesBegan = true
    
    addGestureRecognizer(doubleTapRecognizer)
    panGestureRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
  }
  
  func onDoubleTap(gesture:UITapGestureRecognizer){
    let location = gesture.locationInView(self)
    let center = convertPoint(location, toView: zoomView)
    let currentZoomScale = zoomScale
    if currentZoomScale > (minimumZoomScale + CGFloat(FLT_EPSILON)) {
      setZoomScale(minimumZoomScale, animated: true)
    }else{
//      let targetScale = minimumZoomScale * 2
      let targetRect = CGRect(center:center,width: bounds.width,height: bounds.height)
      zoomToRect(targetRect, animated: true)
    }
  }
 
  public override func layoutSubviews() {
    super.layoutSubviews()
    guard let zoomView = zoomView else{
      return
    }
    var frameToCenter = zoomView.frame
    
    // Center horizontally
    if frameToCenter.width < bounds.width{
      frameToCenter.origin.x = (bounds.width - frameToCenter.width) * 0.5
    }else{
      frameToCenter.origin.x = 0
    }
    
    // Center vertically
    if frameToCenter.height < bounds.height{
       frameToCenter.origin.y = (bounds.height - frameToCenter.height) * 0.5
    }else{
      frameToCenter.origin.y = 0
    }
    zoomView.frame = frameToCenter
  }
  
  // MARK: Methods called during rotation to preserve the zoomScale and the visible portion of the image
  func prepareToResize(){
    let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    pointToCenterAfterResize = convertPoint(boundsCenter,toView: zoomView)
    scaleToRestoreAfterResize = zoomScale
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minium allowable scale when the scale is restored
    if scaleToRestoreAfterResize <= (self.minimumZoomScale + CGFloat(FLT_EPSILON)){
       scaleToRestoreAfterResize = 0
    }
  }

  func recoverFromResizing(){
      setMaxMinZoomScalesForCurrentBounds()
    // Step 1: restore zoom scale 
    scaleToCenter(pointToCenterAfterResize, scale: scaleToRestoreAfterResize)
  }
  
  func scaleToCenter(center:CGPoint,scale scale:CGFloat){
    // making sure it is within the allowable range
    let maxZoomScale = max(minimumZoomScale,scale)
    zoomScale = min(maximumZoomScale,maxZoomScale)
    
    // Step 2: restore center point, first making sure it is within the allowable range
    // 2a: convert our desired center point back to our own coordinate space
    let boundsCenter = convertPoint(center, fromView: zoomView)
    // 2b: calcuate the content offset that would yield that center
    let offset = CGPoint(x: boundsCenter.x - bounds.width * 0.5, y: boundsCenter.y - bounds.height * 0.5)
    // 2c: restore offset, adjusted to be within the alloable range
    let maxOffset = maxContentOffset()
    let minOffset = minContentOffset()
    
    let realMaxOffsetX = min(maxOffset.x,offset.x)
    let realMaxOffsetY = min(maxOffset.y,offset.y)
    var finalOffset  = CGPointZero
    finalOffset.x = min(realMaxOffsetX, minOffset.x)
    finalOffset.y = min(realMaxOffsetY, minOffset.y)
    
    self.contentOffset = finalOffset
  }
  
  public func displayImage(image:UIImage){
    zoomView?.removeFromSuperview()
    zoomView = nil
  // reset our zoomScale to 1.0 before doing any further calculations
    zoomScale = 1.0
    zoomView = UIImageView(image: image)
    addSubview(zoomView!)
    configureForImageSize(image.size)
  }
  
  public func updateImage(image:UIImage){
   let oldZoomScale = zoomScale
    displayImage(image)
    zoomScale = oldZoomScale
  }
 
  
  func configureForImageSize(size:CGSize){
   imageSize = size
    contentSize = imageSize
    setMaxMinZoomScalesForCurrentBounds()
    zoomScale = self.minimumZoomScale
  }
  
  func setMaxMinZoomScalesForCurrentBounds(){
    // calculate min / max zoomscale
    let xScale = bounds.width / imageSize.width
    let yScale = bounds.height / imageSize.height
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    let isImagePortrait = imageSize.height > imageSize.width
    let isPhonePortrait = bounds.height > bounds.width
    var minScale = isImagePortrait == isPhonePortrait ? xScale: min(xScale,yScale)
    // on high resolution screens we have double the pixel density,so we will be seeing every pixel if we limit the maximum zoom scale to 0.5.
    let maxScale = 1.0  / UIScreen.mainScreen().scale
    // Don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if minScale > maxScale{
        minScale = maxScale
    }
    
    maximumZoomScale = maxScale
    minimumZoomScale = minScale
  }
  
  
  func maxContentOffset() -> CGPoint{
    let size = contentSize
    return CGPoint(x: size.width - bounds.width,y: size.height - bounds.height)
  }
  
  func minContentOffset() -> CGPoint{
    return CGPointZero
  }
}

// MARK:UIScrollViewDelegate
extension BXImageScrollView:UIScrollViewDelegate{
  
  public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return zoomView
  }
}
