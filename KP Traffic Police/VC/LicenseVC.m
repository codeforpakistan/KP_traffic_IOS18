//
//  LicenseVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 06/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "LicenseVC.h"

@interface LicenseVC ()

@end

@implementation LicenseVC{
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"license_data"];
    NSLog(@"%@", dic);
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

//    _bgView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    _bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
//    _bgView.layer.shadowOpacity = 1;
//    _bgView.layer.shadowRadius = 1.0;
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
        lbl1.text = @"Name";
        lbl2.text = [dic objectForKey:@"name"];
    }
    else if (indexPath.row == 1){
        lbl1.text = @"Father Name";
        lbl2.text = [dic objectForKey:@"father_name"];
    }
    else if (indexPath.row == 2){
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
        lbl1.text = @"CNIC Number";
        lbl2.text = [[arr objectAtIndex:0] objectForKey:@"cnic"];
    }
    else if (indexPath.row == 3){
        lbl1.text = @"License Number";
        lbl2.text = [dic objectForKey:@"license_no"];
    }
    else if (indexPath.row == 4){
        lbl1.text = @"District";
        lbl2.text = [dic objectForKey:@"district"];
    }
    else if (indexPath.row == 5){
        lbl1.text = @"License Type";
        lbl2.text = [dic objectForKey:@"license_type"];
    }
    else if (indexPath.row == 6){
        lbl1.text = @"Expiry date";
        lbl2.text = [dic objectForKey:@"expiry_date"];
    }
    return cell;
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
