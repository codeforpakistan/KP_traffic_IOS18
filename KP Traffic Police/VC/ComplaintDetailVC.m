//
//  ComplaintDetailVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 16/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ComplaintDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVKit/AVKit.h>

@interface ComplaintDetailVC ()

@end

@implementation ComplaintDetailVC{
    NSDictionary *data;
    NSArray *data1;
    NSString *complaint_type, *complaint_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Complaint Detail";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    
    data = [[NSUserDefaults standardUserDefaults] objectForKey:@"complaintt_detail"];
    NSLog(@"%@", data);
    _label1.text = [data objectForKey:@"complaint_type"];
    complaint_id = [data objectForKey:@"complaint_id"];
    
    AVPlayerViewController *videoController = [[AVPlayerViewController alloc] init];
    NSString *videoStr = [data objectForKey:@"video"];
    NSString *strTextEscaped = [videoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![videoStr isEqualToString:@""]) {
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/videos/%@", strTextEscaped]]];
        videoController.player = player;
        [player play];
        
        [self addChildViewController:videoController];
        [self.scrollView addSubview:videoController.view];
        videoController.view.frame = self.imageView.frame;
        
        //
        videoController.view.hidden = NO;
        _imgView.hidden = YES;
        
        _response_lbl.hidden = YES;
    }
    
    
    NSString *imgStr = [data objectForKey:@"image"];
    if (![imgStr isEqualToString:@""]) {
        NSString *strTextEscaped = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/images/%@", strTextEscaped]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _imageView.image = image;
        }];
        
        videoController.view.hidden = YES;
        _imgView.hidden = NO;
    }
    
    [self performSelector:@selector(status_response) withObject:self afterDelay:1];
}

-(void)status_response{
    NSString *urlStr = [NSString stringWithFormat:@"http://103.240.220.76/kptraffic/complaints/complaint_response?complaint_id=%@", complaint_id];
    NSLog(@"%@", urlStr);
    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
                       [NSURL URLWithString:urlStr]];
    if (UrlData == nil) {
        NSLog(@"Error");
    }
    else
    {
        NSError *error;
        NSMutableDictionary *json = [NSJSONSerialization
                                     JSONObjectWithData:UrlData
                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                     error:&error];
        
        NSLog(@"%@", json);
            NSString *message = [json objectForKey:@"message"];
            if ([message isEqualToString:@"Success!"]) {
                data1 = [json objectForKey:@"data"];
                [self.tableView1 reloadData];
                
        }
        if (data1.count == 0) {
            _response_lbl.hidden = NO;
            _tableView1.hidden = YES;
        }
        else{
            _response_lbl.hidden = YES;
            _tableView1.hidden = NO;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 3;
    } else {
        return data1.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
        
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
        
        if (indexPath.row==0) {
            lbl1.text = @"Description";
            lbl2.text = [data objectForKey:@"description"];
            NSLog(@"%@", [data objectForKey:@"description"]);
//            CGSize maximumLabelSize = CGSizeMake(280, 9999);
//            CGSize expectedLabelSize = [lbl2 sizeThatFits:maximumLabelSize];
//
//            CGRect newFrame = lbl2.frame;
//
//            newFrame.size.height = expectedLabelSize.height;
//
//            lbl2.frame = newFrame;
        }
        else if (indexPath.row==1) {
            lbl1.text = @"Status";
            lbl2.text = [data objectForKey:@"status"];
        }
        else if(indexPath.row ==2){
            lbl1.text = @"Complaint Date";
            NSString *dateString = [data objectForKey:@"dated"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
            NSDate *date1 = [dateFormatter dateFromString:dateString];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"d MMM"];
            NSString *dateString1 = [format stringFromDate:date1];
            lbl2.text = dateString1;
        }
        
        UIView *view = (UIView*)[cell viewWithTag:100];
        view.layer.cornerRadius = 5;
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier1"];
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
        UILabel *lbl3 = (UILabel *)[cell viewWithTag:3];

        lbl1.text = [NSString stringWithFormat:@"  Response No. %li", indexPath.row+1];
        NSString *status = [[data1 objectAtIndex:indexPath.row] objectForKey:@"response_status"];
        if ([status isEqualToString:@"1"]) {
            lbl2.text = @"Completed";
        }
        else if ([status isEqualToString:@"2"]){
            lbl2.text = @"Pending";
        }
        else if ([status isEqualToString:@"3"]){
            lbl2.text = @"In Progress";
        }
        else if ([status isEqualToString:@"4"]){
            lbl2.text = @"Irrelevant";
        }
        else if ([status isEqualToString:@"5"]){
            lbl2.text = @"Not Understandable";
        }
        
        lbl3.text = [NSString stringWithFormat:@"%@", [[data1 objectAtIndex:indexPath.row] objectForKey:@"complaint_response"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        _tableView1.frame = CGRectMake(_tableView1.frame.origin.x, _tableView1.frame.origin.y, _tableView1.frame.size.width, _tableView1.contentSize.height);
        
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + _tableView1.contentSize.height)];
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
