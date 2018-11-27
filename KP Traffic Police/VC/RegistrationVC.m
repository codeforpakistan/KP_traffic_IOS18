//
//  RegistrationVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 28/06/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "RegistrationVC.h"
#import "SCLAlertView.h"
#import "LoginVC.h"
#import "UIView+Toast.h"
#import "SWRevealViewController.h"

@interface RegistrationVC ()

@end

@implementation RegistrationVC{
    SCLAlertView *alert1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *tf in _TFarray) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, tf.frame.size.height - 1, tf.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
        [tf.layer addSublayer:bottomBorder];
    }
    
    _nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _phone_no_TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"03XX1234567" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _NIC_TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CNIC without dashes(-)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _EmailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    _NIC_TF.delegate = self;
    _phone_no_TF.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField  == _NIC_TF) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 13;
    }
    else if (textField == _phone_no_TF){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 11;
    }
    return 0;
}

- (IBAction)create_userAccount:(id)sender {
    BOOL validEmail = [self validateEmail:_EmailTF.text];
    
    if (_NIC_TF.text.length < 13 || _phone_no_TF.text.length < 11 || [_EmailTF.text isEqualToString:@""] || [_nameTF.text isEqualToString:@""]) {
        [self.view makeToast:@"Fill all fields" duration:2 position:CSToastPositionCenter];
    }
    else if (!validEmail){
        [self.view makeToast:@"Invalid Email" duration:1.0 position:CSToastPositionCenter];
    }
    else{
        alert1 = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        alert1.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [alert1 showWaiting:@"" subTitle:@"Wait a while...." closeButtonTitle:nil duration:0.0];
        [self performSelector:@selector(user_registration) withObject:self afterDelay:1];
    }
}

- (BOOL)validateEmail:(NSString *)inputText {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        int indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

-(void)user_registration{
    NSString *rawStr = [NSString stringWithFormat:@"cnic=%@& name=%@& email=%@& phone_no=%@&", _NIC_TF.text, _nameTF.text, _EmailTF.text, _phone_no_TF.text];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://103.240.220.76/kptraffic/Signup/signup"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                             error:&err];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@", [json objectForKey:@"message"]);
    if ([[json objectForKey:@"message"] isEqualToString:@"Registration Successful, please login now!"]) {
        [alert1 hideView];
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        
        [alert showSuccess:self title:@"Success" subTitle:@"You have been registered." closeButtonTitle:@"Ok" duration:0.0f];
        [alert alertIsDismissed:^{
            LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.revealViewController pushFrontViewController:vc animated:YES];
            [self.navigationController pushViewController:vc animated:NO];
        }];
    }
    else if ([[json objectForKey:@"message"] isEqualToString:@"CNIC already exists! Try another."]){
        [alert1 hideView];

        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"Oops" subTitle:@"CNIC already exist." closeButtonTitle:@"Ok" duration:0.0f]; // Warning
        _NIC_TF.text = @"";
    }
}
- (IBAction)backBtn:(id)sender {
    LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.revealViewController pushFrontViewController:vc animated:YES];
    [self.navigationController pushViewController:vc animated:NO];}
@end
