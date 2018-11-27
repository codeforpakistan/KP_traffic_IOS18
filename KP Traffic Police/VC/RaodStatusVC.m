//
//  RaodStatusVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 19/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "RaodStatusVC.h"
#import <CoreLocation/CoreLocation.h>

@interface RaodStatusVC ()<CLLocationManagerDelegate>

@end

@implementation RaodStatusVC{
    NSArray *dataArr;
    GMSMapView *mapView;
    GMSMarker *marker;
    CLLocationManager *locMngr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Traffic Status";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"road_status"];
    //NSLog(@"%@", dataArr);
    
    //_label.text = [[dataArr objectAtIndex:0] objectForKey:@"route_status"];
    
    
    _view2.layer.borderWidth = 1;
    _view1.layer.borderColor = [UIColor greenColor].CGColor;
    
    locMngr = [[CLLocationManager alloc] init];
    locMngr.delegate = self;
    [locMngr requestWhenInUseAuthorization];
    [locMngr setDesiredAccuracy:kCLLocationAccuracyBest];
    [locMngr startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations lastObject];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:loc.coordinate.latitude
                                                            longitude:loc.coordinate.longitude
                                                                 zoom:14];
    mapView = [GMSMapView mapWithFrame:_view1.layer.bounds camera:camera];
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.myLocationEnabled = YES;
//    [mapView animateToLocation:CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)];
    //    _view1 = mapView;
    mapView.trafficEnabled = YES;
    [_view1 addSubview:mapView];
    [locMngr stopUpdatingLocation];
}


