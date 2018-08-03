//
//  LicenseVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 06/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
