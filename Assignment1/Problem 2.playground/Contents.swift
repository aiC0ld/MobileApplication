import UIKit

//MARK: Question 2, Sort and Array by String length

/* Create a function that takes an array of strings and return an array, sorted from shortest to longest.
 
 sortByLength(["Google", "Apple", "Microsoft"])
 ➞ ["Apple", "Google", "Microsoft"]

 sortByLength(["Leonardo", "Michelangelo", "Raphael", "Donatello"])
 ➞ ["Raphael", "Leonardo", "Donatello", "Michelangelo"]

 sortByLength(["Turing", "Einstein", "Jung"])
 ➞ ["Jung", "Turing", "Einstein"]
 
 Borrowed from: edabit.com
 */


//Calling the function
// let sortedArray = sortByLength(...)
// print(sortedArray)

func sortByLength(_ array: [String]) -> [String] {
    return array.sorted { $0.count < $1.count }
}

// Calling the function
let sortedArray1 = sortByLength(["Google", "Apple", "Microsoft"])
print(sortedArray1)

let sortedArray2 = sortByLength(["Leonardo", "Michelangelo", "Raphael", "Donatello"])
print(sortedArray2)

let sortedArray3 = sortByLength(["Turing", "Einstein", "Jung"])
print(sortedArray3)
