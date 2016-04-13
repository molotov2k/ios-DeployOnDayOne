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
    NSSortDescriptor *asc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    
    // Loading students, questions and answers data
    NSString *savedGroupPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/group.dat"]; // Not perfect, but I don't know how to return directory with lab, working directory is not it
    NSArray *savedGroup = @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedGroupPath]) {
        NSData *groupData = [NSData dataWithContentsOfFile:savedGroupPath];
        savedGroup = [NSKeyedUnarchiver unarchiveObjectWithData:groupData];
    }
    NSMutableArray *group = [savedGroup mutableCopy];
    
    NSString *savedQuestionsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/questions.dat"];
    NSDictionary *savedQuestions = @{};
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedQuestionsPath]) {
        NSData *questionsData = [NSData dataWithContentsOfFile:savedQuestionsPath];
        savedQuestions = [NSKeyedUnarchiver unarchiveObjectWithData:questionsData];
    }
    NSMutableDictionary *questions = [savedQuestions mutableCopy];
    
    NSString *savedAnswersPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/answers.dat"];
    NSDictionary *savedAnswers = @{};
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedAnswersPath]) {
        NSData *answersData = [NSData dataWithContentsOfFile:savedAnswersPath];
        savedAnswers = [NSKeyedUnarchiver unarchiveObjectWithData:answersData];
    }
    NSMutableDictionary *answers = [savedAnswers mutableCopy];
    
    
    // Login
    NSLog(@"\n\nKindly enter your name and press return to login:");
    NSString *currentUser = [self requestKeyboardInput];
    while (![self loginCheck:currentUser inGroup:group]) { // Unknown name handling
        NSLog(@"\n\nKindly enter your name and press return to login:");
        currentUser = [self requestKeyboardInput];
    }
    if (![group isEqualToArray:savedGroup]) { // Save if new name added
        [NSKeyedArchiver archiveRootObject:group toFile:savedGroupPath];
    }
    
    
    // Menu
    NSLog(@"\n\nWelcome, %@!\n\nPlease choose your next step:\n\n1. Be interviewed.\n2. Write a new interview question.\n3. Read interview with another student.\n\nType desired option number and press return.\nType anything else and press return to terminate this app.", currentUser);
    NSString *menuOption = [self requestKeyboardInput];
    if ([menuOption isEqualToString:@"1"]) { // answering questions
        NSLog(@"\n\nYou selected to be interviewed.\n\nWould you like to:\n\n1. Select question you would like to answer.\n2. Answer a random question.\n\nType desired option and press return.");
        NSString *subMenuOption = [self requestKeyboardInput];
        if ([subMenuOption isEqualToString:@"1"]) { // select question category
            NSLog(@"\n\nYou opted to select question to answer.\n\nPlease select question category."); // unfinished
        }
        
    } else if ([menuOption isEqualToString:@"2"]) { // creating new questions
        NSLog(@"\n\nYou selected to write a new question.\n\nWould you like to:\n\n1. Add question to existing category.\n2. Create new questions category.\n\nType desired option and press return.");
        NSString *subMenuOption = [self requestKeyboardInput];
        if ([subMenuOption isEqualToString:@"1"]) { // select existing category
            // list categories
        } else { // creating new category
            NSString *newCategory = @"";
            while (![self happyCheck:newCategory]) {
                NSLog(@"\n\nYou opted to create a new category.\n\nType desired category name and press return.");
                newCategory = [self requestKeyboardInput];
            }
            if ([[questions allKeys] containsObject:newCategory]) { // new category uniq check
                NSLog(@"\n\nError. Category already exists!\n\nCurrent categories are: %@", [[questions allKeys] sortedArrayUsingDescriptors:@[asc]]);
            } else { // new category success
                questions[newCategory] = [@[] mutableCopy];
                [NSKeyedArchiver archiveRootObject:questions toFile:savedQuestionsPath];
                NSLog(@"\n\nCategory %@ succesfully created!\n\nCurrent categories are: %@", [newCategory uppercaseString], [[questions allKeys] sortedArrayUsingDescriptors:@[asc]]);
            }
        }
    } else { // reading other's answers
        
    }
    
    
    


    
    
    
    
}


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}


-(BOOL)loginCheck:(NSString *)login inGroup:(NSMutableArray *)group { // handles name is not in group cases
    if ([group containsObject:login]) {
        return YES;
    } else {
        NSLog(@"\n\nUnfortunately your name was not found, dear %@.\nWould you like to re-enter your name or want me to add you to the group?", login);
        NSLog(@"\n\n1. Re-enter your name.\n2. Add your name to the group.\n\nPlease enter your selection and press return.");
        NSString *wrongLoginDecision = [self requestKeyboardInput];
        
        while (![wrongLoginDecision isEqualToString:@"1"] && ![wrongLoginDecision isEqualToString:@"2"]) {
            NSLog(@"\n\nI'm sorry, but I'm from 80's and I can only understand if you enter 1 or 2:");
            NSLog(@"\n\n1. Re-enter your name.\n2. Add your name to the list.\n\nPlease enter your selection and press return.");
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


-(BOOL)happyCheck:(NSString *)text { // checks if user is happy with his entry
    if ([text length] == 0) {
        return NO;
    }
    NSLog(@"\n\nYou have entered:\n\n%@\n\n1. Looks good!\n2. Retry.\n\nType desired option number and press return", text);
    NSString *option = [self requestKeyboardInput];
    while (![option isEqualToString:@"1"] && ![option isEqualToString:@"2"]) {
        NSLog(@"\n\nI'm sorry, but I'm from 80's and I can only understand if you enter 1 or 2:");
        NSLog(@"\n\nYou have entered:\n\n%@\n\n1. Looks good!\n2. Go back and retry.\n\nType desired option number and press return", text);
        option = [self requestKeyboardInput];
    }
    if ([option isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


@end
