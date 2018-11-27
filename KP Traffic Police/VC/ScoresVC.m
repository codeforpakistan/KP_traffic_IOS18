//
//  ScoresVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 10/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ScoresVC.h"

@interface ScoresVC ()

@end

@implementation ScoresVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"My Scores";
    
    _topView.layer.cornerRadius = 5.0;
    _topView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _topView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _topView.layer.shadowOpacity = 1;
    _topView.layer.shadowRadius = 1.0;
    
    _tableView.layer.cornerRadius = 5.0;
    _tableView.layer.borderWidth = 1.0;
    _tableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"question_db.db"];
    
    NSString *val_query = @"select * from score_table";
    _data_array = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:val_query]];
    NSLog(@"%@", _data_array);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    label1.text = [NSString stringWithFormat:@"Your score is %@ out of 20", [[_data_array objectAtIndex:indexPath.row] objectAtIndex:1]];
    label2.text = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:2];
    return cell;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
