//
//  NNDBManager.swift
//  LeigodAPM
//
//  Created by xyk on 2024/6/17.
//

import Foundation
import WCDBSwift



struct NNDBPath {
    
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                     .userDomainMask,
                                                     true).last! + "/NN/RGDB.db"
}



open class NNDBManager: NSObject {
    
    public typealias CompleteBlock = (Bool) -> Void
    
    public static let share = NNDBManager()
    
    let dataBasePath = URL(fileURLWithPath: NNDBPath().dbPath)
    var dataBase: Database?
    
    private override init() {
        super.init()
        dataBase = createDb()
    }
    ///创建db
    private func createDb() -> Database {
        debugPrint("数据库路径==\(dataBasePath.absoluteString)")
        return Database(withFileURL: dataBasePath)
    }
    
    // 判断表是否存在
    public func isTableExists(table: String) -> Bool {
        do {
            guard let isExist = try dataBase?.isTableExists(table) else {
                return false
            }
            return isExist
        } catch let error {
            return false
        }
    }
    
    ///创建表
    public func createTable<T: TableDecodable>(table: String, of ttype:T.Type, complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.create(table: table, of:ttype)
            complete?(true)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
            complete?(false)
        }
    }
    ///插入
    public func insertToDb<T: TableEncodable>(objects: [T] ,intoTable table: String, complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.insert(objects: objects, intoTable: table)
            complete?(true)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    ///插入 存在即替换
    public func insertOrReplaceToDb<T: TableEncodable>(objects: [T] ,intoTable table: String, complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.insertOrReplace(objects: objects, intoTable: table)
            complete?(true)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    ///修改
    public func updateToDb<T: TableEncodable>(table: String, on propertys:[PropertyConvertible],with object:T,where condition: Condition? = nil, complete: CompleteBlock? = nil) -> Void{
        do {
            try dataBase?.update(table: table, on: propertys, with: object,where: condition)
            complete?(true)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    ///删除
    public func deleteFromDb(fromTable: String, where condition: Condition? = nil, complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.delete(fromTable: fromTable, where:condition)
            complete?(true)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    ///查询
    public func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    ///删除数据表
    public func dropTable(table: String, complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.drop(table: table)
            complete?(true)
        } catch let error {
            debugPrint("drop table error \(error)")
            complete?(false)
        }
    }
    
    /// 删除所有与该数据库相关的文件
    public func removeDbFile(complete: CompleteBlock? = nil) -> Void {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
                complete?(true)
            })
        } catch let error {
            debugPrint("not close db \(error)")
            complete?(false)
        }
    }
}


extension NNDBManager {
    // insert 和 insertOrReplace 函数只有函数名不同，其他参数都一样。
    public func insert<T: TableEncodable>(
        objects: [T], // 需要插入的对象。WCDB Swift 同时实现了可变参数的版本，因此可以传入一个数组，也可以传入一个或多个对象。
        on propertyConvertibleList: [PropertyConvertible]? = nil, // 需要插入的字段
        intoTable table: String, // 表名
        complete: CompleteBlock? = nil
        ) {
        do {
            try dataBase?.insert(objects: objects, on: propertyConvertibleList, intoTable: table)
            complete?(true)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    //更新
    public func update<T: TableEncodable>(
        table: String,
        on propertyConvertibleList: [PropertyConvertible],
        with object: T,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil,
        complete: CompleteBlock? = nil) {
        do {
            try dataBase?.update(table: table, on: propertyConvertibleList, with: object, where: condition, orderBy: orderList, limit: limit, offset: offset)
            complete?(true)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    ///删除
    public func delete(fromTable table: String, // 表名
        where condition: Condition? = nil, // 符合删除的条件
        orderBy orderList: [OrderBy]? = nil, // 排序的方式
        limit: Limit? = nil, // 删除的个数
        offset: Offset? = nil, // 从第几个开始删除
        complete: CompleteBlock? = nil) {
        do {
            try dataBase?.delete(fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
            complete?(true)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
            complete?(false)
        }
    }
    
    //查询
    
    public func getObjects<T: TableDecodable>(
        on propertyConvertibleList: [PropertyConvertible],
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> [T]? {
        var list:[T]?
        do {
            try list = dataBase?.getObjects(on: propertyConvertibleList, fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
        } catch let error {
            debugPrint("getObjects error \(error.localizedDescription)")
        }
        return list
    }
}
