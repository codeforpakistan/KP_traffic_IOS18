//
//  AnswersVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 01/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AnswersVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *score_lbl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//database...
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *data_array;
@end
