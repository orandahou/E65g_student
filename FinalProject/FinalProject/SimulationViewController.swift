//
//  SimulationViewController.swift
//  FinalProject
//
//  Created by Ash Raj on 5/4/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    @IBOutlet weak var gridView: GridView!
    
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        engine.delegate = self
        gridView.gridDataSource = self
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gridView.rows = engine.grid.size.rows
        gridView.cols = engine.grid.size.cols
        gridView.setNeedsDisplay()
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
    }

    @IBAction func next(_ sender: Any) {
        _ = engine.step()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: Any) {
        // Adapted from https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-uitextfield-to-a-uialertcontroller
        let alertController = UIAlertController(title: "Enter Configuration Title", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            self.engine.save(title: alertController.textFields![0].text!)
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        engine.reset()
        gridView.setNeedsDisplay()
    }

}
