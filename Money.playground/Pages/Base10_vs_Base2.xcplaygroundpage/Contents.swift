//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)
var count: Float = 0.01
var float_sum: Float = 0
for x in 1...100{
    float_sum = float_sum + count
}
float_sum


var sum: NSDecimalNumber = NSDecimalNumber(float: 0)
for _ in 1...100{
    sum = sum.decimalNumberByAdding(NSDecimalNumber(string: "0.01"))
}
sum

float_sum == sum

var x: NSDecimalNumber = NSDecimalNumber(mantissa: 78001, exponent: -3, isNegative: false)
let y:Float = 78.0
var z:Float = 0.001 + y
x == z

// round-off error - Single Precision
let result: Double = 0.00001 + 0.99
// expecting 0.99001

0.2222 - 0.2221
// expecting 0.0001
NSDecimalNumber(string: "0.2222").decimalNumberBySubtracting(NSDecimalNumber(string: "0.2221"))

