//
//  ComplaintDetailVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 16/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *label1;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImageView *imgView;
@end
