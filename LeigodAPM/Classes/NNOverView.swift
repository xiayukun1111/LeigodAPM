//
//  NNOverView.swift
//  LeigodAPM
//
//  Created by xyk on 2024/6/17.
//

import Foundation

/**
 悬浮视图
 */
public typealias VoidBlock = () -> Void
public class NNHoverView: UIView {
    /// 事件处理
    public var handle: VoidBlock?
    /// 屏幕宽度
    private var screenW: CGFloat = UIScreen.main.bounds.size.width
    /// 屏幕高度
    private var screenH: CGFloat = UIScreen.main.bounds.size.height
    /// 悬浮view 大小
    private let size: CGSize = CGSize(width: 100, height: 100)
    /// 顶部最小 margin
    private let topMinMargin: CGFloat = 88
    /// 底部最小 margin
    private let bottomMinMargin: CGFloat = 88
    /// 左边最小 margin
    private let leftMinMargin: CGFloat = 20
    /// 右边最小 magin
    private let rightMinMargin: CGFloat = 20
    /// 拖动开始时 位置
    private var beginPoint: CGPoint = .zero
    
    /// 标题
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// 标题颜色
    public var titleColor: UIColor = .clear {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    /// 标题文字大小
    public var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
    }
    
    private let titleLabel = UILabel()
    
    /// 点击开始
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {return}
        let curPoint = touch.location(in: self)
        let prePoint = touch.previousLocation(in: self)
        let offsetX = curPoint.x - prePoint.x
        let offsetY = curPoint.y - prePoint.y
        let centerX = offsetX + self.center.x
        let centerY = offsetY + self.center.y
        /// 记录开始位置
        beginPoint = CGPoint(x: centerX, y: centerY)
    }
    
    /// 拖动
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {return}
        let curPoint = touch.location(in: self)
        let prePoint = touch.previousLocation(in: self)
        let offsetX = curPoint.x - prePoint.x
        let offsetY = curPoint.y - prePoint.y
        let centerX = offsetX + self.center.x
        let centerY = offsetY + self.center.y
        /// 拖动
        self.center = CGPoint(x: centerX, y: centerY)
    }
    
    /// 点击结束
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {return}
        let curPoint = touch.location(in: self)
        let prePoint = touch.previousLocation(in: self)
        let offsetX = curPoint.x - prePoint.x
        let offsetY = curPoint.y - prePoint.y
        let centerX = offsetX + self.center.x
        let centerY = offsetY + self.center.y
        let endPoint = CGPoint(x: centerX, y: centerY)
        /// 区分点击和拖动
        if endPoint == beginPoint { /// 点击
            handle?()
        } else { /// 拖动
            correctLocation()
        }
    }
    /// 修正位置 动画吸附在屏幕两侧
    func correctLocation() {
        var endCenter = center
        endCenter.x = center.x > screenW * 0.5 ? screenW-(rightMinMargin + size.width * 0.5) : (leftMinMargin + size.width * 0.5)
        if center.y < (topMinMargin + size.height * 0.5) {
            endCenter.y = (topMinMargin + size.height * 0.5)
        } else if center.y > screenH - (bottomMinMargin + size.height * 0.5) {
            endCenter.y = screenH - (bottomMinMargin + size.height * 0.5)
        }
        UIView.animate(withDuration: 0.25) {
            self.center = endCenter
        }
    }
    
    func setSubView() {
        self.backgroundColor = .red
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setSubView()

        titleLabel.frame = self.bounds
        titleLabel.backgroundColor = .clear
        titleLabel.text = "设置"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

