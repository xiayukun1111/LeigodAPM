//
//  EyesManager.swift
//  Pods
//
//  Created by zixun on 17/1/18.
//
//

import Foundation

public class EyesManager: NSObject {
    
    public static let tabString = "CrashRecordModel"
    
    public static let shared = EyesManager()
    
    /// 是否显示FPS悬浮窗
    var isShowFPS: Bool = false {
        didSet {
            if isShowFPS {
//                UIApplication.getKeyWindow().addSubview(settingView)
                UIApplication.shared.keyWindow?.addSubview(settingView)
                settingView.popBig()
            }else {
//                UIApplication.shared.keyWindow?.remove
                settingView.removeFromSuperview()
            }
        }
    }
    
    /// fps值
    var fps: String = "" {
        didSet {
            if isShowFPS {
                settingView.title = fps
            }
        }
    }
    
    public override init() {
        super.init()
        self.createTable()
    }
    
    // MARK: setter && getter
    
    private lazy var settingView: NNHoverView = {
        let view = NNHoverView(frame: CGRect(x: UIScreen.main.bounds.size.width - 50, y: 100, width: 50, height: 50))
        view.addCorner(radius: 25)
        view.backgroundColor = .lightGray
        view.titleColor = .blue
        view.title = ""
        view.font = UIFont.helvetica(13)
        return view
    }()
}

//--------------------------------------------------------------------------
// MARK: - CRASH
//--------------------------------------------------------------------------
extension EyesManager {
    
    public func createTable() {
        NNDBManager.share.createTable(table: EyesManager.tabString, of: CrashRecordModel.self) {          [weak self] value in
            if let weakSelf = self, value == true {
                CrashEye.add(delegate: weakSelf)
            }
        }
    }
    
    public func closeCrashEye() {
        CrashEye.remove(delegate: self)
    }
}

//MARK: - CrashEye
extension EyesManager: CrashEyeDelegate {
    
    /// god's crash eye callback
    public func crashEyeDidCatchCrash(with model:CrashModel) {
        let model = CrashRecordModel(model: model)
        NNDBManager.share.insert(objects: [model], intoTable: EyesManager.tabString)
    }
}

