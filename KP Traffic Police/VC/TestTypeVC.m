//
//  TestTypeVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 29/08/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "TestTypeVC.h"
@import Firebase;

@interface TestTypeVC ()

@end

@implementation TestTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"E-Test Category";
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)randomTest:(id)sender {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemName:@"Random_Test",
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 8]
                                     }];
    [[NSUserDefaults standardUserDefaults] setObject:@"random_test" forKey:@"test_type"];
}

- (IBAction)signTest:(id)sender {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 9],
                                     kFIRParameterItemName:@"Sign_Test"
                                     }];
    [[NSUserDefaults standardUserDefaults] setObject:@"sign_test" forKey:@"test_type"];
}

- (IBAction)theoryTest:(id)sender {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 10],
                                     kFIRParameterItemName:@"Theory_Test"
                                     }];
    [[NSUserDefaults standardUserDefaults] setObject:@"theory_test" forKey:@"test_type"];
}
@end
