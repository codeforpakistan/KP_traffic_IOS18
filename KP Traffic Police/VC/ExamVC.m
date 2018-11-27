//
//  ExamVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 30/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ExamVC.h"
#import "AnswersVC.h"
#import "SCLAlertView.h"

@interface ExamVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ExamVC{
    int i;
    float progress;
    NSMutableArray *answer_arr, *sel_answer_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _view1.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _view1.layer.shadowOpacity = 1;
    _view1.layer.shadowRadius = 1.0;


    _progress_bar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _progress_bar.backgroundColor = [UIColor colorWithRed:12/255.0f green:36/255.0f blue:97/255.0f alpha:1.0f];

    //_progress_bar.trackTintColor = [UIColor colorWithRed:12/255.0f green:36/255.0f blue:97/255.0f alpha:0.0f];
    _progress_bar.hideTrack = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    answer_arr = [[NSMutableArray alloc] init];
    sel_answer_arr = [[NSMutableArray alloc] init];
    
    [_progress_bar setProgress:0.0f animated:NO];
    i=0;
    [self questions];
    
    NSString *test_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"test_type"];
    if ([test_type isEqualToString:@"random_test"]) {
        self.title = @"Random Test";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
    else if ([test_type isEqualToString:@"sign_test"]){
        self.title = @"Sign Test";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
    else if ([test_type isEqualToString:@"theory_test"]){
        self.title = @"Theory Test";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
}

-(void)viewDidAppear:(BOOL)animated{
    _question_no_lbl.text = [NSString stringWithFormat:@"Question # %d/20", 1];
}

-(void)questions{
    
    NSString *test_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"test_type"];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"question_db.db"];
    
    NSString *val_query = @"select * from record_fetch_value";
    NSArray *arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:val_query]];
    
    int value;
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
    //answer array
    for (int i=0; i<_data_array.count; i++) {
        [answer_arr addObject:[[_data_array objectAtIndex:i] objectAtIndex:5]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:answer_arr forKey:@"answer_arr"];
    
    NSLog(@"%@", answer_arr);
    _question_lbl.text = [[_data_array objectAtIndex:0] objectAtIndex:1];
    NSString *img_str = [[_data_array objectAtIndex:0] objectAtIndex:6];
    if ([img_str isEqualToString:@"na"]) {
        _imageView.hidden = YES;
    }
    else{
        _imageView.hidden = NO;
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", img_str]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
    UIView *view = (UIView*)[cell viewWithTag:1];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [[UIColor blackColor] CGColor];
    view.layer.cornerRadius = 10.0f;
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:3];
    UILabel *label = (UILabel*)[cell viewWithTag:2];
    if (indexPath.row==0) {
        label1.text = @"A:";
        label.text = [[_data_array objectAtIndex:i] objectAtIndex:2];
    }
    else if (indexPath.row == 1){
        label1.text = @"B:";
        label.text = [[_data_array objectAtIndex:i] objectAtIndex:3];
    }
    else{
        label1.text = @"C:";
        label.text = [[_data_array objectAtIndex:i] objectAtIndex:4];
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //selected answer.
    if (indexPath.row == 0) {
        [sel_answer_arr addObject:[[_data_array objectAtIndex:i] objectAtIndex:2]];
    }
    else if (indexPath.row == 1){
        [sel_answer_arr addObject:[[_data_array objectAtIndex:i] objectAtIndex:3]];
    }
    else if (indexPath.row == 2){
        [sel_answer_arr addObject:[[_data_array objectAtIndex:i] objectAtIndex:4]];
    }
    
    if (i<19) {
        i++;
        progress = progress + 0.05;
        [_tableView reloadData];
        [_progress_bar setProgress:progress animated:YES];
        _progress_bar.progressTintColor = [UIColor colorWithRed:64/255.0f green:163/255.0f blue:158/255.0f alpha:1.0f];
        
        _question_lbl.text = [[_data_array objectAtIndex:i] objectAtIndex:1];
        NSLog(@"%@", [[_data_array objectAtIndex:i] objectAtIndex:1]);
        NSString *img_str = [[_data_array objectAtIndex:i] objectAtIndex:6];
        if ([img_str isEqualToString:@"na"]) {
            _imageView.hidden = YES;
        }
        else{
            _imageView.hidden = NO;
            _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", img_str]];
        }
        
        NSLog(@"%@", sel_answer_arr);
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setObject:sel_answer_arr forKey:@"sel_answer_arr"];
        [self performSegueWithIdentifier:@"answer_segue" sender:self];
    }
    
    _question_no_lbl.text = [NSString stringWithFormat:@"Question # %d/20", 1+i];
}

- (IBAction)back:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
    
    [alert addButton:@"Yes,Leave!" actionBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showWarning:self title:@"No" subTitle:@"Are you sure you want to Leave test!" closeButtonTitle:@"No" duration:0.0f];

}


@end
