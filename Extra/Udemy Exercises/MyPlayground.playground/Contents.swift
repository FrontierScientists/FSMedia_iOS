//: Playground - noun: a place where people can play

import UIKit

var myArray = [1, 2, 3, 4, 5]

myArray[3]

myArray.append(6);

println(myArray);

myArray.removeAtIndex(2);

println(myArray);

myArray.removeLast();

println(myArray);

myArray.removeRange(1...2);

println(myArray);

var newArray = [1, 2.3, "Tom"];

var emptyArray: [Int];


var dict = ["name": "Rob", "age": 34, "gender": "male"];

println(dict["name"]!);

dict["hairColor"] = "brown";

dict["age"] = 35;

dict["age"] = "old";

dict["age"] = nil;

println(dict);

var name = dict["name"];

var myString = "My name is \(name!)";


var challengeArray = [2, 4, 6, 8];

challengeArray.removeAtIndex(0);

challengeArray.append(10);

var infoDict = ["name": "Aquin", "age": 834892354];

name = infoDict["name"]!;
var age = infoDict["age"]!;

myString = "My name is \(name), and I am \(age) years old."
