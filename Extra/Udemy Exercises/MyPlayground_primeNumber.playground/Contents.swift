//: Playground - noun: a place where people can play

import UIKit

var number = 1;
var sqrtOfNumber = sqrt(Double(number));
var numberIsPrime_bool = true;

if(number == 1){
    
    numberIsPrime_bool = false;
}
else{
    
    for var ii = 2; ii < number; ++ii{
        
        if(number % ii == 0 && number != 2){
            
            numberIsPrime_bool = false;
        }
    }
}

if(numberIsPrime_bool){
    
    println("\(number) is prime!");
}
else{
    
    println("\(number) is not prime!");
}
