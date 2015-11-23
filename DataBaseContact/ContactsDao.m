//
//  ContactsDao.m
//  DataBaseContact
//
//  Created by lunarboat on 15/9/7.
//  Copyright (c) 2015年 lunarboat. All rights reserved.
//

#import "ContactsDao.h"


@implementation ContactsDao

+(NSMutableArray*)queryData{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    FMDatabase *db = [DatebaseUtil shareDateBase];
    if (![db open]) {
        [db close];
        return nil;
    }
    [db setShouldCacheStatements:YES];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM contacts"];
    while ([rs next]) {
        Contact *contact = [[Contact alloc]init];
        contact.contactID = [rs intForColumn:@"contact_id"];
        contact.name = [rs stringForColumn:@"contact_name"];
        contact.number = [rs stringForColumn:@"contact_number"];
        [array addObject:contact];
    }
    [rs close];
    [db close];
    return array;
}
+(BOOL)insertData:(Contact*)contact{
    BOOL result = NO;
    FMDatabase *db = [DatebaseUtil shareDateBase];
    if (![db open]) {
        [db close];
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    if ([db tableExists:@"contacts"]) {
        result = YES;
    }else{
        if ([db executeUpdate:@"CREATE TABLE contacts(contact_id INTEGER PRIMARY KEY, contact_name TEXT, contact_number TEXT NOT NULL)"]) {
            result = YES;
        }
    }
    
    if ([db executeUpdate:@"INSERT INTO contacts(contact_name,contact_number) VALUES (?,?)",contact.name,contact.number]) {
        result = YES;
    }
    [db close];
    return result;
}
+(BOOL)deleteData:(int)contactID{
    BOOL result = NO;
    FMDatabase *db = [DatebaseUtil shareDateBase];
    if (![db open]) {
        [db close];
        return NO;
    }
    [db setShouldCacheStatements:YES];
    if ([db executeUpdate:@"DELETE FROM contacts WHERE contacts.contact_id = (?)",@(contactID)]) {
        result = YES;
    }
    [db close];
    return result;
}
+(BOOL)updateData:(Contact*)contact{
    BOOL result = NO;
    FMDatabase *db = [DatebaseUtil shareDateBase];
    if (![db open]) {
        [db close];
        return NO;
    }
    [db setShouldCacheStatements:YES];
    if ([db executeUpdate:@"UPDATE contacts SET contact_name = (?),contact_number = (?) WHERE contact_id = (?)",contact.name,contact.number,@(contact.contactID)]) {
//        NSLog(@"%d-%@-%@",contact.contactID,contact.name,contact.number);
        result = YES;
    }
    [db close];
    return result;
}

@end
