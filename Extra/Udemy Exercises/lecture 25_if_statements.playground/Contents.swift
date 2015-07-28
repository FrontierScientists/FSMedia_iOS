//: Playground - noun: a place where people can play

import UIKit

var name = "Ian"

var time = 12;

if(name == "Rob" && time < 12){
    println("Good morning, Rob");
}
else if(name == "Rob" && time >= 12){
    println("Good afternoon, Rob");
}
else{
    println("Who are you?");
}


if(name == "Rob" || time < 20){
    println("One statement is true");
}

var remainder = 10 % 3;

var x = 34;

if(x % 2 == 0){
    println("x is even");
}
else{
    println("x is odd");
}


var randomNumber = arc4random_uniform(10);
