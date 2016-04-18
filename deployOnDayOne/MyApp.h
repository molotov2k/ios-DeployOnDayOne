//
//  MyApp.h
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyApp : NSObject

-(void)execute;

-(NSString *)requestKeyboardInput;

-(NSString *)arrayToNumberedString:(NSArray *)array;

-(NSArray *)arrayToSortedArrayAscending:(NSArray *)array;

-(NSString *)categorySelection:(NSArray *)categoryList categoryName:(NSString *)categoryName;

-(NSString *)userInput:(NSString *)userResponseTo inputType:(NSString *)type;

-(NSString *)startingScreen;

-(NSArray *)loginScreen:(NSDictionary *)appData;

-(void)save:(NSString *)input inObj:(NSDictionary *)appData user:(NSString *)user category:(NSString *)category question:(NSString *)question;

-(NSArray *)randomQuestion:(NSDictionary *)appData user:(NSString *)user;

@end