//
//  GridView.swift
//  Assignment4
//
//  Created by Ash Raj on 5/5/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
}

@IBDesignable class GridView: UIView {
    
    @IBInspectable var rows = 10
    @IBInspectable var cols = 10
    
    var gridDataSource: GridViewDataSource?
    
    @IBInspectable var livingColor = UIColor()
    @IBInspectable var bornColor = UIColor()
    @IBInspectable var emptyColor = UIColor()
    @IBInspectable var diedColor = UIColor()
    @IBInspectable var gridColor = UIColor()
    
    @IBInspectable var gridWidth = CGFloat()
    
    override func draw(_ rect: CGRect) {
        drawLines(rect)
        drawOvals(rect)
    }
    
    func drawLines(_ rect: CGRect) {
        (0 ... rows + 1).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0) / CGFloat(rows) * rect.size.width, y: 0.0),
                end: CGPoint(x: CGFloat($0) / CGFloat(rows) * rect.size.width, y: rect.size.height)
            )
        }
        (0 ... cols + 1).forEach {
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0) / CGFloat(cols) * rect.size.height),
                end: CGPoint(x: rect.size.width, y: CGFloat($0) / CGFloat(cols) * rect.size.height)
            )
        }
    }
    
    func drawLine(start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: start)
        path.addLine(to: end)
        gridColor.setStroke()
        path.stroke()
    }
    
    func drawOvals(_ rect: CGRect) {
        let ovalSize = CGSize(
            width: rect.size.width / CGFloat(rows),
            height: rect.size.height / CGFloat(cols)
        )
        (0 ..< cols).forEach { i in
            (0 ..< rows).forEach { j in
                let ovalOrigin = CGPoint(
                    x: rect.origin.x + (CGFloat(j) * ovalSize.width + gridWidth),
                    y: rect.origin.y + (CGFloat(i) * ovalSize.height + gridWidth)
                )
                let ovalSize = CGSize(
                    width: ovalSize.width - (gridWidth * 2),
                    height: ovalSize.height - (gridWidth * 2)
                )
                let ovalRect = CGRect(origin: ovalOrigin, size: ovalSize)
                let path = UIBezierPath(ovalIn: ovalRect)
                
                if let grid = gridDataSource {
                    switch grid[(i,j)] {
                    case .alive: livingColor.setFill()
                    case .empty: emptyColor.setFill()
                    case .born: bornColor.setFill()
                    case .died: diedColor.setFill()
                    }
                }
                
                path.fill()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        let touchY = touches.first!.location(in: self.superview).y
        let touchX = touches.first!.location(in: self.superview).x
        guard touchX > frame.origin.x && touchX < (frame.origin.x + frame.size.width) else { return nil }
        guard touchY > frame.origin.y && touchY < (frame.origin.y + frame.size.height) else { return nil }
        
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        
        //************* IMPORTANT ****************
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        //****************************************
        
        if gridDataSource != nil {
            gridDataSource![pos.row, pos.col] = gridDataSource![pos.row, pos.col].isAlive ? .empty : .alive
            setNeedsDisplay()
        }
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(rows)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(cols)
        
        return GridPosition(row: Int(row), col: Int(col))
    }
    
}
