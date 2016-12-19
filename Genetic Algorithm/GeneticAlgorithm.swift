//
//  GeneticAlgorithm.swift
//  Genetic Algorithm
//
//  Created by Orlando Amorim on 13/12/16.
//  Copyright © 2016 Orlando Amorim. All rights reserved.
//

import Foundation

public enum OperatorSelection {
    case Roulette
    case Tournament
}

class GeneticAlgorithm: NSObject {
    var numberGenerations: Int = Int()
    var populationSize: Int = Int()
    var crossoverTax: Double = Double()
    var mutationChance: Double = Double()
    var chromossomeSize: Int = Int()
    var tournamentSize: Int = Int()
    var cities: [Int : [Int]] = [Int : [Int]]()
    var population:[Chromossome] = [Chromossome]()
    var operatorSelection: OperatorSelection = .Roulette
    var errorTax: Double = Double()
    
    init(numberGenerations: Int = 100, populationSize: Int = 50, crossoverTax: Double = 0.5, mutationChance: Double = 0.1, chromossomeSize: Int = 5, tournamentSize: Int = 3, operatorSelection: OperatorSelection = .Roulette, cities: [Int: [Int]]) {
        self.numberGenerations = numberGenerations
        self.populationSize = populationSize
        self.crossoverTax = crossoverTax
        self.mutationChance = mutationChance
        self.chromossomeSize = chromossomeSize
        self.tournamentSize = tournamentSize
        self.operatorSelection = operatorSelection
        super.init()

        self.errorTax = 0.01
        self.cities = cities
        
        self.intializePopulation()
        self.population = self.fitness(in: population)
    }
    
    func intializePopulation() {
        for _ in 0...populationSize {
            var c = Chromossome(crossoverTax: self.crossoverTax, mutationChance: self.mutationChance, chromossomeSize: self.chromossomeSize)
            c = self.verifySon(in: c)
            self.population.append(c)
        }
    }
    
    func verifySon(in chromossome: Chromossome) -> Chromossome {
        var rg: Bool = false
        for i in 0..<chromossome.routes.count-1 {
            if (self.cities[chromossome.routes[i]]![chromossome.routes[i + 1] - 1] == -1) {
                rg = true
            }
        }
        
        if (chromossome.routes.first != chromossome.routes.last) {
            rg = true
        }
        
        for i in 0..<self.chromossomeSize {
            for j in (i+1)..<self.chromossomeSize {
                if chromossome.routes[i] == chromossome.routes[j] {
                    rg = true
                }
            }
        }
        
        if rg == true {
            chromossome.routes = (1...self.chromossomeSize).map{_ in Int.random(lower: 1, upper: self.chromossomeSize + 1)}
            chromossome.routes.append(chromossome.routes[0])
            _ = self.verifySon(in: chromossome)
        }
        
        return chromossome
    }
    
    func fitness(in population: [Chromossome]) -> [Chromossome] {
        for c in population {
            c.absoluteFitness = 0.0
            c.relativeFitness = 0.0
            for i in 0..<self.chromossomeSize {
                c.absoluteFitness += Double(self.cities[c.routes[i]]![c.routes[i + 1] - 1])
            }
            c.relativeFitness = 1.0/c.absoluteFitness
        }
        return population
    }
    
    
    func tournament() -> Chromossome {
        var population: [Chromossome] = [Chromossome]()
        var bIndex: Double = 0.0
        var bFitness: Double = 0.0
        
        for i in 0..<self.tournamentSize {
            population.append(self.population[Int(drand48() * Double(self.populationSize))])
            if population[i].absoluteFitness > bFitness {
                bIndex = Double(i)
                bFitness = population[i].relativeFitness
            }
        }
        return population[Int(bIndex)]
    }
    
    func roulette() -> Chromossome {
        var i = 0
        var j = 0
        var auxSom: Double = 0
        let upperBoundary: Double = drand48() * self.sumRelativeFitness()
    
        while auxSom < upperBoundary && i < self.populationSize{
            auxSom += self.population[i].relativeFitness
            i += 1
        }
        j = i - 1
        
        return self.population[j]
        
    }
    
    func sumRelativeFitness() -> Double {
        var value: Double = 0.0
        for c in self.population {
            value += c.relativeFitness
        }
        return value
    }
    
    func makeGenerarions() {
        var newPopulation:[Chromossome] = [Chromossome]()
        var sons: [Chromossome] = [Chromossome]()
        
        while newPopulation.count < self.population.count {
            if operatorSelection == .Tournament {
                let fatherOne = self.tournament()
                let fatherTwo = self.tournament()
                sons = fatherOne.crossover(routes: fatherTwo.routes)
                
            }else if operatorSelection == .Roulette {
                let fatherOne = self.roulette()
                let fatherTwo = self.roulette()
                sons = fatherOne.crossover(routes: fatherTwo.routes)
            }
            
            for var son in sons {
                son.mutation()
                son = verifySon(in: son)
                newPopulation.append(son)
            }
        }
        
        self.population = newPopulation
        self.population = fitness(in: population)
    
    }
    
    //HELPERS
    
    func getBest(chromossome inPopulation: [Chromossome]) -> Chromossome {
        var chromossome: Chromossome?
        var bestFitness: Double = 0.0
        for i in 0..<inPopulation.count {
            if inPopulation[i].relativeFitness > bestFitness {
                chromossome = inPopulation[i]
                bestFitness = inPopulation[i].relativeFitness
            }
        }
        return chromossome!
    }
    
    func getBest() -> Chromossome {
        var chromossome: Chromossome?
        var bestFitness: Double = 0.0
        for i in 0..<population.count {
            if population[i].relativeFitness > bestFitness {
                chromossome = population[i]
                bestFitness = population[i].relativeFitness
            }
        }
        return chromossome!
    }
    
    
    func calculateAverage(in population: [Chromossome]) -> Double {
        var average: Double = 0.0
        
        for c in population {
            average += c.relativeFitness
        }
        
        average = average / Double(population.count)
        
        return average
    }
    
    func verifyConvergence() -> Bool {
        var convergence:Bool = false
        let chromossome = getBest(chromossome: self.population)
        
        if (chromossome.relativeFitness - self.calculateAverage(in: self.population)) < self.errorTax {
            convergence = true
        }
        return convergence
    }
        
    func start() -> (populations: [String], bestChromossome: Chromossome) {
        var populations: [String] = [String]()
        var generation_index = 1

        while /*verifyConvergence() != false && */(generation_index < numberGenerations) {
            self.makeGenerarions()
            generation_index += 1
            populations.append("Generation \(generation_index)")
            for p in population {
                populations.append(p.description)
            }
        }
        return (populations, getBest(chromossome: self.population))
    }
}
