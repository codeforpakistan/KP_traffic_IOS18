//
//  HomeVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 03/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "HomeVC.h"
#import "SWRevealViewController.h"
#import "SCLAlertView.h"

@interface HomeVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end

@implementation HomeVC{
    UITextField *textField, *textField1;
    SCLAlertView *success_alert, *success_alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.hidden = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_menuBtn setTarget: self.revealViewController];
        [_menuBtn setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    textField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 13;
}


- (IBAction)license_verification:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
    
    textField = [alert addTextField:@""];
    
    [alert addButton:@"Submit" actionBlock:^(void) {
        if (textField.text.length == 13) {
            
            success_alert = [[SCLAlertView alloc] initWithNewWindowWidth:250];
            success_alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [success_alert showWaiting:@"" subTitle:@"Processing..." closeButtonTitle:nil duration:0.0];
            [self performSelector:@selector(verification) withObject:self afterDelay:1];
        }
    }];
    
    [alert showEdit:self title:@"License Verification" subTitle:@"Enter CNIC without dishes(-)" closeButtonTitle:nil duration:0.0f];
}

-(void)verification{
    NSString *auth_key = @"352b987e917e7b5208d06c883f49a8c5bb836a9d";
    NSString *operation = @"license_data";
    NSString *rawStr = [NSString stringWithFormat:@"auth_key=%@&operation=%@&nic=%@", auth_key, operation, textField.text ];
    NSLog(@"%@", rawStr);
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://api.smilesn.com/ptp/get_data"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                             error:&err];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@", json);
    NSString *error = [json objectForKey:@"error"] ;
    
    if (error == 0) {
        [success_alert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        [alert showError:self title:@"Oops" subTitle:@"Invalid CNIC!" closeButtonTitle:@"Ok" duration:0.0f];
    }
    else{
        [success_alert hideView];
        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"LICENSE_DATA"] forKey:@"license_data"];
        [self performSegueWithIdentifier:@"license_segue" sender:self];
    }
}

- (IBAction)Challan_tracking:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
    
    textField1 = [alert addTextField:@""];
    
    [alert addButton:@"Search" actionBlock:^(void) {
            
        success_alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:250];
        success_alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [success_alert1 showWaiting:@"" subTitle:@"Verifying Challan ID" closeButtonTitle:nil duration:0.0];
        [self performSelector:@selector(challan_tracking) withObject:self afterDelay:1];
    }];
    
    [alert showEdit:self title:@"Challan Tracking" subTitle:@"Enter ID" closeButtonTitle:nil duration:0.0f];
}

-(void)challan_tracking{
    NSString *urlStr = [NSString stringWithFormat:@"http://103.240.220.76/kptraffic/challan/get_challan_info?TicketId=%@", textField1.text];
    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
                       [NSURL URLWithString:urlStr]];
    if (UrlData == nil) {
        NSLog(@"data is nil");
    }
    else
    {
        [success_alert1 hideView];
        NSError *error;
        NSMutableDictionary *data = [NSJSONSerialization
                                     JSONObjectWithData:UrlData
                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                     error:&error];
        NSLog(@"%@", data);
        if( error ){
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
            
            [alert showError:self title:@"Oops" subTitle:@"Error occur" closeButtonTitle:@"Ok" duration:0.0f];
        }
        else{
            NSString *status = [[data objectForKey:@"status"] stringValue];
            if ([status isEqualToString:@"0"]) {
                SCLAlertView *warning = [[SCLAlertView alloc] initWithNewWindowWidth:300];
                warning.showAnimationType = SCLAlertViewShowAnimationFadeIn;
                [warning showWarning:@"Oops" subTitle:@"Challan number not found" closeButtonTitle:@"Ok" duration:0.0];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"data"] forKey:@"challan_data"];
                [self performSegueWithIdentifier:@"challan_segue" sender:self];
            }
        }
    }
}
@end
