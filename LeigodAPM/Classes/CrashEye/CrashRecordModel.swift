//
//  CrashRecordModel.swift
//  Pods
//
//  Created by zixun on 16/12/28.
//
//

import Foundation
import WCDBSwift

public final class CrashRecordModel: TableCodable {

    var type: Int = 0
    var name: String = ""
    var reason: String = ""
    var appinfo: String = ""
    var time: String = ""
    var callStack: String = ""

    convenience init(model: CrashModel) {
        self.init()
        self.type = model.type.rawValue
        self.name = model.name
        self.time = model.time
        self.reason = model.reason
        self.appinfo = model.appinfo
        self.callStack = model.callStack
    }

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = CrashRecordModel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case type
        case name
        case time
        case reason
        case appinfo
        case callStack

    }
}

extension CrashRecordModel {
    func attributeString() -> NSAttributedString {
        return CrashRecordViewModel(self).attributeString()
    }
}
