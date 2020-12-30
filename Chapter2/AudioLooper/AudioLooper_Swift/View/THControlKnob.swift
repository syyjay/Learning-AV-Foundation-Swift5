//
//  THGreenControlKnob.swift
//  AudioLooper_Swift
//
//  Created by nathan on 2020/12/25.
//

import UIKit

let kMaxAngle:Float = 120.0
let kScalingFactor:Float = 4.0


class THControlKnob: UIControl {
    var maximumValue:Float = 1.0
    var minimumValue:Float = -1.0
    var defaultValue:Float = 0.0
    var value:Float?
    
    var angle:Float = 0.0
    var touchOrigin:CGPoint?
    var indicatorView:THIndicatorLight?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVeiw()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVeiw() {
        self.backgroundColor = UIColor.clear
        value = defaultValue
        indicatorView = THIndicatorLight.init(frame: self.bounds)
        indicatorView?.lightColor = indicatorLightColor()
        valueDidChangeFrom(oldValue: defaultValue, to: defaultValue, animated: false)
    }
    
    func indicatorLightColor() ->UIColor{
        return UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        let strokeColor = UIColor.init(white: 0.06, alpha: 1)
        let gradientLightColor = UIColor.init(red: 0.101, green: 0.100, blue: 0.103, alpha: 1.000)
        let gradientDarkColor = UIColor.init(red: 0.237, green: 0.242, blue: 0.242, alpha: 1.000)
        if self.isHighlighted {
//            gradientLightColor  = gradientLightColor
        }
        

    }
}

extension THControlKnob{
    
    func angleForValue(angle:Float) -> Float {
        return (angle / (kMaxAngle * 2.0) + 0.5) * (maximumValue - minimumValue) + minimumValue
    }
    
    func valueDidChangeFrom(oldValue:Float,to newValue:Float,animated:Bool)  {
        let newAngle:Double = (Double)(angleForValue(angle: newValue))
        if animated {
            let oldAngle:Double = Double(angleForValue(angle: oldValue))
            let animation = CAKeyframeAnimation.init(keyPath: "transform.rotation.z")
            animation.duration = 0.2
            animation.values = [oldAngle * .pi / 180.0,(newAngle + oldAngle) / 2.0 * .pi / 180,newAngle * .pi / 180.0]
            animation.keyTimes = [0.0,0.5,1.0]
            animation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn),CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)]
            indicatorView?.layer.add(animation, forKey: nil)
            
        }
        indicatorView?.transform = CGAffineTransform(rotationAngle: CGFloat(newAngle * .pi/180.0))
    }
}


class THGreenControlKnob: THControlKnob {
    override func indicatorLightColor() -> UIColor {
        return UIColor.init(red: 1, green: 0.718, blue: 0, alpha: 1)
    }
}

class THOrangeControlKnob: THControlKnob {
    override func indicatorLightColor() -> UIColor {
        return UIColor.init(red: 1, green: 0.718, blue: 0, alpha: 1)
    }
}


extension UIColor{
    func darkerColor() -> UIColor? {
        var hue:CGFloat = 0.0
        var staturation:CGFloat = 0.0
        var brightness:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        if self.getHue(&hue, saturation: &staturation, brightness: &brightness, alpha: &alpha) {
           return UIColor.init(hue: hue, saturation: staturation, brightness: brightness, alpha: 0.5)
//            return UIColor.init(hue: hue, saturation: staturation, brightness: min(brightness * 1.3, 1.0), alpha: 0.5)
        }
        return nil
    }
//    func lightterColor() -> UIColor {
//        var hue ,staturation,brightness,alpha:CGFloat
//        if self.getHue(&hue, saturation: &staturation, brightness: &brightness, alpha: &alpha) {
//            return UIColor.init(hue: hue, saturation: staturation, brightness: brightness * 0.92, alpha: alpha)
//        }
//    }
}
//extension UIColor {
//    // 返回HSBA模式颜色值
//    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
//        var h: CGFloat = 0
//        var s: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
//        return (h * 360, s, b, a)
//    }
//}
