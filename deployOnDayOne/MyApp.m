//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//
//  Solution created by Max Tkach on 04/2016.
//  Copyright (c) 2016 Max Tkach. No rights reserved.


// Things to do:
// - make path dynamic
// - make requestKeybordInput method to remove backspaces & other special chars
// - no magic strings for user input?
// - admin login with ability to delete stuff
// - questions show user who submitted them
// - questions show if answered already or not, shows answers, prompt to update or go back
// - fine tune all prompts


#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

-(void)execute
{

    
    
    //   ---   LOADING SAVED APPDATA   ---
    NSString *savedAppDataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/appData.dat"]; // need to make path dynamic, but I want file inside lab folder, not in working directory
    NSDictionary *savedAppData = @{};
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedAppDataPath]) {
        NSData *appDataData = [NSData dataWithContentsOfFile:savedAppDataPath];
        savedAppData = [NSKeyedUnarchiver unarchiveObjectWithData:appDataData];
    }
    
    
    
    // --- INITIALIZES CURRENT APPDATA ---
    NSMutableDictionary *appData = [savedAppData mutableCopy];
    if (!appData[@"questions"]) {
        appData[@"questions"] = [[NSMutableDictionary alloc] init];
    }
    
    if (!appData[@"answers"]) {
        appData[@"answers"] = [[NSMutableDictionary alloc] init];
    }
    
    if (!appData[@"path"]) {
        appData[@"path"] = savedAppDataPath;
    }
    
    if (!appData[@"menu"]) {
        appData[@"menu"] = @{
                             @"answer a question" : @[@"answer question from category", @"answer random question"],
                             @"create new question" : @[@"add new question to existing category", @"create new category"],
                             @"read answers" : [appData[@"answers"] allKeys]
                             };
    }
    
    
    
    //   --- INITIALIZING "GLOBAL" VARIABLES   ---
    NSString *state = @"start";
    NSString *category = @"";
    NSString *question = @"";
    NSString *answer = @"";
    NSString *user = @"";
    NSString *userAnswers = @"";
    
    
    
    //   --- MAIN BODY   ---
    while (YES) {
        if ([state isEqualToString:@"exit"]) {
            NSLog(@"\n\nThank you for using Vault-Tec Interviewer 1981!\n\n\n\nBrought to you by Max Tkach.\n\ne-mail: molotov2k@gmail.com\ngithub: https://github.com/molotov2k\nlinkedin: https://www.linkedin.com/in/molotov2k\nfacebook: https://www.facebook.com/molotov2k");
            return;
        
            
            
        //   ---   START & LOGIN   ---
        } else if ([state isEqualToString:@"start"]) {
            state = [self startingScreen];
            
        } else if ([state isEqualToString:@"login"]) {
            NSArray *methodOutput = [self loginScreen:appData];
            state = methodOutput[0];
            user = methodOutput[1];
            
            
            
        //   ---   MAIN MENU   ---
        } else if ([state isEqualToString:@"main menu"]) {
            state = [self categorySelection:[appData[@"menu"] allKeys] categoryName:@"main menu"];
            if ([state isEqualToString:@"back"]) {
                state = @"start";
            }
            
            
            
        //   ---   ANSWER A QUESTION SECTION ---
        } else if ([state isEqualToString:@"answer a question"]) {
            state = [self categorySelection:appData[@"menu"][@"answer a question"] categoryName:@"answer a question"];
            if ([state isEqualToString:@"back"]) {
                state = @"main menu";
            }
            
        } else if ([state isEqualToString:@"answer question from category"]) {
            state = [self categorySelection:[appData[@"questions"] allKeys] categoryName:@"question categories"];
            if ([state isEqualToString:@"back"]) {
                state = @"answer a question";
            }
            category = state;
            
        } else if ([[appData[@"questions"] allKeys] containsObject:state]) {
            state = [self categorySelection:appData[@"questions"][category] categoryName:category];
            if ([state isEqualToString:@"back"]) {
                state = @"answer question from category";
            }
            question = state;
            
        } else if ([appData[@"questions"][category] containsObject:state]) { // add handling of existing answers
            answer = [self userInput:question inputType:@"answer"];
            if ([answer isEqualToString:@"back"]) {
                state = category;
            } else {
                [self save:answer inObj:appData user:user category:category question:question];
                state = @"main menu";
            }
            
        } else if ([state isEqualToString:@"answer random question"]) {
            NSArray *random = [self randomQuestion:appData user:user];
            if ([random count] == 0) {
                NSLog(@"\n\nIt appears you have already answered all available questions. Good job!");
                state = @"main menu";
            } else {
                question = random[0];
                category = random[1];
                answer = [self userInput:question inputType:@"answer"];
                if ([answer isEqualToString:@"back"]) {
                    state = @"answer a question";
                } else {
                    [self save:answer inObj:appData user:user category:category question:question];
                    state = @"main menu";
                }
            }
            
            
        
        //   ---   CREATE A QUESTION SECTION   ---
        } else if ([state isEqualToString:@"create new question"]) {
            state = [self categorySelection:appData[@"menu"][@"create new question"] categoryName:@"create new question"];
            if ([state isEqualToString:@"back"]) {
                state = @"main menu";
            }
            
        } else if ([state isEqualToString:@"create new category"]) {
            state = [self userInput:@"" inputType:@"category"];
            if (![state isEqualToString:@"back"]) {
                [self save:state inObj:appData user:@"" category:@"" question:@""];
            }
            state = @"create new question";
            
        } else if ([state isEqualToString:@"add new question to existing category"]) {
            category = [self categorySelection:[appData[@"questions"] allKeys] categoryName:@"question categories"];
            if (![category isEqualToString:@"back"]) {
                question = [self userInput:category inputType:@"question"];
                if (![question isEqualToString:@"back"]) {
                    [self save:question inObj:appData user:@"" category:category question:@""];
                }
            }
            state = @"create new question";
            
        
            
        //   --- READ ANSWERS SECTION   ---
        } else if ([state isEqualToString:@"read answers"]) {
            userAnswers = [self categorySelection:[appData[@"answers"] allKeys] categoryName:@"users"];
            state = @"answer categories";
            if ([userAnswers isEqualToString:@"back"]) {
                state = @"main menu";
            }
            
        } else if ([state isEqualToString:@"answer categories"]) {
            category = [self categorySelection:[appData[@"answers"][userAnswers] allKeys] categoryName:@""];
            state = @"question in answers";
            if ([category isEqualToString:@"back"]) {
                state = @"read answers";
            }
        
        } else if ([state isEqualToString:@"question in answers"]) {
            question = [self categorySelection:[appData[@"answers"][userAnswers][category] allKeys] categoryName:@"questions"];
            state = @"show answer";
            if ([question isEqualToString:@"back"]) {
               state = @"answer categories";
            }
            
        } else if ([state isEqualToString:@"show answer"]){
            NSLog(@"\n\n%@'s answer to question '%@':\n\n- %@\n\nPress return to continue.", userAnswers, question, appData[@"answers"][userAnswers][category][question]);
            [self requestKeyboardInput];
            state = @"question in answers";
            
            
            
        //   --- SOMETHING GOES WRONG   ---
        } else {
            NSLog(@"\n\nSomething went wrong!");
            return;
        }
    }
}



