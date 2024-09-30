import UIKit

//MARK: Question 5, Four Passengers and a Driver

/*
 A typical car can hold four passengers and one driver, allowing five people to travel around. Given n number of people, return how many cars are needed to seat everyone comfortably.

 carsNeeded(5) ➞ 1

 carsNeeded(11) ➞ 3

 carsNeeded(0) ➞ 0
 
 Borrowed from: edabit.com
 */

//Calling the function
// let numberOfCars = carsNeeded(...)
// print(numberOfCars)

func carsNeeded(_ people: Int) -> Int {
    let capacity = 5
    if people == 0 {
        return 0
    } else if people % capacity == 0 {
        return people / capacity
    } else {
        return people / capacity + 1
    }
}

// Calling the function
let numberOfCars1 = carsNeeded(5)
print(numberOfCars1)

let numberOfCars2 = carsNeeded(11)
print(numberOfCars2)

let numberOfCars3 = carsNeeded(0)
print(numberOfCars3)
