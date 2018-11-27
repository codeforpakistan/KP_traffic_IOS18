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
@import Firebase;
#import "Reachability.h"

@interface HomeVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation HomeVC{
    UITextField *textField, *textField1;
    SCLAlertView *success_alert, *success_alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *user_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
    NSString *name = [NSString stringWithFormat:@"Welcome, %@", [[user_data objectAtIndex:0] objectForKey:@"name"]];
    _label.text = name;
    
    self.title = @"Our Services";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    //self.navigationController.navigationBar.hidden = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_menuBtn setTarget: self.revealViewController];
        [_menuBtn setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    textField.delegate = self;
    
    
    //analytic
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 2],
                                     kFIRParameterItemName:@"Main(Home) Screen"
                                     }];
    
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
    
    //[[Crashlytics sharedInstance] crash];
    
    Reachability *access = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus status = [access currentReachabilityStatus];
    if (!status) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"No internet connection." subTitle:@"Please check your internet connection and try again." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        textField = [alert addTextField:@""];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [alert addButton:@"Submit" actionBlock:^(void) {
            if (textField.text.length == 13) {
                
                success_alert = [[SCLAlertView alloc] initWithNewWindowWidth:250];
                success_alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
                [success_alert showWaiting:@"" subTitle:@"Processing..." closeButtonTitle:nil duration:0.0];
                [self performSelector:@selector(verification) withObject:self afterDelay:1];
            }
            else{
                SCLAlertView *erralert = [[SCLAlertView alloc] initWithNewWindowWidth:250];
                [erralert showError:@"Error!" subTitle:@"Invalid CNIC" closeButtonTitle:@"OK" duration:0.0f]; // Error
            }
        }];
        
        
        SCLButton *button =[alert addButton:@"Cancel" actionBlock:^{
            //
        }];
        
        
        [alert showEdit:self title:@"License Verification" subTitle:@"Enter CNIC without dishes(-)" closeButtonTitle:nil duration:0.0f];
    }
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
    NSString *error1 = [NSString stringWithFormat:@"%@", [json objectForKey:@"error"]];
    NSLog(@"%@", error1);
    
    
    if ([error1 isEqualToString:@"No record found."]) {
        [success_alert hideView];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        [alert showError:self title:@"Oops" subTitle:@"No record found." closeButtonTitle:@"Ok" duration:0.0f];
    }
    else{
        [success_alert hideView];
        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"LICENSE_DATA"] forKey:@"license_data"];
        [self performSegueWithIdentifier:@"license_segue" sender:self];
    }
}

- (IBAction)Challan_tracking:(id)sender {
    
    Reachability *access = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus status = [access currentReachabilityStatus];
    if (!status) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"No internet connection." subTitle:@"Please check your internet connection and try again." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        textField1 = [alert addTextField:@""];
        textField1.keyboardType = UIKeyboardTypeNumberPad;
        [alert addButton:@"Search" actionBlock:^(void) {
            
            if (![textField1.text isEqualToString:@""]) {
                success_alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:250];
                success_alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
                [success_alert1 showWaiting:@"" subTitle:@"Verifying Challan ID" closeButtonTitle:nil duration:0.0];
                [self performSelector:@selector(challan_tracking) withObject:self afterDelay:1];
            }
        }];
        
        SCLButton *button =[alert addButton:@"Cancel" actionBlock:^{
            //
        }];
        
        [alert showEdit:self title:@"Challan Tracking" subTitle:@"Enter Challan ID" closeButtonTitle:nil duration:0.0f];
    }
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
