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
#import <AFNetworking.h>
@import Firebase;
#import "Reachability.h"

@interface ComplaintsVC ()<NIDropDownDelegate>

@end

@implementation ComplaintsVC{
    NIDropDown *dropDown;
    UIImagePickerController *imagePciker;
    UIImage *image;
    CLLocationManager *locationManager;
    NSString *latitude, *longitude;
    BOOL check;
    SCLAlertView *waiting_alert;
    NSURL *filePath1;
    NSData *videoData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Complaint";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    imagePciker = [[UIImagePickerController alloc]init];
    imagePciker.delegate = self;
    
    _removeImgBtn.hidden = YES;
    _removeVideoBtn.hidden = YES;
    
    self.sendBtn.layer.cornerRadius = 5;
    
    [self performSelector:@selector(userLocation) withObject:self afterDelay:1];
}

-(void)userLocation{
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
    [[NSUserDefaults standardUserDefaults] setObject:@"category" forKey:@"issue"];
}

- (IBAction)districtBtn:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Abbottabad", @"Bajaur", @"Bannu", @"Batagram", @"Buner", @"Charsadda", @"Chitral", @"Dera Ismail Khan", @"Hangu", @"Haripur", @"Karak", @"Khyber", @"Kohat", @"Kohistan", @"Kurram", @"Lakki Marwat", @"Lower Dir", @"Lower Kohistan", @"Mansehra", @"Mardan", @"Mohmand", @"North Waziristan", @"Nowshera", @"Orakzai", @"Peshawar", @"Shangla", @"South Waziristan", @"Swabi", @"Swat", @"Tank", @"Tor Ghar", @"Upper Dir", nil];
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
    [[NSUserDefaults standardUserDefaults] setObject:@"district" forKey:@"issue"];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)takePicture:(id)sender {
    
    check = NO;
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
    check = YES;
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
        imagePciker.allowsEditing = YES;
        imagePciker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePciker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        [self presentViewController:imagePciker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    filePath1 = [info valueForKey:UIImagePickerControllerImageURL];
    if (check == NO) {
        _removeImgBtn.hidden = NO;
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _imgView.image = image;
        
        _label1.text = @"Replace Picture";
        _label1.textColor = [UIColor redColor];
    }
    else if (check == YES){
        _removeVideoBtn.hidden = NO;
        //video
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@", videoURL);
        videoData = [NSData dataWithContentsOfURL:videoURL];
        
        //image
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
        _vidImgView.image = image;
        
        _label2.text = @"Replace Video";
        _label2.textColor = [UIColor redColor];
        
//        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSLog(@"%lu", [[NSData dataWithContentsOfURL:videoURL] length]);
//
//        NSLog(@"%lu", [[NSData dataWithContentsOfURL:videoURL] length]);
//        NSString *outputPath = [self outputFilePath];
//        NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
//        [self convertVideoToLowQuailtyWithInputURL:videoURL outputURL:outputURL handler:^(AVAssetExportSession *exportSession)
//         {
//             if (exportSession.status == AVAssetExportSessionStatusCompleted)
//             {
//                 videoData = [NSData dataWithContentsOfURL:outputURL];
//                 NSLog(@"%lu", [videoData length]);
//             }
//         }];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (NSString *)outputFilePath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"compressed"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //    return path;
//    if ([fileManager fileExistsAtPath: path])
//    {
//        [fileManager removeItemAtPath:path error:nil];
//    }
//    path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"compressed"] ];
//    NSLog(@"path is== %@", path);
//    return path;
//}
//
//- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
//                                   outputURL:(NSURL*)outputURL
//                                     handler:(void (^)(AVAssetExportSession*))handler
//{
//
//    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
//    //    exportSession.fileLengthLimit = 30*1024;
//    exportSession.outputURL = outputURL;
//    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
//     {
//         handler(exportSession);
//     }];
//}

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
    
    Reachability *access = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus status = [access currentReachabilityStatus];
    if (!status) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [alert showWarning:self title:@"No internet connection." subTitle:@"Please check your internet connection and try again." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        NSArray *user_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
        NSString *signup_id = [[user_data objectAtIndex:0] objectForKey:@"signup_id"];
        NSInteger type_id = [[NSUserDefaults standardUserDefaults] integerForKey:@"complaint_type"];
        NSString *district = _district_btn.titleLabel.text;
        NSLog(@"%@, %li", signup_id, (long)type_id);
        
        if ([_descriptionTF.text isEqualToString:@""] || [district isEqualToString:@"District"]) {
            SCLAlertView *warning = [[SCLAlertView alloc] initWithNewWindowWidth:250];
            warning.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [warning showWarning:@"" subTitle:@"Fill all fields" closeButtonTitle:@"Ok" duration:0.0];
        }
        else{
            waiting_alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
            waiting_alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [waiting_alert showWaiting:@"" subTitle:@"Submitting Complaint Detail...." closeButtonTitle:nil duration:0.0];
            [self performSelector:@selector(complaint) withObject:self afterDelay:1];
        }
    }
    
    //analytic
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 2],
                                     kFIRParameterItemName:@"Complaint send button"
                                     }];
}

