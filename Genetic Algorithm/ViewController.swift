//
//  ViewController.swift
//  Genetic Algorithm
//
//  Created by Orlando Amorim on 13/12/16.
//  Copyright © 2016 Orlando Amorim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var numberGenerations: NSTextField!
    @IBOutlet weak var populationSize: NSTextField!
    @IBOutlet weak var crossoverTax: NSTextField!
    @IBOutlet weak var mutationChance: NSTextField!
    @IBOutlet weak var chromossomeSize: NSTextField!
    @IBOutlet weak var tournamentSize: NSTextField!
    @IBOutlet weak var operatorSelection: NSSegmentedControl!
    
    @IBOutlet weak var exempleSegemented: NSSegmentedControl!
    @IBOutlet weak var citiesRoutes: NSTextField!
    @IBOutlet weak var gaStartProgress: NSProgressIndicator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRestrictions()
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "Genetic Algorithm in Swift"
    }
    
    func addRestrictions() {
        let onlyIntFormatter = OnlyIntegerValueFormatter()
        numberGenerations.formatter = onlyIntFormatter
        populationSize.formatter = onlyIntFormatter
        crossoverTax.formatter = onlyIntFormatter
        mutationChance.formatter = onlyIntFormatter
        chromossomeSize.formatter = onlyIntFormatter
        tournamentSize.formatter = onlyIntFormatter
        operatorSelection.formatter = onlyIntFormatter

    }
    
    @IBAction func start(_ sender: NSButton) {
        
//        performSegue(withIdentifier: "ResultSegue", sender: nil)
    }
    
    func startGA() -> (populations: [String], bestChromossome: Chromossome) {
        return GeneticAlgorithm(numberGenerations: numberGenerations.stringValue != "" ? Int(numberGenerations.stringValue)! : 100,
                                                     populationSize: populationSize.stringValue != "" ? Int(populationSize.stringValue)! : 50,
                                                     crossoverTax: crossoverTax.stringValue != "" ? Double(crossoverTax.stringValue)! : 0.5,
                                                     mutationChance: mutationChance.stringValue != "" ? Double(mutationChance.stringValue)! : 0.1,
                                                     chromossomeSize: chromossomeSize.stringValue != "" ? Int(chromossomeSize.stringValue)! : 5,
                                                     tournamentSize: tournamentSize.stringValue != "" ? Int(tournamentSize.stringValue)! : 3,
                                                     operatorSelection: operatorSelection.selectedSegment == 0 ? .Roulette : .Tournament,
                                                     cities: getCity()).start()
    }

    func getCity() -> [Int : [Int]] {
        var t: [Int : [Int]] = [Int : [Int]]()
        var index = 1
        var citiesR:String = citiesRoutes.placeholderString!
        if citiesRoutes.stringValue != "" { citiesR = citiesRoutes.stringValue }
        for i in citiesR.components(separatedBy: "\n") {
            t[index] = String(i.characters.filter { !"\n\t\r".characters.contains($0) }).components(separatedBy: " ").map({ Int($0)! })
            index += 1
        }
        return t
    }

    @IBAction func changePlaceholderCity(_ sender: NSSegmentedControl) {
        
        switch sender.selectedSegment {
        case 0:
            citiesRoutes.placeholderString = "0 51 95 50 31\n51 0 6 39 69\n95 6 0 63 44\n50 39 63 0 44\n31 69 44 44 0"
        case 1:
            citiesRoutes.placeholderString = "0 2 -1 3 6\n2 0 4 3 -1\n-1 4 0 7 3\n3 3 7 0 3\n6 -1 3 3 0"
        case 2:
            citiesRoutes.placeholderString = "0 9 -1 -1 8 14\n9 0 14 -1 8 7\n-1 14 0 15 -1 8\n-1 -1 15 0 12 12\n8 8 -1 12 0 10\n14 7 8 12 10 0"
        default:
            citiesRoutes.placeholderString = "0 51 95 50 31\n51 0 6 39 69\n95 6 0 63 44\n50 39 63 0 44\n31 69 44 44 0"
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            gaStartProgress.startAnimation(nil)
            let resultsVC = segue.destinationController as! ResultsVC
            let v = startGA()
            resultsVC.objects = v.populations
            resultsVC.bestChromossome = v.bestChromossome.description
            gaStartProgress.stopAnimation(nil)
        }
    }
    
    
    
}