//   ---   METHOD DECLARATIONS   ---


// requests, takes and returns user input
-(NSString *)requestKeyboardInput {
    fpurge(stdin); // otherwise goes into inifinite loop if you press return without inputing anything
    char stringBuffer[4096] = { 0 };  // technically there should be some safety on this to avoid a crash if you write too much
    scanf("%[^\n]%*c", stringBuffer);
    return [[NSString stringWithUTF8String:stringBuffer] lowercaseString];
}


// sorts given array ascending
-(NSArray *)arrayToSortedArrayAscending:(NSArray *)array {
    NSSortDescriptor *ascending = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    return [array sortedArrayUsingDescriptors:@[ascending]];
}


// creates a string with list of sorted and numbered categories of array from which you can make a selection using category number
-(NSString *)arrayToNumberedString:(NSArray *)array {
    NSMutableString *formattedOutput = [[NSMutableString alloc] init];
    array = [self arrayToSortedArrayAscending:array];
    for (NSUInteger i = 0; i < [array count]; i++) {
        [formattedOutput appendFormat:@"\n%lu. %@", i + 1, array[i]];
    }
    [formattedOutput appendFormat:@"\n0. Go Back"];
    return formattedOutput;
}


// returns user's selection of the category from given category list of given name
-(NSString *)categorySelection:(NSArray *)categoryList categoryName:(NSString *)categoryListName {
    NSString *categories = [self arrayToNumberedString:categoryList];
    NSString *userSelection = @"";
    while (!(([userSelection integerValue] > 0 && [userSelection integerValue] <= [categoryList count]) || [userSelection isEqualToString:@"0"])) {
        NSLog(@"\n\nOptions in category %@ are:\n%@\n\nPlease type corresponding number and press return to make a selection.", categoryListName, categories);
        userSelection = [self requestKeyboardInput];
    }
    if ([userSelection integerValue] == 0) {
        return @"back";
    } else {
        return [self arrayToSortedArrayAscending:categoryList][[userSelection integerValue] - 1];
    }
}


// returns user's input and checks if user is happy with it when non number input is required
- (NSString *)userInput:(NSString *)userResponseTo inputType:(NSString *)type {
    NSString *promptText = @"";
    if ([type isEqualToString:@"answer"]) { // can be probably redone withough magic strings
        promptText = [promptText stringByAppendingFormat:@"your answer to question:\n\n%@", userResponseTo];
    } else if ([type isEqualToString:@"category"]) {
        promptText = [promptText stringByAppendingFormat:@"new category name."];
    } else if ([type isEqualToString:@"question"]) {
        promptText = [promptText stringByAppendingFormat:@"new question for category:\n\n%@", userResponseTo];
    } else {
        promptText = [promptText stringByAppendingFormat:@"your selection."];
    }
    
    BOOL happy = NO;
    NSString *userResponse = @"";
    while (!happy) {
        NSLog(@"\n\nPlease enter %@\n\nPress return when finished.\nEnter '0' or 'back' and press return to go back.", promptText);
        userResponse = [self requestKeyboardInput];
        if ([userResponse isEqualToString:@"0"] || [userResponse isEqualToString:@"back"]) {
            return @"back";
        }
        NSString *userHappy = @"";
        while (!([userHappy isEqualToString:@"1"] || [userHappy isEqualToString:@"0"])) {
            NSLog(@"userHappy: %@", userHappy);
            NSLog(@"\n\nYou entered:\n\n' %@ '\n\n1. Looks good!\n0. Go Back\n\nPlease enter desired option number and press return.", userResponse);
            userHappy = [self requestKeyboardInput];
        }
        if ([userHappy isEqualToString:@"1"]) {
            return userResponse;
        }
    }
    return @"something is very wrong!"; //xcode will throw error if there is nothing here
}


