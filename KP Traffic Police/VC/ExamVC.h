//
//  ExamVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 30/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "DBManager.h"

@interface ExamVC : UIViewController

@property (strong, nonatomic) IBOutlet YLProgressBar *progress_bar;
@property (strong, nonatomic) IBOutlet UIView *view1;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) IBOutlet UILabel *question_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

//database...
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *data_array;
@property (strong, nonatomic) IBOutlet UILabel *question_no_lbl;
@end