//-(void)coordinate{
//    //polyline
//    NSString *road_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"road_name"];
//    NSLog(@"%@", road_name);
//    GMSMutablePath *path = [GMSMutablePath path];
//    if ([road_name isEqualToString:@"G.T Road"]) {
//        [path addCoordinate:CLLocationCoordinate2DMake(34.017070, 71.621169)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.017032, 71.620246)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016972, 71.619117)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016948, 71.618294)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016857, 71.616462)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016755, 71.614850)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016666, 71.613442)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016690, 71.612645)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016606, 71.611384)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016488, 71.609592)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016404, 71.608136)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016335, 71.606744)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016237, 71.604960)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016179, 71.603702)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016123, 71.602597)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.016041, 71.601245)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015963, 71.599665)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015905, 71.598485)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015841, 71.596908)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015774, 71.595371)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015696, 71.593912)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015632, 71.592254)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015570, 71.590932)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015521, 71.589862)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015459, 71.588639)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015406, 71.587360)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015346, 71.586030)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015324, 71.585258)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015291, 71.584024)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015255, 71.583463)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015151, 71.582358)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.015049, 71.581218)];
//        [path addCoordinate:CLLocationCoordinate2DMake(4.014973, 71.579804)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014882, 71.578310)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014824, 71.577208)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014748, 71.575735)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014672, 71.574059)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014639, 71.572949)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014606, 71.571399)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014548, 71.569452)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014548, 71.568787)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014572, 71.568006)];
//    }
//    else if ([road_name isEqualToString:@"Khyber Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014480, 71.566886)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014480, 71.566435)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014480, 71.565899)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014498, 71.565459)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014498, 71.564922)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014498, 71.564418)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014507, 71.563946)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014507, 71.563442)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014507, 71.562873)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014515, 71.561957)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014515, 71.561496)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014515, 71.561053)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014523, 71.560195)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014531, 71.559781)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014538, 71.559263)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014546, 71.558782)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.558311)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.557887)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.557435)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014546, 71.556983)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014531, 71.556502)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014531, 71.556050)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014546, 71.555513)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.555014)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.554496)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.554043)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014554, 71.553638)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014499, 71.553167)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014468, 71.552753)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014437, 71.552310)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014413, 71.551858)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014382, 71.551339)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014351, 71.550784)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014327, 71.550284)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014304, 71.549738)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014273, 71.549276)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014242, 71.548749)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014218, 71.548240)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014187, 71.547778)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014148, 71.547307)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014117, 71.546817)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014093, 71.546290)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014062, 71.545640)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014031, 71.545140)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013992, 71.544632)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013953, 71.544066)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013906, 71.543539)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013867, 71.543020)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013843, 71.542474)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013828, 71.542229)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013789, 71.541994)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013679, 71.541767)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013547, 71.541523)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013414, 71.541287)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013187, 71.541051)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.012859, 71.540825)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.012531, 71.540618)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.012188, 71.540401)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.011750, 71.540128)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.011243, 71.539808)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010923, 71.539582)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010470, 71.539271)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010134, 71.539045)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009946, 71.538856)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009704, 71.538508)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009517, 71.538187)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009336, 71.537933)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009064, 71.537715)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008805, 71.537496)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008456, 71.537223)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008068, 71.536902)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007737, 71.536645)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007414, 71.536371)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007084, 71.536098)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006786, 71.535856)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006495, 71.535614)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006365, 71.535489)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006022, 71.534928)];
//    }
//    else if ([road_name isEqualToString:@"Charsada Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031714, 71.578076)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031562, 71.577945)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031411, 71.577780)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031077, 71.577344)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031291, 71.577638)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031112, 71.577431)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.030925, 71.577201)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.030654, 71.576884)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.030283, 71.576478)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029894, 71.576111)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029733, 71.576020)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029244, 71.575752)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029007, 71.575645)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.028569, 71.575454)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.028093, 71.575315)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.027882, 71.575257)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.027320, 71.575064)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.027062, 71.574974)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.026351, 71.574718)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.026119, 71.574626)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.025904, 71.574539)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.025629, 71.574427)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.025022, 71.574167)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.024773, 71.574056)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.024046, 71.573728)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.023530, 71.573495)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.023307, 71.573400)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.022587, 71.573121)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.022351, 71.573024)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.021593, 71.572699)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.021407, 71.572636)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.020920, 71.572446)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.020533, 71.572336)];
//    }
//    else if ([road_name isEqualToString:@"Jail Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009411, 71.565522)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009455, 71.565216)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009371, 71.564722)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009126, 71.564304)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008904, 71.563920)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008708, 71.563649)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008671, 71.563585)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008449, 71.563083)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008087, 71.562217)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007796, 71.561485)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007660, 71.561159)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007493, 71.560797)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007095, 71.559909)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006927, 71.559560)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006587, 71.558852)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006376, 71.558420)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.005825, 71.557656)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.005207, 71.556838)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.004440, 71.555862)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.003886, 71.555157)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.003757, 71.554736)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.003421, 71.554028)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.003065, 71.553639)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.002373, 71.553073)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.002248, 71.552921)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.001854, 71.552449)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.001318, 71.551733)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.001293, 71.551575)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.001071, 71.551122)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000925, 71.550831)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000698, 71.550402)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000576, 71.550176)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000191, 71.549530)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000055, 71.549294)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999858, 71.548941)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999438, 71.548150)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999411, 71.547988)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999480, 71.547723)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999665, 71.547494)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999952, 71.547198)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000204, 71.546935)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000434, 71.546722)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000582, 71.546649)];
//    }
//    else if ([road_name isEqualToString:@"University Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997592, 71.490824)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997604, 71.490243)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997604, 71.489648)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997637, 71.489027)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997637, 71.488297)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997671, 71.487648)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997682, 71.487121)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997716, 71.486512)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997749, 71.485863)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997772, 71.485201)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997816, 71.484552)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997861, 71.483876)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997917, 71.483160)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997985, 71.482417)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998041, 71.481565)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998108, 71.480713)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998175, 71.479875)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998220, 71.479024)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998242, 71.478442)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998242, 71.477848)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998254, 71.477172)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998265, 71.476496)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998242, 71.475617)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998265, 71.474766)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998254, 71.474022)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998242, 71.473373)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998197, 71.472887)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998130, 71.472278)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998063, 71.471643)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997996, 71.471129)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997917, 71.470548)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997828, 71.469953)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997727, 71.469332)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997637, 71.468764)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997547, 71.468169)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997480, 71.467520)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997391, 71.466912)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997290, 71.466250)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997211, 71.465736)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997088, 71.465128)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996942, 71.464425)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996808, 71.463681)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996696, 71.462938)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996606, 71.462370)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996438, 71.461910)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996393, 71.461573)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996360, 71.460937)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996360, 71.460342)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996360, 71.459788)];
//    }
//    else if ([road_name isEqualToString:@"Dalazak Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018197, 71.580108)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018199, 71.580594)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018230, 71.581881)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018279, 71.583276)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018319, 71.584585)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018352, 71.585325)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.018846, 71.586162)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.019182, 71.586680)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.019499, 71.587098)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.019890, 71.587602)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.020088, 71.588042)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.020624, 71.588739)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.020924, 71.589171)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.021540, 71.590177)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.022100, 71.590995)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.022480, 71.591483)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.022989, 71.592317)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.023327, 71.592757)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.023627, 71.593186)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.024287, 71.594114)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.024558, 71.594516)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.025096, 71.595401)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.025676, 71.596222)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.026074, 71.596828)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.026319, 71.597142)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.026921, 71.598049)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.027686, 71.599251)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.027997, 71.599852)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.028657, 71.600936)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029028, 71.601529)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.029622, 71.602487)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.030269, 71.603576)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.030836, 71.604555)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031398, 71.605537)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031689, 71.606119)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.031971, 71.606642)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.032409, 71.607393)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.032774, 71.607972)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.033019, 71.608621)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.033190, 71.608881)];
//    }
//    else if ([road_name isEqualToString:@"Saddad Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014953, 71.568376)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014728, 71.568135)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.014386, 71.567698)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013877, 71.567159)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.013088, 71.566231)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.012041, 71.565062)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.011623, 71.564512)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.011432, 71.564268)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.011231, 71.564021)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010937, 71.563662)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010308, 71.562919)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.010165, 71.562747)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009467, 71.561588)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009571, 71.560775)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.009120, 71.559646)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008593, 71.558452)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.008462, 71.558213)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007590, 71.557298)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.007345, 71.557038)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.006638, 71.555970)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.005786, 71.554691)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.005335, 71.553998)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.004417, 71.552649)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.003601, 71.551402)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.002745, 71.550072)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.002425, 71.549557)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.001618, 71.548229)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000588, 71.546660)];
//        [path addCoordinate:CLLocationCoordinate2DMake(34.000377, 71.546341)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.999650, 71.545314)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.998783, 71.544056)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.997916, 71.542645)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.996642, 71.540789)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.995668, 71.539290)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.994763, 71.537927)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.994381, 71.537214)];
//    }
//    else if ([road_name isEqualToString:@"Bagh e Naran Road"]){
//        [path addCoordinate:CLLocationCoordinate2DMake(33.977600, 71.446726)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.977638, 71.447112)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.977424, 71.447622)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.977159, 71.448258)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.976785, 71.449108)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.976409, 71.449974)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.976084, 71.450677)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.975675, 71.451702)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.975286, 71.452654)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974910, 71.453585)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974501, 71.454591)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974134, 71.455578)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973800, 71.456882)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973671, 71.457799)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973633, 71.458877)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973693, 71.459843)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973871, 71.461340)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974024, 71.462603)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974157, 71.463662)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974368, 71.465379)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974599, 71.467074)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974710, 71.467979)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974837, 71.468816)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974988, 71.470189)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.975041, 71.471214)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.975010, 71.472303)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974917, 71.473164)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974750, 71.474124)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974539, 71.474990)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.974238, 71.475851)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973927, 71.476763)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973529, 71.477951)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.973289, 71.479059)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.972984, 71.479924)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.972439, 71.481485)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.971847, 71.483220)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.971262, 71.484872)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.970710, 71.486540)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.970218, 71.487787)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.969691, 71.488943)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.968983, 71.490263)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.968485, 71.491172)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.967497, 71.492921)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.966545, 71.494611)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.965697, 71.496180)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.964983, 71.497478)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.964271, 71.498776)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.963617, 71.499991)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.962927, 71.501236)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.962286, 71.502413)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.961561, 71.503714)];
//        [path addCoordinate:CLLocationCoordinate2DMake(33.961072, 71.504604)];
//    }
//
//    GMSPolyline *line = [GMSPolyline polylineWithPath:path];
//    line.strokeWidth = 3;
//    line.strokeColor = [UIColor blueColor];
//    line.map = mapView;
//}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
