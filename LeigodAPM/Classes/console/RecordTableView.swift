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
    var tableView: UITableView?
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
        let cell = tableView.dequeueReusableCell({ (cell:RecordTableViewCell) in
            
        })
        // 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                guard let tableView = tableView else { return }
                let location = gestureRecognizer.location(in: tableView)
                if let indexPath = tableView.indexPathForRow(at: location) {
                    let cell = tableView.cellForRow(at: indexPath) as? RecordTableViewCell
                    if let textToCopy = cell?.logTextView.text {
                        // 复制文本到剪贴板
                        UIPasteboard.general.string = textToCopy
                        
                        // 显示提示信息
                        let alert = UIAlertController(title: nil, message: "已复制", preferredStyle: .alert)
                        tableView.getViewController()?.present(alert, animated: true)
                        // 1秒后自动消失
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
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

