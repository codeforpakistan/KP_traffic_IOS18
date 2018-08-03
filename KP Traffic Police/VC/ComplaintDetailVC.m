//
//  ComplaintDetailVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 16/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ComplaintDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComplaintDetailVC ()

@end

@implementation ComplaintDetailVC{
    NSArray *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    data = [[NSUserDefaults standardUserDefaults] objectForKey:@"complaint_detail"];
    _label1.text = [[data objectAtIndex:0] objectForKey:@"complaint_type"];
    
    NSString *imgStr = [[data objectAtIndex:0] objectForKey:@"image"];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/images/%@", imgStr]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _imageView.image = image;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier"];
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
    
    if (indexPath.row==0) {
        lbl1.text = @"Description";
        lbl2.text = [[data objectAtIndex:0] objectForKey:@"description"];
    }
    else if (indexPath.row==1) {
        lbl1.text = @"Status";
        lbl2.text = [[data objectAtIndex:0] objectForKey:@"status"];
    }
    else if(indexPath.row ==2){
        lbl1.text = @"Complaint Date";
        NSString *dateString = [[data objectAtIndex:0] objectForKey:@"dated"];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.contentSize.height);
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
