
import UIKit

public protocol BXPhotoViewable{
    var photoURL:NSURL?{ get }
    var photo:UIImage?{ get }
    var photoTitle:String? { get }
}

public extension BXPhotoViewable{
    var photo:UIImage?{ return nil }
    var photoURL:NSURL?{ return nil }
    var photoTitle:String? { return nil }
}


extension UIImage:BXPhotoViewable{
    public var photo:UIImage?{ return self }
}

extension NSURL:BXPhotoViewable{
  public var photoURL:NSURL?{ return self }
}

extension String:BXPhotoViewable{
  public var photoURL:NSURL?{ return NSURL(string: self) }
}

public class BXSimplePhoto: BXPhotoViewable{
    let url:NSURL
    let title:String?
    public init(url:NSURL,title:String=""){
        self.url = url
        self.title = title
    }
    
    // MARK: BXPhotoViewable
    public var photoURL:NSURL?{
        return url
    }
    
    public var photoTitle:String? {
        return title
    }
}