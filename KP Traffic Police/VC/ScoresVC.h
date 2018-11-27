//
//  ScoresVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 10/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ScoresVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

//database...
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *data_array;
@end
