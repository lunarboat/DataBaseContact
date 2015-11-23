//
//  ViewController.m
//  DataBaseContact
//
//  Created by lunarboat on 15/9/7.
//  Copyright (c) 2015年 lunarboat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *contacts;
    Contact *_selectedContact;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}
- (void)viewWillAppear:(BOOL)animated{
     [self getDataSourceFromDb];
}


#pragma mark -get dataSource from datebase
-(void)getDataSourceFromDb{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        contacts = [ContactsDao queryData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}

#pragma mark -tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (contacts) {
        return contacts.count;
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"contactInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    Contact *contact = [contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.number;
    return cell;
}

#pragma mark -tableView delegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Contact *contact = [contacts objectAtIndex:indexPath.row];
        [ContactsDao deleteData:contact.contactID];
        NSLog(@"%d",contact.contactID);
        [contacts removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        });
    });
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedContact = [contacts objectAtIndex:indexPath.row];
//    NSLog(@"%d==%@==%@",_selectedContact.contactID,_selectedContact.name,_selectedContact.number);
    [self performSegueWithIdentifier:@"ToSelectedContact" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToSelectedContact"]) {
        id vc = [segue destinationViewController];
        [vc setValue:_selectedContact forKey:@"contact"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
