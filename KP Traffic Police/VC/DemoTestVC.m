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
    
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
