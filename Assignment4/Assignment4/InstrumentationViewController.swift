//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Ash Raj on 5/4/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet weak var colTextField: UITextField!
    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var refreshSlider: UISlider!
    
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        rowTextField.text = String(engine.rows)
        colTextField.text = String(engine.cols)
        rowStepper.value = Double(engine.rows)
        colStepper.value = Double(engine.cols)
        if engine.refreshRate > 0.0 {
            refreshSwitch.setOn(true, animated: true)
        } else {
            refreshSwitch.setOn(false, animated: true)
        }
        refreshSlider.value = Float(engine.refreshRate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepRowSize(_ sender: UIStepper) {
        engine.rows = Int(sender.value)
        engine.grid = Grid(Int(sender.value), Int(sender.value))
        rowTextField.text = String(engine.rows)
        _ = engine.step()
    }
    
    @IBAction func stepColSize(_ sender: UIStepper) {
        engine.cols = Int(sender.value)
        engine.grid = Grid(Int(sender.value), Int(sender.value))
        colTextField.text = String(engine.cols)
    }
    
    @IBAction func refreshSwitchToggle(_ sender: UISwitch) {
        if sender.isOn {
            engine.refreshRate = 1.0 / (Double(refreshSlider.value))
        } else {
            engine.refreshRate = 0.0
        }
    }
    
    @IBAction func refreshSliderMove(_ sender: UISlider) {
        if refreshSwitch.isOn {
            engine.refreshRate = 0.0
            engine.refreshRate = 1.0 / (Double(refreshSlider.value))
        } else {
            engine.refreshRate = 0.0
        }
    }
    
}
