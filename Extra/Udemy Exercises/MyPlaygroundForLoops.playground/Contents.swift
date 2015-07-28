//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


for var ii = 5; ii <= 50; ii+=5{
    
    println(ii);
}

var arr = [6, 3, 8, 1];

println(" ");

for x in arr{
    
    println(x);
}

println(" ");

for (index, x) in enumerate(arr){
    
    arr[index] = x + 1;
}

println(" ");

println(arr);

println(" ");

var arr0 = [6.0, 3.0, 8.0, 1.0];

for (index, value) in enumerate(arr0){
    
    arr0[index] = value / 2;
}

println(arr0);

println(" ");
