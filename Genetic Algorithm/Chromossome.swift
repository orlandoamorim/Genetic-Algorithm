//
//  Chromossome.swift
//  Genetic Algorithm
//
//  Created by Orlando Amorim on 13/12/16.
//  Copyright © 2016 Orlando Amorim. All rights reserved.
//

import Foundation


class Chromossome: NSObject {
    var crossoverTax: Double = Double()
    var mutationChance: Double = Double()
    var chromossomeSize: Int = Int()
    var relativeFitness: Double = 0
    var absoluteFitness: Double = 0
    var routes:[Int] = [Int]()
    
    init(crossoverTax: Double, mutationChance: Double, chromossomeSize: Int) {
        self.crossoverTax = crossoverTax
        self.mutationChance = mutationChance
        self.chromossomeSize = chromossomeSize
        super.init()
        self.routes = (1...self.chromossomeSize).map{_ in Int.random(lower: 1, upper: self.chromossomeSize + 1)}
        self.routes.append(routes[0])
    }

    /**
     It makes the crossover with this Chromossome and another.
     
     To use it, simply call crossover([1,2,3])
     
     :param: routes The routes values from the another crommossome you want to do crossover.
     
     :returns:   [Chromossome]
     */
    func crossover(routes: [Int]) -> [Chromossome] {
        var newRoutes: [Chromossome] = [Chromossome]()
        let cutPoint = Int(drand48() * Double(self.chromossomeSize))
        
        let sonOne = Chromossome(crossoverTax: self.crossoverTax, mutationChance: self.mutationChance, chromossomeSize: self.chromossomeSize)
        let sonTwo = Chromossome(crossoverTax: self.crossoverTax, mutationChance: self.mutationChance, chromossomeSize: self.chromossomeSize)
        
        if drand48() < self.crossoverTax {
            sonOne.routes = Array(self.routes[0...cutPoint]) + Array(routes[cutPoint...routes.endIndex-1])
            sonTwo.routes = Array(routes[0...cutPoint]) + Array(self.routes[cutPoint...self.routes.endIndex-1])
        } else {
            sonOne.routes = self.routes
            sonTwo.routes = self.routes
        }
        newRoutes.append(sonOne)
        newRoutes.append(sonTwo)
        return newRoutes
    }
    
    
    /**
     It makes the mutation.
     */
    
    func mutation() {
        for i in 0...chromossomeSize {
            if drand48() < self.mutationChance {
                self.routes[i] = Int(drand48() * Double(self.chromossomeSize)) + 1 // Mutation Value
            }
        }
    }
    

    override var description : String {
        return "Routes: \(self.routes) | Relative Fitness: \(self.relativeFitness) | Absolute Fitness: \(self.absoluteFitness)"
    }
    
}
