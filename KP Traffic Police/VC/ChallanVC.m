//
//  ChallanVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 17/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ChallanVC.h"

@interface ChallanVC ()

@end

@implementation ChallanVC{
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"challan_data"];
    NSLog(@"%@", dic);
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier" forIndexPath:indexPath];
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
    if (indexPath.row == 0) {
        lbl1.text = @"Date";
        lbl2.text = [dic objectForKey:@"date"];
    }
    else if (indexPath.row == 1){
        lbl1.text = @"Distract";
        lbl2.text = [dic objectForKey:@"district"];
    }
    else if (indexPath.row == 2){
        lbl1.text = @"ToName";
        lbl2.text = [dic objectForKey:@"name"];
    }
    else if (indexPath.row == 3){
        lbl1.text = @"Duty Point";
        lbl2.text = [dic objectForKey:@"duty_point"];
    }
    else if (indexPath.row == 4){
        lbl1.text = @"Ticket ID";
        lbl2.text = [dic objectForKey:@"ticket_id"];
    }
    else if (indexPath.row == 5){
        lbl1.text = @"Amount";
        lbl2.text = [dic objectForKey:@"amount"];
    }
    else if (indexPath.row == 6){
        lbl1.text = @"Status";
        lbl2.text = [dic objectForKey:@"status"];
    }
    return cell;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
