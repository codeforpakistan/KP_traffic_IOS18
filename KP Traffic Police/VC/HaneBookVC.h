//
//  HaneBookVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 06/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface HaneBookVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//database...
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *data_array;
@end
