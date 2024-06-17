//
//  EyeCommonDefine.swift
//  RGCrashLog
//
//  Created by hsj007 on 2022/12/27.
//

import Foundation

extension UIFont {
    class func courier(with size: CGFloat) -> UIFont {
        return UIFont(name: "Courier", size: size)!
    }
    
    class func helvetica(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "HelveticaNeue-UltraLight", size: size) {
            return font
        }
        else{
            return UIFont.systemFont(ofSize: size)
        }
    }
}

// MARK: - 方便转NSString
extension String {
    public var NS: NSString { return (self as NSString) }
}

extension UITableView {
    func dequeueReusableCell<E: UITableViewCell>(style:UITableViewCell.CellStyle = UITableViewCell.CellStyle.default,
                             identifier:String = E.identifier(),
                             _ configure: (E) -> Void) -> E {
        var cell = self.dequeueReusableCell(withIdentifier: identifier) as? E
        if cell == nil {
            cell = E(style: style, reuseIdentifier: identifier)
            configure(cell!)
        }
        return cell!
    }
}

extension UITableViewCell {
    class func identifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
}

extension Double {
    func storageCapacity() -> (capacity:Double,unit:String) {
        
        let radix = 1000.0
        
        guard self > radix else {
            return (self,"B")
        }
        
        guard self > radix * radix else {
            return (self / radix,"KB")
        }
        
        guard self > radix * radix * radix else {
            return (self / (radix * radix),"MB")
        }
        
        return (self / (radix * radix * radix),"GB")
    }
}

class Store: NSObject {
    static let shared = Store()
    
    // 3.2(MB)
    private(set) var networkMB: Double = 0
    
    private var change:((Double)->())?
    func addNetworkByte(_ byte:Int64) {
        self.networkMB += Double(max(byte, -1))
        self.change?(self.networkMB);
    }
    
    func networkByteDidChange(change:@escaping (Double)->()) {
        self.change = change
        
        if self.networkMB > 0 {
            self.change?(self.networkMB);
        }
    }
}
