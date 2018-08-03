//
//  MyComplaintsVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 12/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyComplaintsVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtn;
@end
