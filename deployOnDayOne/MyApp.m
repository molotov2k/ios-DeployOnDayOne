//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

-(void)execute
{
    // Loading info
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *appDirectoryPath = [NSHomeDirectory() ];
    NSString *savedGroupPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/group.dat"];
    NSArray *savedGroup = @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedGroupPath]) {
        NSData *data = [NSData dataWithContentsOfFile:savedGroupPath];
        savedGroup = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    NSMutableArray *group = [savedGroup mutableCopy];
    
    // Login
    NSLog(@"\nKindly enter your name and press return to login:\n");
    NSString *currentUser = [self requestKeyboardInput];
    while (![self loginCheck:currentUser inGroup:group]) { // Unknown name handling
        NSLog(@"\nKindly enter your name and press return to login:\n");
        currentUser = [self requestKeyboardInput];
    }
    if (![group isEqualToArray:savedGroup]) { // Save if new name added
        [NSKeyedArchiver archiveRootObject:group toFile:savedGroupPath];
    }
    
    
    // Menu
    NSLog(@"\nWelcome, %@!\n\nPlease choose your next step:\n\n1. Be interviewed.\n2. Write a new interview question.\n3. Read interview with another student.\n\nType desired option number and press return.\nType anything else and press return to terminate this app.\n", currentUser);
    NSString *menuOption = [self requestKeyboardInput];
    
    
    


    
    
    
    
}


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}


-(BOOL)loginCheck:(NSString *)login inGroup:(NSMutableArray *)group {
    if ([group containsObject:login]) {
        return YES;
    } else {
        NSLog(@"\nUnfortunately your name was not found, dear %@.\nWould you like to re-enter your name or want me to add you to the group?\n", login);
        NSLog(@"\n1. Re-enter your name.\n2. Add your name to the group.\n\nPlease enter your selection and press return.\n");
        NSString *wrongLoginDecision = [self requestKeyboardInput];
        
        while (![wrongLoginDecision isEqualToString:@"1"] && ![wrongLoginDecision isEqualToString:@"2"]) {
            NSLog(@"\nI'm sorry, but I'm from 80's and I can only understand if you enter 1 or 2:");
            NSLog(@"\n1. Re-enter your name.\n2. Add your name to the list.\n\nPlease enter your selection and press return.\n");
            wrongLoginDecision = [self requestKeyboardInput];
        }
        
        if ([wrongLoginDecision isEqualToString:@"1"]) {
            return NO;
        } else {
            [group addObject:login];
            return YES;
        }
    }
}


@end
