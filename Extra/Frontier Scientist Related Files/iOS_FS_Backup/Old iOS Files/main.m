//
//  main.m
//  Empty_Window
//
//  Created by alandrews3 on 3/18/14.
//  Copyright (c) 2014 alandrews3. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"


int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


//old syntax used here
/*int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}*/

