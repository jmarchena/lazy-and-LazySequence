import Foundation

// Based on http://alisoftware.github.io/swift/2016/02/28/being-lazy/

// Lazy var
class Wagon {
    var numberOfSeats: Int

    init(seats: Int) {
        self.numberOfSeats = seats
    }
}

class Train {
    // This is only evaluated when accessed
    lazy var numberOfPassengers: Int = { // This is @noescape by default
        // As this is lazy, we can reference self here as this is computed once self is fully initialized
        return self.numberOfWagons * self.wagon.numberOfSeats
    }()
    var numberOfWagons: Int
    var wagon: Wagon

    init(wagons: Int, wagon: Wagon) {
        self.numberOfWagons = wagons
        self.wagon = wagon
    }
}

// Lazy let? It doesn't exist (yet?) But let constants declared at global scope are autamatically lazy (not in a playground)
let biggestFGCStation: String = {
    print("Global constant initialized")
    return "Sarria"
}()

// The same happens with constants declared as type property
class Car {
    static let defaultBrand: String = {
        print("Type constant initialized")
        return "Mini"
    }()
}

// The use of a static let inside a class is the recommended way to create singletons in Swift (using a private init),
// as static let is both lazy, thread-safe, and only created once
class Foo {
    static let sharedFoo = Foo()
    private init() {}
}

var car: Car = Car()
Car.defaultBrand

// Lazy sequences
func increment(x: Int) -> Int {
    print("Computing next value of \(x)")
    return x+1
}

// This applies the function stright away
let array = Array(0..<1000)
let incArray = array.map(increment)
print("Result:")
print(incArray[0], incArray[4])

// Using lazy will only execute the function when the entry is accessed, not before, and only for this one!
let array2 = Array(0..<1000)
let incArray2 = array2.lazy.map(increment)
print("Result:")
print(incArray2[0], incArray2[4])


func double(x: Int) -> Int {
    print("Computing double value of \(x)…")
    return 2*x
}

// Chaining lazy sequences
let doubleArray = array.lazy.map(increment).map(double)
print(doubleArray[3])
