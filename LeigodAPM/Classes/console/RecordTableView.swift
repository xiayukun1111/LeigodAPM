//
//  RecordTableView.swift
//  Pods
//
//  Created by zixun on 16/12/28.
//
//

import Foundation
//import RGWcdb

class RecordTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.backgroundColor = UIColor.niceBlack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RecordTableViewDataSource: NSObject {
    
    private let maxLogItems: Int = 1000
    
    fileprivate(set) var recordData = [CrashRecordModel]()
    
    fileprivate var dataArray = [CrashRecordModel]()

    override init() {
        super.init()
        dataArray = NNDBManager.share.getObjects(on: CrashRecordModel.Properties.all, fromTable: EyesManager.tabString) ?? [CrashRecordModel]()
    }
    
    func loadData(){
        self.recordData = dataArray.reversed()
    }
    
    func cleanRecord() {
        self.recordData.removeAll()
    }
}

extension RecordTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell({ (cell:RecordTableViewCell) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? RecordTableViewCell
        let model = self.recordData[indexPath.row]
        let attributeString = model.attributeString()
        cell?.configure(attributeString)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableView = tableView as! RecordTableView
        
        let width = tableView.bounds.size.width - 10
        let model = self.recordData[indexPath.row]
       let attributeString = model.attributeString()
        return RecordTableViewCell.boundingHeight(with: width, attributedText: attributeString)
    }
}

