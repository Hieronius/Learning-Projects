// Индексы

import Foundation
import UIKit


func formatMoney(_ val:Double) -> String {
    let formater = NumberFormatter()
    formater.minimumFractionDigits = 2
    formater.maximumFractionDigits = 2
    return "$\(formater.string(from: NSNumber(value: val)) ?? "0")"
}
formatMoney(2.0)

let x = 1.234
let y = Double(round(100*x) / 100)

var formater = NumberFormatter()
formater.minimumFractionDigits = 2
formater.maximumFractionDigits = 2

let roundedValue1 = formater.string(from: 2.324234)
let roundedValue2 = formater.string(from: 2)



typealias Description = (coordinateX: Int, coordinateY: Int, color: String, place: String)


class Map {
    
    var mountains: Description = (1, 2, "red", "mountains")
    var river: Description = (5, 6, "green", "river")
    var custle: Description = (10, 11, "black", "custle")
    var wasteland: Description = (15, 16, "blue", "wasteland")
    var unknownPlace: Description = (20, 21, "yellow", "unknown place")
    
}

var map = Map()



protocol MainHero {
    var name: String { get set }
    var currentPosition: Description { get set }
    
    func move(direction: String)
    
    func attack(destination: MainHero)
}


class Hero: MainHero {
    var name: String
    var currentPosition: Description {
        didSet {
            print("The current position right now is \(currentPosition.0), \(currentPosition.1), \(currentPosition.2)")
        
        }
    }
    
    
    func move(direction: String) {
        
        
        
        switch direction {
        case "Custle":
            currentPosition.self = map.custle
            print("\(name.self) is currently in \(currentPosition.0), \(currentPosition.1) in the \(currentPosition.2) \(currentPosition.3)")
            
        case "Mountains":
            currentPosition.self = map.mountains
            print("\(name.self) is currently in \(currentPosition.0), \(currentPosition.1) in the \(currentPosition.2) \(currentPosition.3)")
            
        case "River":
            currentPosition.self = map.river
            print("\(name.self) is currently in \(currentPosition.0), \(currentPosition.1) in the \(currentPosition.2) \(currentPosition.3)")
            
        case "Wastelend":
            currentPosition.self = map.wasteland
            print("\(name.self) is currently in \(currentPosition.0), \(currentPosition.1) in the \(currentPosition.2) \(currentPosition.3)")
            
        case "Unknown place":
            currentPosition.self = map.unknownPlace
            print("\(name.self) is currently in \(currentPosition.0), \(currentPosition.1) in the \(currentPosition.2) \(currentPosition.3)")

        default: break
        }
        
    }
    
    
    func attack(destination: MainHero ) {
        if self.currentPosition == destination.currentPosition {
            print("The \(self.name) attacked the \(destination.name)")
        }
        
    }
    
    
    init(name: String, currentPosition: (Int, Int, String, String)) {
        self.name = name
        self.currentPosition = currentPosition
    }
    
}



var elves = Hero(name: "Elves", currentPosition: map.river)


var orcs = Hero(name: "Orcs", currentPosition: map.wasteland)


var demons = Hero(name: "Demons", currentPosition: map.unknownPlace)


var humans = Hero(name: "Humans", currentPosition: map.custle)


var dwarfs = Hero(name: "Dwarfs", currentPosition: map.mountains)






class Armies {
    var myArmies: [Hero] = []
    
    var listOfCoordinates = map
    
    
    func attack(army: Hero, destination: Hero) {
        if army.currentPosition == destination.currentPosition {
            print("The \(army.name) attack the \(destination.name)")
        }
        
    }
    
    
    subscript(army: Hero) -> Hero {
        var counter = -1
        
        for armies in myArmies {
            counter += 1
            
            if armies.name == army.name {
                print("You choose the \(armies.name)")
                break
            }
        }
        return myArmies[counter]
    }
    
    
}



var legion = Armies()


legion.myArmies.append(elves)
legion.myArmies.append(orcs)
legion.myArmies.append(demons)
legion.myArmies.append(humans)
legion.myArmies.append(dwarfs)

legion[orcs].attack(destination: )
/*
 
 for army in myArmy {
    if army.currentPosition == currentPosition {
        print("\(army.name) was attacked by \(name.self)")
    }
}
 
*/

