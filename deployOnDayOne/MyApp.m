//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//



// Things to do:
// - remove group, use answers[currentUser] instead
// - add admin feature to delete unwanted stuff
// - rewrite the program using separate methods to make it shorter, more readable and nicer
// - modify requestUserInput AGAIN so it would cut off backspaces and stuff like that
// - have a cookie

#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

-(void)execute
{
    // Defining "global" variables
    NSSortDescriptor *asc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    BOOL stop = NO;
    
    
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
    }
}


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    fpurge(stdin);
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


-(BOOL)stopCheck { // not using it anymore, but let be here until final version just in case
    NSLog(@"\n\nType 1 to return to main menu.\nType anything else to quit app.");
    NSString *option = [self requestKeyboardInput];
    if ([option isEqualToString:@"1"]) {
        return NO;
    }
    NSLog(@"\n\nThank you for using this app!\n\nWe hope you enjoyed it and coming back soon!\n\nIf you have questions or comments feel free to contact us at molotov2k@gmail.com\n\nCheers!\n\n\nP.S.: Beer donations are highly appreciated!");
    return YES;
}


-(NSString *)arrayToFormattedString:(NSArray *)array { // used to created numbered string to list categories, names, what have you
    NSMutableString *formattedOutput = [[NSMutableString alloc] init];
    NSSortDescriptor *ascend = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    array = [array sortedArrayUsingDescriptors:@[ascend]];
    for (NSUInteger i = 0; i < [array count]; i++) {
        [formattedOutput appendFormat:@"\n%lu. %@", i + 1, array[i]];
    }
    return formattedOutput;
}


@end