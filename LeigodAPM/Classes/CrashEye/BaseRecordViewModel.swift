//
//  BaseRecordViewModel.swift
//  Pods
//
//  Created by zixun on 16/12/29.
//
//

import Foundation

class BaseRecordViewModel: NSObject {
    
    private(set) var attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font:UIFont.courier(with: 14)]
    
    func contentString(with prefex:String?,content:String?,newline:Bool = false,color:UIColor = UIColor(nnhex: 0x3D82C7)) -> NSAttributedString {
        let pre = prefex != nil ? "[\(prefex!)]:" : ""
        let line = newline == true ? "\n" : (pre == "" ? "" : " ")
        let str = "\(pre)\(line)\(content ?? "nil")\n"
        let result = NSMutableAttributedString(string: str, attributes: self.attributes)
        let range = str.NS.range(of: pre)
        if range.location != NSNotFound {
            result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return result
    }
    
    func headerString(with prefex:String,content:String? = nil,color:UIColor) -> NSAttributedString {
        let header = "> \(prefex): \(content ?? "")\n"
        let result = NSMutableAttributedString(string: header, attributes: self.attributes)
        
        let range = header.NS.range(of: prefex)
        if range.location + range.length <= header.NS.length {
            result.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        }
        return result
    }
}
