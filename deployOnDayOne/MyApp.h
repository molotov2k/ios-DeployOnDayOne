//
//  MyApp.h
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyApp : NSObject

@property (strong, nonatomic) NSString *currentUser;

-(void)execute;

-(NSString *)requestKeyboardInput;

-(BOOL)loginCheck:(NSString *)login inGroup:(NSMutableArray *)group;

@end
