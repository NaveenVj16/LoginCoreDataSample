//
//  commonExtensions.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
   
    func splashViewController() -> SplashViewController {
        return UIStoryboard(name: "Splash", bundle:nil).instantiateViewController(withIdentifier: "SplashViewController")  as! SplashViewController
    }
    
    func loginViewController() -> LoginViewController {
            return UIStoryboard(name: "Login", bundle:nil).instantiateViewController(withIdentifier: "LoginViewController")  as! LoginViewController
       }
    
    func signUpViewController() -> SignUpViewController {
         return UIStoryboard(name: "Login", bundle:nil).instantiateViewController(withIdentifier: "SignUpViewController")  as! SignUpViewController
    }
    
    func homeViewController() -> HomeViewController {
         return UIStoryboard(name: "Home", bundle:nil).instantiateViewController(withIdentifier: "HomeViewController")  as! HomeViewController
    }
    func mapViewController() -> MapViewController {
         return UIStoryboard(name: "Home", bundle:nil).instantiateViewController(withIdentifier: "MapViewController")  as! MapViewController
    }
}
    
extension UIColor {
    
    // You can directly make some static color using this way.
    static let kAppTheme = UIColor(red: 123, green: 56, blue: 243)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func colorWithHex(hex: String) -> UIColor {
        
        var colorString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove prefix if contain # at 0th position.
        if colorString.hasPrefix("#") { colorString.remove(at: colorString.startIndex) }
        if colorString.count != 6 { return UIColor.gray }
        
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        
        return UIColor (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    struct AppColor {
        struct Green {
            static let Fern = UIColor(netHex: 0x6ABB72)
            static let MountainMeadow = UIColor(netHex: 0x3ABB9D)
            static let ChateauGreen = UIColor(netHex: 0x4DA664)
            static let PersianGreen = UIColor(netHex: 0x2CA786)
        }
    }
    
    static var random: UIColor {
        let max = CGFloat(UInt32.max)
        let red = CGFloat(arc4random()) / max
        let green = CGFloat(arc4random()) / max
        let blue = CGFloat(arc4random()) / max
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

    extension UIView {
      
    
      func applyShadowView(color:UIColor,radius:CGFloat,cornerRadius:CGFloat, alpha: Float = 1.0) {
          self.layer.masksToBounds = false;
          self.layer.shadowColor = color.cgColor
          self.layer.shadowOpacity = alpha;
          self.layer.shadowRadius = radius;
          self.layer.shadowOffset = CGSize(width: -1, height: 1)
          self.layer.cornerRadius = cornerRadius
      }
      
      func shadowViewNew(shadowLayer:CAShapeLayer,cornerRadius:CGFloat,fillColor:UIColor){
                  
              shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
              shadowLayer.fillColor = fillColor.cgColor

              shadowLayer.shadowColor = UIColor.black.cgColor
              shadowLayer.shadowPath = shadowLayer.path
              shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
              shadowLayer.shadowOpacity = 0.2
              shadowLayer.shadowRadius = 3

              layer.insertSublayer(shadowLayer, at: 0)
          }
      }
 
  public  func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateValue = dateFormatter.date(from: date)
        
        if date == nil{
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
           dateValue = dateFormatter.date(from: date)
        }
        dateFormatter.dateFormat = "dd MMM yyyy"
        if dateValue == nil {
            return ""
        }
        return  dateFormatter.string(from: dateValue!)

    }
public func isPasswordValid(_ password : String) -> Bool {
       
       let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
       return passwordTest.evaluate(with: password)
   }
public func stringFromDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = NSTimeZone.local
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedString = dateFormatter.string(from: date)
        return convertedString
    }

public func showToast(inView view: UIView, withTitle title: String = "", withMessage message: String, dismissDelay: TimeInterval = 3.0, position: CGPoint? = nil) {
    var style = ToastStyle()
    style.messageColor =  UIColor.white
    style.backgroundColor = UIColor.darkGray
    if let pos = position {
        view.makeToast(message, duration: dismissDelay, position: pos, style: style)
    } else {
        view.makeToast(message, duration: dismissDelay, position: .bottom, style: style)
    }
}

