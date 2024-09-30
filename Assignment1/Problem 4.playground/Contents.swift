import UIKit

//MARK: Question 4, Remove the First and Last Characters

/*
 Create a function that removes the first and last characters from a string.
 
 removeFirstLast("hello") ➞ "ell"

 removeFirstLast("maybe") ➞ "ayb"

 removeFirstLast("benefit") ➞ "enefi"

 removeFirstLast("a") ➞ "a"
 
 Borrowed from: edabit.com
 
 HINT: remove(at: index)
 */

//Calling the function
// let removedFirstAndLast = removeFirstLast(...)
// print(removedFirstAndLast)

func removeFirstLast(_ str: String) -> String {
    var characters = Array(str)
    if characters.count > 2 {
        characters.remove(at: characters.count - 1)
        characters.remove(at: 0)
    }
    return String(characters)
}

// Calling the function
let removedFirstAndLast1 = removeFirstLast("hello")
print(removedFirstAndLast1)

let removedFirstAndLast2 = removeFirstLast("maybe")
print(removedFirstAndLast2)

let removedFirstAndLast3 = removeFirstLast("benefit")
print(removedFirstAndLast3)

let removedFirstAndLast4 = removeFirstLast("a")
print(removedFirstAndLast4)
