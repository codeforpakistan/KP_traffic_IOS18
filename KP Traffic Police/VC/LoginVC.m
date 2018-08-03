//
//  LoginVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 29/06/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "LoginVC.h"
#import "RegistrationVC.h"
#import "SCLAlertView.h"
#import "UIView+Toast.h"
#import "SWRevealViewController.h"

@interface LoginVC ()

@end

@implementation LoginVC{
    SCLAlertView *alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nic_tf.text = @"1530345259219";
    
    self.navigationController.navigationBar.hidden = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, _nic_tf.frame.size.height - 1, _nic_tf.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [_nic_tf.layer addSublayer:bottomBorder];
    _nic_tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CNIC without dashes(-)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    _nic_tf.delegate = self;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 13;
}

- (IBAction)user_login:(id)sender {

    if (_nic_tf.text.length < 13) {
        [self.view makeToast:@"Fill all fields" duration:2 position:CSToastPositionCenter];
    }
    else{
        alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:250];
        alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [alert1 showWaiting:@"" subTitle:@"Getting Login" closeButtonTitle:nil duration:0.0];
        [self performSelector:@selector(login) withObject:self afterDelay:1];
    }
}

-(void)login{
    NSString *rawStr = [NSString stringWithFormat:@"cnic=%li", [_nic_tf.text integerValue]];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://103.240.220.76/kptraffic/Login/userLogin"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@", json);
    NSString *message = [json objectForKey:@"message"];
    NSLog(@"%@", json);
    if ([message isEqualToString:@"Login Successfully!"]) {
        [alert1 hideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login_status"];
        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"data"] forKey:@"user_data"];
        
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([message isEqualToString:@"Invalid name or password"]){
        [alert1 hideView];
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        [alert showError:self title:@"Oops" subTitle:@"Invalid CNIC!" closeButtonTitle:@"Ok" duration:0.0f]; // Warning
    }
}

- (IBAction)registerBtn:(id)sender {
    RegistrationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationVC"];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
