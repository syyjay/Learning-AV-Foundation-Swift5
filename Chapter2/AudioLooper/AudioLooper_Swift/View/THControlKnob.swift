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
        super.init(coder: coder)
        setupVeiw()
//        fatalError("init(coder:) has not been implemented")
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
        var gradientLightColor = UIColor.init(red: 0.101, green: 0.100, blue: 0.103, alpha: 1.000)
        var gradientDarkColor = UIColor.init(red: 0.237, green: 0.242, blue: 0.242, alpha: 1.000)
        if self.isHighlighted {
            gradientLightColor = gradientLightColor.darkerColor()!
            gradientDarkColor = gradientDarkColor.lightterColor()!
        }
        
        let gradientColors:Array = [gradientLightColor.cgColor,gradientDarkColor.cgColor]
        var locations:[CGFloat] = [0,1]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: &locations)
        
        let insetRect = rect.insetBy(dx: 2.0, dy: 2.0)
        
        //Draw Bezel
        context!.setFillColor(strokeColor.cgColor)
        context!.fillEllipse(in: insetRect)
        
        let midX = insetRect.midX
        let midY = insetRect.minY
        
        //Draw Bezel Light Shadow Layer
        context!.addArc(center: CGPoint.init(x: midX, y: midY), radius: insetRect.width / 2, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        context!.setShadow(offset: CGSize.init(width: 0, height: 0.5), blur: 2.0, color: UIColor.darkGray.cgColor)
        context!.fillPath()
        
        // Add Cliping Region for Konb Background
        context!.addArc(center: CGPoint.init(x: midX, y: midY), radius: (insetRect.width - 6) / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context!.clip()
        
        let startPoint = CGPoint.init(x: midX, y: insetRect.maxY)
        let endPoint = CGPoint.init(x: midX, y: insetRect.minY)
        
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))

    }
}

extension THControlKnob{
    
    func clampAngle(angle:Float) -> Float {
        return ((value! - minimumValue) / (maximumValue - minimumValue) - 0.5) * (kMaxAngle * 2)
    }
    
    func angleForValue(angle:Float) -> Float {
        return (angle / (kMaxAngle * 2) + 0.5) * (maximumValue - minimumValue) + minimumValue;
    }
    
    func valueForAngle(angle:Float) -> Float {
        return (angle / (kMaxAngle * 2) + 0.5) * (maximumValue - minimumValue) + minimumValue;
    }
    
    func valueForPosition(point:CGPoint) -> Float {
        let delta:Float = Float(touchOrigin!.y - point.y)
        let newAngle = clampAngle(angle: delta * kScalingFactor + angle)
        return valueForAngle(angle: newAngle)
    }
    
    func setValue(newValue:Float) {
        setValue(newValue: newValue, animation: false)
    }
    
    func setValue(newValue:Float,animation:Bool)   {
        let oldValue = value
        if newValue < self.minimumValue {
            value = self.minimumValue
        }else if newValue > self.maximumValue{
            value = self.maximumValue
        }else{
            value = newValue
        }
        valueDidChangeFrom(oldValue: oldValue!, to: newValue, animated: true)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point:CGPoint = touch.location(in: self)
        touchOrigin = point
        angle = angleForValue(angle: value!)
        self.isHighlighted = true
        setNeedsDisplay()
        return true
    }

    
    func handleTouch(touch:UITouch) -> Bool {
        if touch.tapCount > 1 {
            setValue(newValue: self.defaultValue, animation: true)
            return false
        }
        let point = touch.location(in: self)
        value = valueForPosition(point: point)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if  handleTouch(touch: touch) {
            sendActions(for: UIControl.Event.valueChanged)
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        handleTouch(touch: touch!)
        sendActions(for: UIControl.Event.valueChanged)
        self.isHighlighted = false
        setNeedsDisplay()
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
        }
        return nil
    }
    func lightterColor() -> UIColor? {
        var hue:CGFloat = 0.0
        var staturation:CGFloat = 0.0
        var brightness:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        if self.getHue(&hue, saturation: &staturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue, saturation: staturation, brightness: brightness * 0.92, alpha: alpha)
        }
        return nil
    }
}
