//: Playground - noun: a place where people can play

import UIKit

var ii = 2;

while ii <= 10{
    
    println(ii * 2);
    ii++;
}

println(" ");

var arr = [6, 2, 9, 1, 7, 8, 12];

var index = 0;

while index < arr.count {
    
    --arr[index];
    println(arr);
    ++index;
}