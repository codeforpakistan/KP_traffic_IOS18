//
//  RegistrationVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 28/06/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationVC : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *TFarray;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phone_no_TF;
@property (strong, nonatomic) IBOutlet UITextField *NIC_TF;
@property (strong, nonatomic) IBOutlet UITextField *EmailTF;
@end
