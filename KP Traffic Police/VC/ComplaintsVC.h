//
//  ComplaintsVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 09/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ComplaintsVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *descriptionTF;
@property (strong, nonatomic) IBOutlet UIButton *vidBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *removeImgBtn;
@property (strong, nonatomic) IBOutlet UIButton *removeVideoBtn;
@property (strong, nonatomic) IBOutlet UIImageView *vidImgView;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@end
