//
//  RaodStatusVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 19/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "RaodStatusVC.h"

@interface RaodStatusVC ()

@end

@implementation RaodStatusVC{
    NSArray *dataArr;
    GMSMapView *mapView;
    GMSMarker *marker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"road_status"];
    NSLog(@"%@", dataArr);
    
    _label.text = [[dataArr objectAtIndex:0] objectForKey:@"route_status"];
    
    [self map_view];
    
    _view2.layer.borderWidth = 1;
    _view1.layer.borderColor = [UIColor greenColor].CGColor;
}

-(void)map_view{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:33.9949551
                                                            longitude:71.4902611
                                                                 zoom:12];
    mapView = [GMSMapView mapWithFrame:_view1.layer.bounds camera:camera];
    mapView.settings.compassButton = YES;
    //mapView.settings.myLocationButton = YES;
    //mapView.myLocationEnabled = YES;
//    _view1 = mapView;
    mapView.trafficEnabled = YES;
    [_view1 addSubview:mapView];
    mapView.delegate = self;
    
    //line path
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(33.9982542, 71.4602803)];
    [path addCoordinate:CLLocationCoordinate2DMake(33.9949551, 71.4902611)];
    
    GMSPolyline *line = [GMSPolyline polylineWithPath:path];
    line.strokeWidth = 3;
    line.strokeColor = [UIColor redColor];
    line.map = mapView;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
