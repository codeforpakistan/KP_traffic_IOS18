//
//  ImageDetailVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 18/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "ImageDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import Firebase;

@interface ImageDetailVC ()

@end

@implementation ImageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self performSelector:@selector(ftn) withObject:self afterDelay:0.5];
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 7],
                                     kFIRParameterItemName:@"Traffic Education Detail"
                                     }];
}

-(void)ftn{
    _view1.layer.cornerRadius = 8.0;
    _view2.layer.cornerRadius = 8.0;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sign_detail"];
    _title_label.text = [dic objectForKey:@"image_title"];
    _label1.text = [dic objectForKey:@"image_description_eng"];
    _label2.text = [dic objectForKey:@"image_description_urdu"];
    
    if ([[dic objectForKey:@"image"] isEqualToString:@"signal.gif"]) {
        _imageView.hidden = YES;
        _imageView1.hidden = NO;
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/traffic-education/%@", [dic objectForKey:@"image"]]]]];
        _imageView1.animatedImage = image;
    }else{
        _imageView.hidden = NO;
        _imageView1.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/traffic-education/%@", [dic objectForKey:@"image"]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _imageView.image = image;
        }];
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
