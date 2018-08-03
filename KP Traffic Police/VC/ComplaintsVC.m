//
//  ComplaintsVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 09/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ComplaintsVC.h"
#import "NIDropDown.h"
#import "SCLAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ComplaintsVC ()

@end

@implementation ComplaintsVC{
    NIDropDown *dropDown;
    UIImagePickerController *imagePciker;
    UIImage *image;
    CLLocationManager *locationManager;
    NSString *latitude, *longitude;
    BOOL check;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagePciker = [[UIImagePickerController alloc]init];
    imagePciker.delegate = self;
    
    _removeImgBtn.hidden = YES;
    _removeVideoBtn.hidden = YES;
    
    //location
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"complaint_type"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];
    
    float latitude1 = loc.coordinate.latitude;
    float longitude1 = loc.coordinate.longitude;
    
    latitude = [NSString stringWithFormat:@"%f", latitude1];
    longitude = [NSString stringWithFormat:@"%f", longitude1];
    [manager stopUpdatingLocation];
}

- (IBAction)categoryBtn:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Traffic Jam", @"Complaint against Wardens", @"Illegal Parking", @"Others", nil];
    NSArray * arrImage = [[NSArray alloc] init];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:self.view.frame.size.width :sender :&f :arr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)takePicture:(id)sender {
    
    check = false;
    if (_vidImgView.image != nil) {
        SCLAlertView *warning = [[SCLAlertView alloc] initWithNewWindowWidth:250];
        warning.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [warning showWarning:@"" subTitle:@"Video recorded already" closeButtonTitle:@"Ok" duration:0.0];
    }
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Choose image from"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gallery = [UIAlertAction
                                  actionWithTitle:@"Gallery"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self galleryImage];
                                  }];
        UIAlertAction *camera = [UIAlertAction
                                 actionWithTitle:@"Camera"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self CameraImage];
                                 }];
        [alert addAction:gallery];
        [alert addAction:camera];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)takeVideo:(id)sender {
    check = true;
    if (_imgView.image != nil) {
        SCLAlertView *warning = [[SCLAlertView alloc] initWithNewWindowWidth:250];
        warning.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [warning showWarning:@"" subTitle:@"Image captured already" closeButtonTitle:@"Ok" duration:0.0];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Choose Video from"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gallery = [UIAlertAction
                                  actionWithTitle:@"Gallery"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self galleryVideo];
                                  }];
        UIAlertAction *camera = [UIAlertAction
                                 actionWithTitle:@"Camera"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self cameraVideo];
                                 }];
        [alert addAction:gallery];
        [alert addAction:camera];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)galleryImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePciker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [imagePciker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePciker animated:YES completion:nil];
    }
}

-(void)CameraImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePciker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [imagePciker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePciker animated:YES completion:nil];
    }
}

-(void)galleryVideo{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePciker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePciker.delegate = self;
        imagePciker.allowsEditing = YES;
        imagePciker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePciker.videoMaximumDuration = 60.0f; // 30 seconds
        imagePciker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
        [self presentViewController:imagePciker animated:YES completion:nil];
    }
}

-(void)cameraVideo{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePciker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePciker.delegate = self;
        imagePciker.allowsEditing = YES;
        imagePciker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePciker.videoMaximumDuration = 60.0f; // 30 seconds
        imagePciker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
        [self presentViewController:imagePciker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (check == false) {
        _removeImgBtn.hidden = NO;
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _imgView.image = image;
        
        _label1.text = @"Replace Picture";
        _label1.textColor = [UIColor redColor];
    }
    else if (check == true){
        _removeVideoBtn.hidden = NO;
        //video
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        //image
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
        _vidImgView.image = image;
        
        _label2.text = @"Replace Video";
        _label2.textColor = [UIColor redColor];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)remove_image:(id)sender {
    _imgView.image = nil;
    _removeImgBtn.hidden = YES;
    
    _label1.text = @"Take Picture";
    _label1.textColor = [UIColor grayColor];
}

- (IBAction)remove_video:(id)sender {
    _vidImgView.image = nil;
    _removeVideoBtn.hidden = YES;
    
    _label2.text = @"Take Video";
    _label2.textColor = [UIColor grayColor];
}

- (IBAction)submit_complaint:(id)sender {
    NSArray *user_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
    NSString *signup_id = [[user_data objectAtIndex:0] objectForKey:@"signup_id"];
    NSInteger type_id = [[NSUserDefaults standardUserDefaults] integerForKey:@"complaint_type"];
    NSLog(@"%@, %li", signup_id, (long)type_id);
    
    //date
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    NSLog(@"My date is = %@", dateString);
    
    
    //image upload
    NSData *imageData = UIImagePNGRepresentation(_imgView.image);
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[imageData length]];
    NSString *imgStr = [imageData base64EncodedStringWithOptions:0];


    NSString *rawString = [NSString stringWithFormat:@"complaint_type_id=%ld&signup_id=%li&latitude=%@&longitude=%@&description=%@&image=%@&phone=%@", type_id, (long)[signup_id integerValue],latitude, longitude, _descriptionTF.text, imgStr, @"122378"];
    NSLog(@"%@", rawString);
    NSData *data1 = [rawString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://103.240.220.76/kptraffic/Complaints/image"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
    completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
            {
            NSURLResponse *response1;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response1 error:&err];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];

                            NSLog(@"%@", json);
                                }];
    [task resume];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
