//
//  Chromosome.swift
//  Genetic Algorithm
//
//  Created by Orlando Amorim on 13/12/16.
//  Copyright © 2016 Orlando Amorim. All rights reserved.
//

import Foundation


class Chromosome: NSObject {
    var crossoverTax: Double = Double()
    var mutationChance: Double = Double()
    var chromosomeSize: Int = Int()
    var relativeFitness: Double = 0
    var absoluteFitness: Double = 0
    var routes:[Int] = [Int]()
    
    init(crossoverTax: Double, mutationChance: Double, chromosomeSize: Int) {
        self.crossoverTax = crossoverTax
        self.mutationChance = mutationChance
        self.chromosomeSize = chromosomeSize
        super.init()
        self.routes = (1...self.chromosomeSize).map{_ in Int.random(lower: 1, upper: self.chromosomeSize + 1)}
        self.routes.append(routes[0])
    }

    /**
     It makes the crossover with this Chromosome and another.
     
     To use it, simply call crossover([1,2,3])
     
     :param: routes The routes values from the another crommossome you want to do crossover.
     
     :returns:   [Chromosome]
     */
    func crossover(routes: [Int]) -> [Chromosome] {
        var newRoutes: [Chromosome] = [Chromosome]()
        let cutPoint = Int(drand48() * Double(self.chromosomeSize))
        
        let sonOne = Chromosome(crossoverTax: self.crossoverTax, mutationChance: self.mutationChance, chromosomeSize: self.chromosomeSize)
        let sonTwo = Chromosome(crossoverTax: self.crossoverTax, mutationChance: self.mutationChance, chromosomeSize: self.chromosomeSize)
        
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
        for i in 0...chromosomeSize {
            if drand48() < self.mutationChance {
                self.routes[i] = Int(drand48() * Double(self.chromosomeSize)) + 1 // Mutation Value
            }
        }
    }
    

    override var description : String {
        return "Routes: \(self.routes) | Relative Fitness: \(self.relativeFitness) | Absolute Fitness: \(self.absoluteFitness)"
    }
    
}
