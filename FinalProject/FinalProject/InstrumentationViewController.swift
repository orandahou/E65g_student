//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by Ash Raj on 5/4/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

var sectionHeaders = [
    "Configurations"
]
var data = [[String: [[Int]]]]()

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet weak var colTextField: UITextField!
    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var tableView: UITableView!
    
    
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
        
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!) {
            (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            // Append configurations to data dictionary
            let jsonArray = json as! NSArray
            var innerData = [String: [[Int]]]()
            for jsonDictionary in jsonArray as! [NSDictionary] {
                let jsonTitle = jsonDictionary["title"] as! String
                let jsonContents = jsonDictionary["contents"] as! [[Int]]
                innerData[jsonTitle] = jsonContents
                data = [innerData]
            }
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepRowSize(_ sender: UIStepper) {
        engine.rows = Int(sender.value)
        engine.grid = Grid(Int(sender.value), Int(sender.value))
        rowTextField.text = String(engine.rows)
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
    
    @IBAction func plus(_ sender: UIBarButtonItem) {
        // Adapted from https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-uitextfield-to-a-uialertcontroller
        let alertController = UIAlertController(title: "Enter Configuration Title", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            self.engine.save(title: alertController.textFields![0].text!)
            self.tableView.reloadData()
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        let section = data[indexPath.section]
        label.text = Array(section.keys)[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let section = data[indexPath.section]
            let configValue = Array(section.keys)[indexPath.item]
            let cellPositions = data[0][configValue]!
            if let vc = segue.destination as? GridEditorViewController {
                vc.configValue = configValue
                vc.cellPositions = cellPositions
            }
        }
    }
    
}
