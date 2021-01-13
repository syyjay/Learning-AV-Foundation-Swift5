//
//  THPlayButton.swift
//  AudioLooper_Swift
//
//  Created by nathan on 2020/12/25.
//

import UIKit

class THPlayButton: UIButton {

    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.clear
        tintColor = UIColor.clear
    }
    
    override var isHighlighted: Bool{
        set{
            super.isHighlighted = newValue
            setNeedsDisplay()
        }
        get{
            return super.isHighlighted
        }
    }
    
    override func draw(_ rect: CGRect) {
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        let strokeColor = UIColor.init(white: 0.06, alpha: 1)
        var gradientLightColor = UIColor.init(red: 0.101, green: 0.1, blue: 0.103, alpha: 1)
        var gradientDarkColor = UIColor.init(red: 0.237, green: 0.242, blue: 0.242, alpha: 1)
        if isHighlighted {
            gradientLightColor = gradientLightColor.darkerColor()!
            gradientDarkColor = gradientDarkColor.darkerColor()!
        }
        
        let gradientColors = [gradientLightColor.cgColor,gradientDarkColor.cgColor]
        var locations: [CGFloat] = [0,1]
        
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: &locations)!
        
        var insetRect = rect.insetBy(dx: 2.0, dy: 2.0)
        context!.setFillColor(strokeColor.cgColor)
        let bezelPath = UIBezierPath.init(roundedRect: insetRect, cornerRadius: 6)
        context!.addPath(bezelPath.cgPath)
        context!.setShadow(offset: CGSize.init(width: 0, height: 5), blur: 2.0, color: UIColor.darkGray.cgColor)
        context!.drawPath(using: CGPathDrawingMode.fill)
        
        context!.saveGState()
        
        insetRect = insetRect.insetBy(dx: 3.0, dy: 3.0)
        let buttonPath = UIBezierPath.init(roundedRect: insetRect, cornerRadius: 4)
        context!.addPath(buttonPath.cgPath)
        context!.clip()
        
        let midX = insetRect.midX
        
        let startPoint = CGPoint.init(x: midX, y: insetRect.maxY)
        let endPoint = CGPoint.init(x: midX, y: insetRect.minY)
        
        context!.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))
        
        
        context!.restoreGState()
        
        let fillColor = UIColor.init(white: 0.9, alpha: 1)
        context!.setFillColor(fillColor.cgColor)
        context!.setStrokeColor(fillColor.darkerColor()!.cgColor)
        
        
        let iconDim: CGFloat = 24
        if !self.isSelected {
            context!.saveGState()
            context!.translateBy(x: rect.midX - CGFloat((iconDim - 3) / 2), y: rect.midY - CGFloat(iconDim / 2))
            context!.move(to: CGPoint.init(x: 0, y: 0))
            context!.addLine(to: CGPoint.init(x: 0, y: iconDim))
            context!.addLine(to: CGPoint.init(x: iconDim, y: iconDim / 2))
            context!.closePath()
            context!.drawPath(using: CGPathDrawingMode.fill)
            context!.restoreGState()

        }else{
            context!.saveGState()
            let tx: CGFloat = (rect.width - iconDim) / 2
            let ty: CGFloat = (rect.height - iconDim) / 2
            context!.translateBy(x: tx, y: ty)
            let stopRect = CGRect.init(x: 0, y: 0, width: iconDim, height: iconDim)
            let stopPath = UIBezierPath.init(roundedRect: stopRect, cornerRadius: 2.0)
            context!.addPath(stopPath.cgPath)
            context!.drawPath(using: CGPathDrawingMode.fill)
            context!.restoreGState()
            
        }
        
        
        
    }
}
