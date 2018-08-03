//
//  RaodStatusVC.h
//  KP Traffic Police
//
//  Created by Romi_Khan on 19/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface RaodStatusVC : UIViewController<GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UILabel *label;
@end
