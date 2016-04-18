//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//



// Things to do:
// - make path dynamic
// - make requestKeybordInput method to remove backspaces
// - no magic strings for user input?
// - admin login with ability to delete stuff
// - questions show user who submitted them
// - questions show if answered already or not, shows answers, prompt to update or go back


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
                             @"create new question" : @[@"create new question for existing category", @"create new category"],
                             @"read answers" : [appData[@"answers"] allKeys]
                             };
    }
    
    
    //   --- MAIN BODY   ---
    NSString *state = @"start";
    NSString *user = @"";
    NSLog(@"AppData: %@", appData);
    
    while (YES) {
        if ([state isEqualToString:@"exit"]) {
            NSLog(@"\n\nThank you for using Vault-Tec Interviewer 1981!\n\n\n\nBrought to you by Max Tkach.\n\ne-mail: molotov2k@gmail.com\ngithub: https://github.com/molotov2k\nlinkedin: https://www.linkedin.com/in/molotov2k\nfacebook: https://www.facebook.com/molotov2k");
            return;
            
        } else if ([state isEqualToString:@"start"]) {
            state = [self startingScreen];
            
        } else if ([state isEqualToString:@"login"]) {
            NSArray *methodOutput = [self loginScreen:appData];
            state = methodOutput[0];
            user = methodOutput[1];
            
        } else if ([state isEqualToString:@"main menu"]) {
            state = [self categorySelection:[appData[@"menu"] allKeys] categoryName:@"main menu"];
            if ([state isEqualToString:@"back"]) {
                state = @"start";
            }
            
        } else if ([state isEqualToString:@"answer a question"]) {
            state = [self categorySelection:appData[@"menu"][@"answer a question"] categoryName:@"answer a question"];
            if ([state isEqualToString:@"back"]) {
                state = @"main menu";
            }
            
        } else if ([state isEqualToString:@"answer a question from category"]) {
            state = [self categorySelection:[appData[@"questions"] allKeys] categoryName:@"question categories"];
            if ([state isEqualToString:@"back"]) {
                state = @"answer a question";
            }
            
            
        } else if ([state isEqualToString:@"something"]) {
            state = @"something";
        }
    }
    
    
    
    
    /* NSString *userSelection = @"";
    while (!([userSelection isEqualToString:@"1"] || [userSelection isEqualToString:@"0"])) {
        NSLog(@"\n\nWelcome to Vault-Tec Interviewer 1981!\n\nAvailable options:\n\n1. Log in\n0. Exit\n\nEnter your selection and press return to continue.");
        userSelection = [self requestKeyboardInput];
    }
    if ([userSelection isEqualToString:@"0"]) {
        NSLog(@"\n\nThank you for using Vault-Tec Interviewer 1981!\n\n\n\nBrought to you by Max Tkach.\n\ne-mail: molotov2k@gmail.com\ngithub: https://github.com/molotov2k\nlinkedin: https://www.linkedin.com/in/molotov2k\nfacebook: https://www.facebook.com/molotov2k");
        return;
    }
    
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
            [NSKeyedArchiver archiveRootObject:appData toFile:savedAppDataPath];
            NSLog(@"\n\nAccount created successfully!");
        }
    }
    NSLog(@"\n\nWelcome %@!", [userName capitalizedString]); */
        
    
    
    
    /*
    // Loading students, questions and answers data
    NSString *savedQuestionsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/questions.dat"];
    NSDictionary *savedQuestions = @{};
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedQuestionsPath]) {
        NSData *questionsData = [NSData dataWithContentsOfFile:savedQuestionsPath];
        savedQuestions = [NSKeyedUnarchiver unarchiveObjectWithData:questionsData];
    }
    NSMutableDictionary *questions = [savedQuestions mutableCopy];
    NSArray *questionsCategories = [[questions allKeys] sortedArrayUsingDescriptors:@[asc]];
    NSString *numberedCategories = [self arrayToFormattedString:questionsCategories];
    
    NSString *savedAnswersPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Development/code/ios-DeployOnDayOne/answers.dat"];
    NSDictionary *savedAnswers = @{};
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedAnswersPath]) {
        NSData *answersData = [NSData dataWithContentsOfFile:savedAnswersPath];
        savedAnswers = [NSKeyedUnarchiver unarchiveObjectWithData:answersData];
    }
    NSMutableDictionary *answers = [savedAnswers mutableCopy];
    NSArray *personsInAnswers = [[answers allKeys] sortedArrayUsingDescriptors:@[asc]];
    
    
    
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
    NSLog(@"\n\nWelcome, %@!", currentUser);
    
    
    // Menu
    while (!stop) {
        NSLog(@"\n\nDear %@!\n\nPlease choose your next step:\n\n1. Be interviewed.\n2. Write a new interview question.\n3. Read interview with another student.\n4. Exit application.\n\nType desired option number and press return.", currentUser);
        NSString *menuOption = [self requestKeyboardInput];
    
        if ([menuOption isEqualToString:@"1"]) { // main category - answer questions
            NSLog(@"\n\nYou selected to be interviewed.\n\nWould you like to:\n\n1. Select question you would like to answer.\n2. Answer a random question.\n\nType desired option and press return.");
            NSString *subMenuOption = [self requestKeyboardInput];
            
            if ([subMenuOption isEqualToString:@"1"]) { // sub - select question to answer
                NSLog(@"\n\nYou opted to select question to answer. Please select question category.\n\nCurrent categories are: %@\n\nType in desired category name", numberedCategories);
                NSString *categoryNumber = [self requestKeyboardInput];
                while ([categoryNumber integerValue] < 1 || [categoryNumber integerValue] > [questionsCategories count]) {
                    NSLog(@"\n\nError! No such category exists. Please enter existing category name.\n\nCurrent categories are: %@", numberedCategories);
                    categoryNumber = [self requestKeyboardInput];
                }
                NSString *category = questionsCategories[[categoryNumber integerValue] - 1]; // sub - select question itself
                NSLog(@"\n\nYou selected category %@. Available questions are: \n%@\n\nType desired question number and press return to answer.\n\nType anything else to return to main menu.", category, [self arrayToFormattedString:questions[category]]);
                NSString *questionNumber = [self requestKeyboardInput];
                if ([questionNumber integerValue] > 0 || [questionNumber integerValue] < [questions[category] count]) {
                    questions[category] = [questions[category] sortedArrayUsingDescriptors:@[asc]];
                    NSString *question = questions[category][[questionNumber integerValue] - 1];
                    NSString *answer = @"";
                    while (![self happyCheck:answer]) { // sub - input answer, chech if user happy
                        NSLog(@"\n\nEnter your answer to question:\n\n%@\n\nPress return to continue.", question);
                        answer = [self requestKeyboardInput];
                    }
                    if (![[answers allKeys] containsObject:currentUser]) {
                        answers[currentUser] = [[NSMutableDictionary alloc] init];
                    } else {
                        if (![[answers[currentUser] allKeys] containsObject:category]) {
                            answers[currentUser][category] = [[NSMutableDictionary alloc] init];
                        }
                    }
                    answers[currentUser][category][question] = [answer mutableCopy];
                    [NSKeyedArchiver archiveRootObject:answers toFile:savedAnswersPath];
                    NSLog(@"\n\nYour answer successfully saved!\n\nThank you for using Vault-Tec Interviewer 1980 v0.88!");
                }
            } else if ([subMenuOption isEqualToString:@"2"]) { // sub - answer random question
                NSMutableArray *unansweredQuestions = [[NSMutableArray alloc] init];
                for (NSString *cat in questions) {
                    if (![[answers[currentUser] allKeys] containsObject:cat]) {
                        for (NSString *quest in questions[cat]) {
                            [unansweredQuestions addObject:quest];
                        }
                    } else {
                        for (NSString *quest in questions[cat]) {
                            if (![[answers[currentUser][cat] allKeys] containsObject:quest]) {
                                [unansweredQuestions addObject:quest];
                            }
                        }
                    }
                }
                if ([unansweredQuestions count] == 0) {
                    NSLog(@"\n\nIt appears that you have already answered all available questions.\n\nTry adding a new question and answering it or wait till somebody else adds one.\n\nGood job!\n\nPress return to go back to main menu.");
                    [self requestKeyboardInput];
                } else {
                    NSUInteger randomizer = arc4random() % [unansweredQuestions count];
                    NSString *question = unansweredQuestions[randomizer];
                    NSString *category = @"";
                    for (NSString *cat in [questions allKeys]) {
                        if ([questions[cat] containsObject:question]) {
                            category = cat;
                        }
                    }
                    // Coded random this way instead of random category then random question inside it so every question has the same chance to appear not being dependent on number of question in category.
                    NSString *answer = @"";
                    while (![self happyCheck:answer]) { // sub - input answer, chech if user happy
                        NSLog(@"\n\nEnter your answer to question:\n\n%@\n\nPress return to continue.", question);
                        answer = [self requestKeyboardInput];
                    }
                    
                    if (![[answers allKeys] containsObject:currentUser]) {
                        answers[currentUser] = [[NSMutableDictionary alloc] init];
                    } else {
                        if (![[answers[currentUser] allKeys] containsObject:category]) {
                            answers[currentUser][category] = [[NSMutableDictionary alloc] init];
                        }
                    }
                    answers[currentUser][category][question] = [answer mutableCopy];
                    NSLog(@"--- answers: %@", answers);
                    [NSKeyedArchiver archiveRootObject:answers toFile:savedAnswersPath];
                    NSLog(@"\n\nYour answer successfully saved!\n\nThank you for using Vault-Tec Interviewer 1980 v0.88!");
                    }
                }
        
        
        } else if ([menuOption isEqualToString:@"2"]) { // main category - create new questions
            NSLog(@"\n\nYou selected to write a new question.\n\nWould you like to:\n\n1. Add question to existing category.\n2. Create new questions category.\n\nType desired option and press return.");
            NSString *subMenuOption = [self requestKeyboardInput];
        
            if ([subMenuOption isEqualToString:@"1"]) { // select existing category to create question
                NSLog(@"\n\nYou selected to write a new question for existing category.\n\nCurrent categories are: %@\n\nPlease enter category number to select one to add your question.", numberedCategories);
                NSString *categoryNumber = [self requestKeyboardInput];
                NSString *category = questionsCategories[[categoryNumber integerValue] - 1];
                while (![[questions allKeys] containsObject:category]) {
                    NSLog(@"\n\nError! No such category exists. Please enter existing category name.\n\nCurrent categories are: %@", [self arrayToFormattedString:[questions allKeys]]);
                    category = [self requestKeyboardInput];
                }
                NSString *newQuestion = @"";
                while (![self happyCheck:newQuestion]) {
                    NSLog(@"\n\nEnter question you want to add to category %@ and press return.", [category uppercaseString]);
                    newQuestion = [self requestKeyboardInput];
                }
                [questions[category] addObject:newQuestion];
                [NSKeyedArchiver archiveRootObject:questions toFile:savedQuestionsPath];
                NSLog(@"\n\nQuestion successfully added to category %@!\n\nQuestions in category %@ currently include: %@", [category uppercaseString], [category uppercaseString], [self arrayToFormattedString:questions[category]]);
                
            
            } else { // create new category to create question
                NSString *newCategory = @"";
                while (![self happyCheck:newCategory]) {
                    NSLog(@"\n\nYou opted to create a new category.\n\nType desired category name and press return.");
                    newCategory = [self requestKeyboardInput];
                }
                if ([[questions allKeys] containsObject:newCategory]) { // new category uniq check
                    NSLog(@"\n\nError. Category already exists!\n\nCurrent categories are: %@", [self arrayToFormattedString:[questions allKeys]]);
                } else { // new category success
                    questions[newCategory] = [@[] mutableCopy];
                    [NSKeyedArchiver archiveRootObject:questions toFile:savedQuestionsPath];
                    NSLog(@"\n\nCategory %@ successfully created!\n\nCurrent categories are: %@", [newCategory uppercaseString], [self arrayToFormattedString:[questions allKeys]]);
                }
            }
        
        
        } else if ([menuOption isEqualToString:@"3"]) { // main - reading other's answers
            NSString *people = [self arrayToFormattedString:personsInAnswers]; // lists persons
            NSLog(@"\n\nPlease choose a person to see his/her answers.\n\nCurrent list of people:\n%@\n\nType a person's number and press return to continue.", people);
            NSString *personNumber = [self requestKeyboardInput];
            while ([personNumber integerValue] < 1 || [personNumber integerValue] > [[answers allKeys] count]) {
                NSLog(@"\n\nError! No such person exists.\n\nCurrent list of people:\n%@\n\nType a person's number and press return to continue.", people);
                personNumber = [self requestKeyboardInput];
            }
            NSString *person = [[answers allKeys] sortedArrayUsingDescriptors:@[asc]][[personNumber integerValue] - 1];
            
            NSString *categories = [self arrayToFormattedString:[answers[person] allKeys]]; // lists categories for person
            NSLog(@"\n\nPlease choose a category of answers.\n\nCurrent list of categories:\n%@\n\nType category number and press return to continue.", categories);
            NSString *categoryNumber = [self requestKeyboardInput];
            while ([categoryNumber integerValue] < 1 || [categoryNumber integerValue] > [[answers[person] allKeys] count]) {
                NSLog(@"\n\nError! No such category exists.\n\nCurrent list of categories:\n%@\n\nType category number and press return to continue.", categories);
                categoryNumber = [self requestKeyboardInput];
            }
            NSString *category = [[answers[person] allKeys] sortedArrayUsingDescriptors:@[asc]][[categoryNumber integerValue] - 1];
            
            NSString *answeredQuestions = [self arrayToFormattedString:[answers[person][category] allKeys]]; // lists answers for category
            NSLog(@"Please choose a question to see answer for.\n\nCurrent list of answered questions in this category:\n%@\n\nType question number and press return to continue.", answeredQuestions);
            NSString *questionNumber = [self requestKeyboardInput];
            while ([questionNumber integerValue] < 1 || [questionNumber integerValue] > [[answers[person][category] allKeys] count]) {
                NSLog(@"\n\nError! No such question exists.\n\nCurrent list of answered questions in this category:\n%@\n\nType question number and press return to continue.", answeredQuestions);
                questionNumber = [self requestKeyboardInput];
            }
            NSString *answeredQuestion = [[answers[person][category] allKeys] sortedArrayUsingDescriptors:@[asc]][[questionNumber integerValue] -1]; // answer
            NSLog(@"\n\nAnswer for question '%@' is:\n\n%@\n\nType anything and press return to go back to main menu.", answeredQuestion, answers[person][category][answeredQuestion]);
            [self requestKeyboardInput];
            
            
        } else if ([menuOption isEqualToString:@"4"]) { // main - quits the app
            NSLog(@"\n\nThank you for using Vault-Tec Interviewer 1980 v0.88!\n\nWe hope you enjoyed it and coming back soon!\n\nIf you have questions or comments feel free to contact us at molotov2k@gmail.com\n\nCheers!\n\n\nP.S.: Beer donations are highly appreciated!");
            stop = YES;
        } else { // main - reacts to improper input
            NSLog(@"\n\nI'm sorry, but I'm from 80's and I can only understand if you enter 1, 2, 3 or 4.\n\nPlease try again.");
        }
    } */
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
    while (!(([userSelection integerValue] > 0 && [userSelection integerValue] < [categoryList count]) || [userSelection isEqualToString:@"0"])) {
        NSLog(@"\n\nOptions in category %@ are:\n%@\n\nPlease type corresponding number and press return to make a selection.", categoryListName, categories);
        userSelection = [self requestKeyboardInput];
    }
    if ([userSelection integerValue] == 0) {
        return @"back";
    } else {
        return [self arrayToSortedArrayAscending:categoryList][[userSelection integerValue] - 1];
    }
}


