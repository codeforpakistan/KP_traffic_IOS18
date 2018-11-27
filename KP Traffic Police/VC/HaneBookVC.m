//
//  HaneBookVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 06/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "HaneBookVC.h"

@interface HaneBookVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HaneBookVC{
    NSMutableArray *filteredArray;
    BOOL isFiltered;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hand Book";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self questions];
}

-(void)questions{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"question_db.db"];
    
    NSString *val_query = @"select * from question_table";
    _data_array = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:val_query]];
    NSLog(@"%@", _data_array);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
    UILabel *lbl1 = (UILabel*)[cell viewWithTag:1];
    UILabel *lbl2 = (UILabel*)[cell viewWithTag:2];
    UILabel *lbl3 = (UILabel*)[cell viewWithTag:3];
    UILabel *lbl4 = (UILabel*)[cell viewWithTag:4];
    UILabel *lbl5 = (UILabel*)[cell viewWithTag:5];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:6];
    
    NSString *imgStr = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:6];
    if ([imgStr isEqualToString:@"na"]) {
        imgView.hidden = YES;
    }
    else{
        imgView.hidden = NO;
        imgView.image = [UIImage imageNamed:imgStr];
    }
    
    lbl1.text = [NSString stringWithFormat:@"Q%ld:", indexPath.row+1];
    lbl2.text = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:1];
    lbl3.text = [NSString stringWithFormat:@"  A:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:2]];
    lbl4.text = [NSString stringWithFormat:@"  B:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:3]];
    lbl5.text = [NSString stringWithFormat:@"  C:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    lbl3.layer.cornerRadius = 5.0;
    lbl3.layer.borderWidth = 1.0;
    lbl3.layer.borderColor = [UIColor grayColor].CGColor;
    lbl4.layer.cornerRadius = 5.0;
    lbl4.layer.borderWidth = 1.0;
    lbl4.layer.borderColor = [UIColor grayColor].CGColor;
    lbl5.layer.cornerRadius = 5.0;
    lbl5.layer.borderWidth = 1.0;
    lbl5.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString *option1 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:2];
    NSString *option2 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:3];
    NSString *option3 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:4];
    NSString *answer = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:5];
    
    if ([option1 isEqualToString:answer]) {
        lbl3.layer.borderWidth = 2.0;
        lbl3.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else if ([option2 isEqualToString:answer]){
        lbl4.layer.borderWidth = 2.0;
        lbl4.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else if ([option3 isEqualToString:answer]){
        lbl5.layer.borderWidth = 2.0;
        lbl5.layer.borderColor = [UIColor greenColor].CGColor;
    }
    
    return cell;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