-(void)complaint{
    NSArray *user_data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_data"];
    NSString *signup_id = [[user_data objectAtIndex:0] objectForKey:@"signup_id"];
    NSInteger type_id = [[NSUserDefaults standardUserDefaults] integerForKey:@"ddcomplaint_type"];
    NSString *type_id1 = [NSString stringWithFormat:@"%ld", (long)type_id];
    NSString *district = _district_btn.titleLabel.text;
    
    NSDictionary *parameters = @{@"complaint_type_id": type_id1, @"signup_id": signup_id, @"latitude": latitude, @"longitude": longitude, @"description": _descriptionTF.text, @"district": district};

    NSURL *theURL;
    if (check == YES) {
        theURL = [NSURL URLWithString:@"http://103.240.220.76/kptraffic/Complaints/video"];
    }
    else if (check == NO){
        theURL = [NSURL URLWithString:@"http://103.240.220.76/kptraffic/Complaints/image"];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *boundary = @"qqqq___winter_is_coming_!___qqqq";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *key in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss z"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *fileNameStr = [NSString stringWithFormat:@"%@.jpg", dateString];
    
    if (check == true) {
        //video
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video\"; filename=\"%@.mov\"\r\n", fileNameStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mov\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
    }
    
    if (check == NO){
        //image
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", fileNameStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSString *message = [json objectForKey:@"message"];
    NSLog(@"%@", message);
    if ([message isEqualToString:@"Complaint is done!"]) {
        [waiting_alert hideView];
        SCLAlertView *sucess_alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
        [sucess_alert showSuccess:@"Success" subTitle:@"Complaint is successfully submitted." closeButtonTitle:@"Ok" duration:0.0f];
        [sucess_alert alertIsDismissed:^(void){
                    _descriptionTF.text = nil;
            
                    _imgView.image = nil;
                    _removeImgBtn.hidden = YES;
                    _label1.text = @"Take Picture";
                   _label1.textColor = [UIColor grayColor];
            
                _vidImgView.image = nil;
                _removeVideoBtn.hidden = YES;
                _label2.text = @"Take Video";
                _label2.textColor = [UIColor grayColor];
                        //

            [_complaintBtn setTitle:@"Complaints Type" forState:UIControlStateNormal];
            [_district_btn setTitle:@"District" forState:UIControlStateNormal];
            [_complaintBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_district_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

                    }];
                }
                else{
                    [waiting_alert hideView];
                    SCLAlertView *error_alert = [[SCLAlertView alloc] initWithNewWindowWidth:self.view.frame.size.width-50];
                    [error_alert showError:self title:@"Error" subTitle:@"Something went wrong"
                    closeButtonTitle:@"OK" duration:0.0f];
        }
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