// starting screen
-(NSString *)startingScreen {
    NSString *userSelection = @"";
    while (!([userSelection isEqualToString:@"1"] || [userSelection isEqualToString:@"0"])) {
        NSLog(@"\n\nWelcome to Vault-Tec Interviewer 1981!\n\nAvailable options:\n\n1. Log in\n0. Exit\n\nEnter your selection and press return to continue.");
        userSelection = [self requestKeyboardInput];
    }
    if ([userSelection isEqualToString:@"0"]) {
        return @"exit";
    }
    return @"login";
}


// login screen, returns array with menu selection and user's name
-(NSArray *)loginScreen:(NSMutableDictionary *)appData {
    NSLog(@"\n\nPlease enter your name:");
    NSString *userName = [[self requestKeyboardInput] capitalizedString];
    if (!appData[@"answers"][userName]) {
        NSString *userSelection = @"";
        while (!([userSelection isEqualToString:@"1"] || [userSelection isEqualToString:@"0"])) {
            NSLog(@"\n\nYou entered %@.\nUnfortunately this name was not found.\n\nAvailable options:\n\n1. Create a new account\n0. Go Back\n\nEnter your selection and press return to continue.", [userName uppercaseString]);
            userSelection = [self requestKeyboardInput];
        }
        if ([userSelection isEqualToString:@"1"]) {
            appData[@"answers"][userName] = [[NSMutableDictionary alloc] init];
            [NSKeyedArchiver archiveRootObject:appData toFile:appData[@"path"]];
            NSLog(@"\n\nAccount created successfully!");
        } else {
            return @[@"start", @""];
        }
    }
    NSLog(@"\n\nWelcome, %@!", userName);
    return @[@"main menu", userName];
}


// saves user input
-(void)save:(NSString *)input inObj:(NSDictionary *)appData user:(NSString *)user category:(NSString *)category question:(NSString *)question {
    if ([user isEqualToString:@""]) {
        if ([category isEqualToString:@""]) {
            if (appData[@"questions"][input]) {
                NSLog(@"\n\nCategory %@ already exists!", [input uppercaseString]);
            } else {
                appData[@"questions"][input] = [[NSMutableArray alloc] init];
                NSLog(@"\n\nCategory %@ successfully created!", [input uppercaseString]);
            }
        } else {
            if ([appData[@"questions"][category] containsObject:input]) {
                NSLog(@"\n\nQuestion %@ already exists in category %@!", [input uppercaseString], [category uppercaseString]);
            } else {
                [appData[@"questions"][category] addObject:input];
                NSLog(@"\n\nYour question %@ successfully added to category %@!", [input uppercaseString], [category uppercaseString]);
            }
        }
    } else {
        if (![[appData[@"answers"] allKeys] containsObject:user]) {
            appData[@"answers"][user] = [[NSMutableDictionary alloc] init];
        }
        if (![[appData[@"answers"][user] allKeys] containsObject:category]) {
            appData[@"answers"][user][category] = [[NSMutableDictionary alloc] init];
        }
        if (![[appData[@"answers"][user][category] allKeys] containsObject:question]) {
            appData[@"answers"][user][category][question] = input;
        }
        NSLog(@"\n\nYour answer successfully saved!");
    }
    [NSKeyedArchiver archiveRootObject:appData toFile:appData[@"path"]];
}


// return random question and its category from user's unanswered questions
-(NSArray *)randomQuestion:(NSDictionary *)appData user:(NSString *)user {
    NSMutableDictionary *unansweredQuestionswithCategories = [[NSMutableDictionary alloc] init];
    for (NSString *category in [appData[@"questions"] allKeys]) {
        for (NSString *question in appData[@"questions"][category]) {
            if (![[appData[@"answers"][user][category] allKeys] containsObject:question]) {
                unansweredQuestionswithCategories[question] = category;
            }
        }
    }
    if ([[unansweredQuestionswithCategories allKeys] count] == 0) {
        return @[];
    }
    NSUInteger random = arc4random() % [[unansweredQuestionswithCategories allKeys] count];
    NSString *randomQuestion = [unansweredQuestionswithCategories allKeys][random];
    NSString *randomQuestionCategory = unansweredQuestionswithCategories[randomQuestion];
    return @[randomQuestion, randomQuestionCategory];
}


@end


















