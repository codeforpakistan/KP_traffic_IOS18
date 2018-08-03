//
//  MenuTableView.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 04/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "MenuTableView.h"
#import "LoginVC.h"

@interface MenuTableView ()

@end

@implementation MenuTableView{
    NSArray *menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    menu = @[@"header", @"first", @"second", @"third", @"fourth"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_identifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier forIndexPath:indexPath];
   // cell.textLabel.text = [menu objectAtIndex:indexPath.row];
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }
    else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login_status"];
        LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3){
//        NSString *weblink = @"";
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weblink]];
    }
}
@end
