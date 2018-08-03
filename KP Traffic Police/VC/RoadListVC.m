//
//  RoadListVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 18/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "RoadListVC.h"
#import "SCLAlertView.h"

@interface RoadListVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation RoadListVC{
    NSArray *road_arr, *address_arr, *flag;
    SCLAlertView *alert;
    NSInteger index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    road_arr = @[@"G.T Road", @"Khyber Road", @"Charsada Road", @"Jail Road", @"University Road", @"Dalazak Road", @"Saddad Road", @"Bagh e Naran Road", @"Warsak Road", @"Kohat Road"];
    address_arr = @[@"Pir Zakuri - suri pul", @"Suri pul - Aman Chowk", @"Ring Road - Bacha Khan Chowk", @"Khyber Bazar - FC Chowk", @"Sifat Ghayour - Phase 3", @"Hashtnaghri flyover", @"Suri pul - Cantt Area", @"Phase-3 Chowk - Baghi e Naran Chowk", @"Maichani Chungi - ICMS College", @"Ramdas Chowk - Kohat Adda"];
    
    flag = @[@"gt_road", @"khyber_road", @"charsadda_road", @"jail_road", @"university_road", @"dalazak_road", @"saddar_road", @"baghenaran_road", @"warsak_road", @"kohat_road"];

    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
    UIView *view = (UIView*)[cell viewWithTag:3];
    view.layer.cornerRadius = 2.0;
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    label1.text = [road_arr objectAtIndex:indexPath.row];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    label2.text = [address_arr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    index = indexPath.row;
    
    alert = [[SCLAlertView alloc] initWithNewWindowWidth:250];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [alert showWaiting:@"" subTitle:@"Wait a while" closeButtonTitle:nil duration:0.0];
    [self performSelector:@selector(road_status) withObject:self afterDelay:1];
}

-(void)road_status{
    NSString *urlStr = [NSString stringWithFormat:@"http://103.240.220.76/kptraffic/live_updates/get_updates?flag=%@", [flag objectAtIndex:index]];
    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
                       [NSURL URLWithString:urlStr]];
    if (UrlData == nil) {
        [alert hideView];
        NSLog(@"data is nil");
    }
    else
    {
        [alert hideView];

        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:UrlData
                              options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                              error:&error];
        NSString *message = [json objectForKey:@"message"];
        if ([message isEqualToString:@"Route status updated!"]) {
            NSArray *data = [json objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"road_status"];
            [self performSegueWithIdentifier:@"road_status_segue" sender:self];
        }
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