// returns user's input and checks if user is happy with it when non numbered inpur is required
- (NSString *)userInput:(NSString *)userResponseTo inputType:(NSString *)type {
    NSString *promptText = @"";
    if ([type isEqualToString:@"answer"]) { // can be probably redone withough magic strings
        promptText = [promptText stringByAppendingFormat:@"your answer to question:\n\n%@", userResponseTo];
    } else if ([type isEqualToString:@"category"]) {
        promptText = [promptText stringByAppendingFormat:@"new category name."];
    } else if ([type isEqualToString:@"question"]) {
        promptText = [promptText stringByAppendingFormat:@"new question for category:\n\n%@", userResponseTo];
    //} else if ([type isEqualToString:@"main"]) {
    //     promptText = [promptText stringByAppendingFormat:@"your name."];
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
            NSLog(@"\n\nYou entered:\n\n< %@ >\n\n1. Looks good!\n0. Go Back\n\nPlease enter desired option number and press return.", userResponse);
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









/* -(BOOL)loginCheck:(NSString *)login inGroup:(NSMutableArray *)group { // handles name is not in group cases
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


-(BOOL)stopCheck { // not using it anymore, but let be here until final version just in case
    NSLog(@"\n\nType 1 to return to main menu.\nType anything else to quit app.");
    NSString *option = [self requestKeyboardInput];
    if ([option isEqualToString:@"1"]) {
        return NO;
    }
    NSLog(@"\n\nThank you for using this app!\n\nWe hope you enjoyed it and coming back soon!\n\nIf you have questions or comments feel free to contact us at molotov2k@gmail.com\n\nCheers!\n\n\nP.S.: Beer donations are highly appreciated!");
    return YES;
} */


@end