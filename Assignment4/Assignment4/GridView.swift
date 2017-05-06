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
    
    @IBInspectable var size = 10
    
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
        (0 ... size + 1).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0) / CGFloat(size) * rect.size.width, y: 0.0),
                end: CGPoint(x: CGFloat($0) / CGFloat(size) * rect.size.width, y: rect.size.height)
            )
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0) / CGFloat(size) * rect.size.height),
                end: CGPoint(x: rect.size.width, y: CGFloat($0) / CGFloat(size) * rect.size.height)
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
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
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
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        
        return GridPosition(row: Int(row), col: Int(col))
    }
    
}
