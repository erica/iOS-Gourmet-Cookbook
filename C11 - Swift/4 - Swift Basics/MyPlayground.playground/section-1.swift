import UIKit

println("Hello World")

let view1 = UIImageView(frame: CGRectMake(0, 0, 100, 100))
view1.backgroundColor = UIColor.blueColor()


let rect = CGRectMake(0, 0, 100, 100)
UIGraphicsBeginImageContext(rect.size)
var path = UIBezierPath(ovalInRect:rect)
UIColor.redColor().set()
path.fill()
view1.image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext()
