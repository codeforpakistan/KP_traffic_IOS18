//
//  AnswersVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 01/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "AnswersVC.h"
#import "SCLAlertView.h"

@interface AnswersVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AnswersVC{
    NSMutableArray *answer_arr, *sel_answer_arr;
    int score;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
    [alert showSuccess:self title:@"Test Completed" subTitle:@"Click ok to see Test Preview and Result." closeButtonTitle:@"Ok" duration:0.0f];
    
    score = 0;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _topView.layer.cornerRadius = 5.0;
    _topView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _topView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _topView.layer.shadowOpacity = 1;
    _topView.layer.shadowRadius = 1.0;
    
    answer_arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"answer_arr"];
    sel_answer_arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"sel_answer_arr"];
    NSLog(@"%@", answer_arr);
    NSLog(@"%@", sel_answer_arr);
    [self questions];
    
    for (int i=0; i<20; i++) {
        NSString *correct_ans = [answer_arr objectAtIndex:i];
        NSString *sel_answer = [sel_answer_arr objectAtIndex:i];
        if ([sel_answer isEqualToString:correct_ans]) {
            score = score + 1;
        }
    }
    _score_lbl.text = [NSString stringWithFormat:@"Your Score is %i Out of 20", score];
    
    //database
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"d-MMM-yyyy"];
    NSString *dateStr = [df stringFromDate:date];
    NSLog(@"%@", dateStr);
    
    NSString *query = [NSString stringWithFormat:@"insert into score_table values(null, '%i', '%@')", score, dateStr];
    [self.dbManager executeQuery:query];
}

-(void)questions{
    NSString *test_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"test_type"];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"question_db.db"];
    
    NSString *val_query = @"select * from record_fetch_value";
    NSArray *arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:val_query]];
    
    int value=0;
    NSString *query;
    if ([test_type isEqualToString:@"random_test"]) {
        value = [[[arr objectAtIndex:0] objectAtIndex:0] intValue];
        query = [NSString stringWithFormat:@"SELECT * FROM question_table WHERE id BETWEEN %i AND %i", value, value+19];
    }
    else if ([test_type isEqualToString:@"sign_test"]){
        value = [[[arr objectAtIndex:0] objectAtIndex:1] intValue];
        query = [NSString stringWithFormat:@"SELECT * FROM question_table WHERE id BETWEEN %i AND %i AND image != 'na' LIMIT 20", value, value+45];
    }
    else if ([test_type isEqualToString:@"theory_test"]){
        value = [[[arr objectAtIndex:0] objectAtIndex:2] intValue];
        if (value<90) {
            query = [NSString stringWithFormat:@"SELECT * FROM question_table WHERE id BETWEEN %i AND %i AND image = 'na' LIMIT 20", value, value+45];
        }
        else{
            query = [NSString stringWithFormat:@"SELECT * FROM question_table WHERE id BETWEEN %i AND %i AND image = 'na' LIMIT 20", value-4, value+45];
        }
    }
    
    self.data_array = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@", self.data_array);
    [_tableView reloadData];
    
    //update value
    NSString *update_query;
    if ([test_type isEqualToString:@"random_test"]) {
        if (value<120) {
            update_query  = [NSString stringWithFormat: @"update record_fetch_value set value='%i'", value+20];
        }
        else{
            update_query = [NSString stringWithFormat: @"update record_fetch_value set value='%i'", 1];
        }
    }
    else if ([test_type isEqualToString:@"sign_test"]){
        if (value<90) {
            update_query  = [NSString stringWithFormat: @"update record_fetch_value set sign_test_value='%i'", value+45];
        }
        else{
            update_query  = [NSString stringWithFormat: @"update record_fetch_value set sign_test_value='%i'", 1];
        }
    }
    else if ([test_type isEqualToString:@"theory_test"]){
        if (value<90) {
            update_query  = [NSString stringWithFormat: @"update record_fetch_value set theory_test_value='%i'", value+45];
        }
        else{
            update_query  = [NSString stringWithFormat: @"update record_fetch_value set theory_test_value='%i'", 1];
        }
    }
    
    [self.dbManager executeQuery:update_query];
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
    
    lbl1.text = [NSString stringWithFormat:@"Q%ld:", indexPath.row+1];
    lbl2.text = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:1];
    lbl3.text = [NSString stringWithFormat:@"  A:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:2]];
    lbl4.text = [NSString stringWithFormat:@"  B:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:3]];
    lbl5.text = [NSString stringWithFormat:@"  C:   %@",[[_data_array objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    NSString *imgStr = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:6];
    if ([imgStr isEqualToString:@"na"]) {
        imgView.hidden = YES;
    }
    else{
        imgView.hidden = NO;
        imgView.image = [UIImage imageNamed:imgStr];
    }
    
    lbl3.layer.cornerRadius = 5.0;
    lbl3.layer.borderWidth = 1.0;
    lbl3.layer.borderColor = [UIColor grayColor].CGColor;
    lbl4.layer.cornerRadius = 5.0;
    lbl4.layer.borderWidth = 1.0;
    lbl4.layer.borderColor = [UIColor grayColor].CGColor;
    lbl5.layer.cornerRadius = 5.0;
    lbl5.layer.borderWidth = 1.0;
    lbl5.layer.borderColor = [UIColor grayColor].CGColor;

    //border color
    NSString *option1 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:2];
    NSString *option2 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:3];
    NSString *option3 = [[_data_array objectAtIndex:indexPath.row] objectAtIndex:4];
    NSString *correct_ans = [answer_arr objectAtIndex:indexPath.row];
    NSString *sel_answer = [sel_answer_arr objectAtIndex:indexPath.row];
    
    UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1000];
    UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2000];
    UIImageView *imageView3 = (UIImageView *)[cell viewWithTag:3000];
    imageView1.hidden = YES;
    imageView2.hidden = YES;
    imageView3.hidden = YES;

    
    if ([option1 isEqualToString:correct_ans]) {
        imageView1.hidden = NO;
        imageView1.image = [UIImage imageNamed:@"tick"];
        
        lbl3.layer.borderWidth = 2.0;
        lbl3.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else if ([option2 isEqualToString:correct_ans]){
        imageView2.hidden = NO;
        imageView2.image = [UIImage imageNamed:@"tick"];
        
        lbl4.layer.borderWidth = 2.0;
        lbl4.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else if ([option3 isEqualToString:correct_ans]){
        imageView3.hidden = NO;
        imageView3.image = [UIImage imageNamed:@"tick"];
        
        lbl5.layer.borderWidth = 2.0;
        lbl5.layer.borderColor = [UIColor greenColor].CGColor;
    }
    
    if (![sel_answer isEqualToString:correct_ans]) {
        if ([option1 isEqualToString:sel_answer]) {
            imageView1.hidden = NO;
            imageView1.image = [UIImage imageNamed:@"cross"];
            
            lbl3.layer.borderWidth = 2.0;
            lbl3.layer.borderColor = [UIColor redColor].CGColor;
        }
        else if ([option2 isEqualToString:sel_answer]){
            imageView2.hidden = NO;
            imageView2.image = [UIImage imageNamed:@"cross"];
            
            lbl4.layer.borderWidth = 2.0;
            lbl4.layer.borderColor = [UIColor redColor].CGColor;
        }
        else if ([option3 isEqualToString:sel_answer]){
            imageView3.hidden = NO;
            imageView3.image = [UIImage imageNamed:@"cross"];
            
            lbl5.layer.borderWidth = 2.0;
            lbl5.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
    return cell;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
