//
//  MyComplaintsVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 12/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "MyComplaintsVC.h"
#import "SWRevealViewController.h"
#import "SCLAlertView.h"

@interface MyComplaintsVC ()

@end

@implementation MyComplaintsVC{
    NSArray *data;
    SCLAlertView *alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_barBtn setTarget: self.revealViewController];
        [_barBtn setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
    alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [alert1 showWaiting:@"" subTitle:@"Wait a while...." closeButtonTitle:nil duration:0.0];
    [self performSelector:@selector(myComplaints) withObject:self afterDelay:1];
}

-(void)myComplaints{
    
    NSArray *user_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
    NSString *signup_id = [[user_data objectAtIndex:0] objectForKey:@"signup_id"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://103.240.220.76/kptraffic/complaints/myComplaints?user_id=%@", signup_id];
    NSLog(@"%@", urlStr);
    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
                       [NSURL URLWithString:urlStr]];
    if (UrlData == nil) {
        SCLAlertView *error_alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [error_alert showError:self title:@"Error"
                      subTitle:@"Something went wrong"
              closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
        NSError *error;
        NSMutableDictionary *json = [NSJSONSerialization
                                     JSONObjectWithData:UrlData
                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                     error:&error];
        NSLog(@"%@", json);
        if( error )
        {
            [alert1 hideView];
            SCLAlertView *error_alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
            [error_alert showError:self title:@"Error"
                          subTitle:@"Something went wrong"
                  closeButtonTitle:@"OK" duration:0.0f];
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSString *message = [json objectForKey:@"message"];
            [alert1 hideView];
            if ([message isEqualToString:@"Success!"]) {
                data = [json objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"complaint_detail"];
                [_tableView reloadData];
                _tableView.hidden = NO;
            }
            else if ([message isEqualToString:@"message"]){
                _tableView.hidden = YES;
            }
            
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];

    UIView *_bgView = (UIView*)[cell viewWithTag:10];
    _bgView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 1.0;
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    UILabel *label3 = (UILabel*)[cell viewWithTag:3];
    UILabel *label4 = (UILabel*)[cell viewWithTag:4];
    
    /////
    NSString *complaint_id = [[data objectAtIndex:indexPath.row] objectForKey:@"complaint_id"];
    label2.text = [@"Complaint ID: " stringByAppendingString:complaint_id];
    label3.text = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
    label4.text = [[data objectAtIndex:indexPath.row] objectForKey:@"status"];
    
    //date
    NSString *dateString = [[data objectAtIndex:indexPath.row] objectForKey:@"dated"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *date1 = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"d MMM"];
    NSString *dateString1 = [format stringFromDate:date1];
    label1.text = dateString1;
    
    return cell;
}

@end
