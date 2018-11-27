//
//  DemoTestVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 30/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "DemoTestVC.h"

@interface DemoTestVC ()

@end

@implementation DemoTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //for (UIButton *btn in _btns) {
      //  btn.layer.shadowColor = [UIColor grayColor].CGColor;
       // btn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        //btn.layer.shadowOpacity = 1;
        //btn.layer.shadowRadius = 1.0;
    //}
    
    self.title = @"E-Test";
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
