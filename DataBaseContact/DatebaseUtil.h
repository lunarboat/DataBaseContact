//
//  DatebaseUtil.h
//  DataBaseContact
//
//  Created by lunarboat on 15/9/7.
//  Copyright (c) 2015年 lunarboat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DatebaseUtil : NSObject

+(FMDatabase*)shareDateBase;

@end
