//
//  ExamVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 30/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ExamVC.h"
#import "AnswersVC.h"

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

    //progress bar
    _progress_bar.progressTintColor = [UIColor whiteColor];
    _progress_bar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeTrack;
    _progress_bar.stripesColor = [UIColor greenColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    answer_arr = [[NSMutableArray alloc] init];
    sel_answer_arr = [[NSMutableArray alloc] init];
    
    [_progress_bar setProgress:0.0f animated:NO];
    i=0;
    [self questions];
}

-(void)questions{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"question_db.db"];
    
    NSString *val_query = @"select * from record_fetch_value";
    NSArray *arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:val_query]];
    int value = [[[arr objectAtIndex:0] objectAtIndex:0] intValue];
    NSLog(@"%i", value);
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM question_table WHERE id BETWEEN %i AND %i", value, value+19];
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
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
