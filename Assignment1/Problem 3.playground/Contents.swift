import UIKit

//MARK: Question 3, Find the Largest Numbers in a Group of Arrays

/*
 Create a function that takes an array of arrays with numbers. Return a new (single) array with the largest numbers of each.

 findLargest([[4, 2, 7, 1], [20, 70, 40, 90], [1, 2, 0]]) ➞ [7, 90, 2]

 findLargest([[-34, -54, -74], [-32, -2, -65], [-54, 7, -43]]) ➞ [-34, -2, 7]

 findLargest([[0.4321, 0.7634, 0.652], [1.324, 9.32, 2.5423, 6.4314], [9, 3, 6, 3], [1, 2, 3, 4]]) ➞ [0.7634, 9.32, 9, 4]
 
 It is OK, if your returning array is [Double]
 
 Borrowed from: edabit.com
 */

//Calling the function
// let arrayOfLargests = findLargest(...)
// print(arrayOfLargests)

func findLargest(_ arrays: [[Double]]) -> [Double] {
    var res: [Double] = []
    for subArray in arrays {
        var max = subArray[0]
        for num in subArray {
            if num > max {
                max = num
            }
        }
        res.append(max)
    }
    return res
}

// Calling the function with examples
let arrayOfLargests1 = findLargest([[4, 2, 7, 1], [20, 70, 40, 90], [1, 2, 0]])
print(arrayOfLargests1)

let arrayOfLargests2 = findLargest([[-34, -54, -74], [-32, -2, -65], [-54, 7, -43]])
print(arrayOfLargests2)

let arrayOfLargests3 = findLargest([[0.4321, 0.7634, 0.652], [1.324, 9.32, 2.5423, 6.4314], [9, 3, 6, 3], [1, 2, 3, 4]])
print(arrayOfLargests3)
