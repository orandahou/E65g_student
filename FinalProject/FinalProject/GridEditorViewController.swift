//
//  GridEditorViewController.swift
//  Lecture11
//
//  Created by Van Simmons on 4/17/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource {
    
    var configValue: String?
    var cellPositions: [[Int]]?
    var saveClosure: ((String) -> Void)?
    
    @IBOutlet weak var configValueLabel: UILabel!
    @IBOutlet weak var gridView: GridView!
    
    var engine: StandardEngine!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        engine = StandardEngine.engine
        gridView.gridDataSource = self
        engine.reset()
        if let configValue = configValue {
            configValueLabel.text = configValue
        }
        if let cellPositions = cellPositions {
            for cellPosition in cellPositions {
                engine.grid[cellPosition[0], cellPosition[1]] = CellState.alive
            }
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
