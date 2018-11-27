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
@import Firebase;
#import "Reachability.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MyComplaintsVC ()

@end

@implementation MyComplaintsVC{
    NSArray *data;
    SCLAlertView *alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Complaints";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_barBtn setTarget: self.revealViewController];
        [_barBtn setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    Reachability *access = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus status = [access currentReachabilityStatus];
    if (!status) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"No internet connection." subTitle:@"Please check your internet connection and try again." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [alert1 showWaiting:@"" subTitle:@"Wait a while...." closeButtonTitle:nil duration:0.0];
        [self performSelector:@selector(myComplaints) withObject:self afterDelay:1];
    }
    
    //analytic
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 3],
                                     kFIRParameterItemName:@"My Complaint List"
                                     }];
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
                NSLog(@"%@", data);
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"complaint_detail"];
                [_tableView reloadData];
                _tableView.hidden = NO;
                _complaint_label.hidden = YES;
            }
            else if ([message isEqualToString:@"message"]){
                _tableView.hidden = YES;
                _complaint_label.hidden = NO;
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
    _bgView.layer.borderWidth = 1.0f;
    _bgView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    UILabel *label3 = (UILabel*)[cell viewWithTag:3];
    UILabel *label4 = (UILabel*)[cell viewWithTag:4];
    
    /////
    NSString *complaint_type = [[data objectAtIndex:indexPath.row] objectForKey:@"complaint_type"];
    label2.text = complaint_type;
    label3.text = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
    label4.text = [NSString stringWithFormat:@"Status: %@", [[data objectAtIndex:indexPath.row] objectForKey:@"status"]];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Reachability *access = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus status = [access currentReachabilityStatus];
    if (!status) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"No internet connection." subTitle:@"Please check your internet connection and try again." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:indexPath.row] forKey:@"complaintt_detail"];
    }
}

@end
