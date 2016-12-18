//
//  ResultsVC.swift
//  Genetic Algorithm
//
//  Created by Orlando Amorim on 13/12/16.
//  Copyright © 2016 Orlando Amorim. All rights reserved.
//

import Cocoa

class ResultsVC: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var bestTextField: NSTextField!
    
    var objects: [String] = [String]() 
    var bestChromossome:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bestTextField.stringValue = bestChromossome
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return objects.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        // get the NSTableCellView for the column
        let result : NSTableCellView = tableView.make(withIdentifier: "cell", owner: self) as! NSTableCellView
        
        // set the string value of the text field in the NSTableCellView
        result.textField?.stringValue = objects[row]

        // return the populated NSTableCellView
        return result
        
    }

    
}
