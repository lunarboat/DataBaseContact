//
//  DatebaseUtil.m
//  DataBaseContact
//
//  Created by lunarboat on 15/9/7.
//  Copyright (c) 2015年 lunarboat. All rights reserved.
//

#import "DatebaseUtil.h"

@implementation DatebaseUtil

+(FMDatabase*)shareDateBase{
    static FMDatabase *db = nil;
    if (db == nil) {
        db = [[FMDatabase alloc]initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/contacts.sqlite"]];
    }
//    NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Dcouments/contacts.sqlite"]);
    return db;
}

@end
