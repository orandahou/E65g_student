//
//  StatisticsViewController.swift
//  FinalProject
//
//  Created by Ash Raj on 5/4/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var numAlive: UILabel!
    @IBOutlet weak var numEmpty: UILabel!
    @IBOutlet weak var numBorn: UILabel!
    @IBOutlet weak var numDied: UILabel!
    
    var engine: StandardEngine!

    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.calcStats()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calcStats()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calcStats() {
        var alive = 0, empty = 0, born = 0, died = 0
        for row in 0 ..< self.engine.grid.size.rows {
            for col in 0 ..< self.engine.grid.size.cols {
                switch self.engine.grid[row,col] {
                case .alive: alive += 1
                case .empty: empty += 1
                case .born: born += 1
                case .died: died += 1
                }
            }
        }
        self.numAlive.text = String(alive)
        self.numEmpty.text = String(empty)
        self.numBorn.text = String(born)
        self.numDied.text = String(died)
    }
}
