//
//  CrashRecordViewModel.swift
//  Pods
//
//  Created by zixun on 16/12/28.
//
//

import Foundation

class CrashRecordViewModel: BaseRecordViewModel {
    private(set) var model:CrashRecordModel!
    
    init(_ model:CrashRecordModel) {
        super.init()
        self.model = model
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        result.append(self.nameString())
        result.append(self.reasonString())
        result.append(self.appinfoString())
        result.append(self.callStackString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let type = self.model.type == CrashModelType.exception.rawValue ? "Exception" : "SIGNAL"
        return self.headerString(with: "CRASH", content: type, color: UIColor(nnhex: 0xDF1921))
    }
    
    private func nameString() -> NSAttributedString {
        return self.contentString(with: "NAME", content: self.model.name)
    }
    
    private func reasonString() -> NSAttributedString {
        return self.contentString(with: "REASON", content: self.model.reason)
    }
    
    private func appinfoString() -> NSAttributedString {
        return self.contentString(with: "APPINFO", content: self.model.appinfo)
    }
    
    private func callStackString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "CALL STACK", content: self.model.callStack))
        let  range = result.string.NS.range(of: self.model.callStack)
        if range.location != NSNotFound {
            let att = [NSAttributedString.Key.font:UIFont.courier(with: 10),
                       NSAttributedString.Key.foregroundColor:UIColor.white] as! [NSAttributedString.Key : Any]
            result.setAttributes(att, range: range)
            
            
        }
        return result
    }
}
