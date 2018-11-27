//
//  EducationVC.m
//  KP Traffic Police
//
//  Created by Romi_Khan on 17/07/2018.
//  Copyright © 2018 SoftBrain. All rights reserved.
//

#import "EducationVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SCLAlertView.h"
@import Firebase;

@interface EducationVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@end

@implementation EducationVC{
    NSMutableDictionary *json;
    NSArray *data;
    SCLAlertView *success_alert;
    NSMutableArray *filteredArray;
    BOOL isFiltered;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Traffic Education";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _collectioView.delegate = self;
    _collectioView.dataSource = self;
    
    _searchBar.delegate = self;
    
    success_alert = [[SCLAlertView alloc] initWithNewWindowWidth:250];
    success_alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [success_alert showWaiting:@"" subTitle:@"Loading Data" closeButtonTitle:nil duration:0.0];
    [self performSelector:@selector(traffic_education_data) withObject:self afterDelay:1];
    
    
    //analytic
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"%i", 6],
                                     kFIRParameterItemName:@"Traffic_Education_List"
                                     }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)traffic_education_data{
    NSString *urlStr = [NSString stringWithFormat:@"http://103.240.220.76/kptraffic/traffic_education/getEducationSigns"];
    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
                       [NSURL URLWithString:urlStr]];
    if (UrlData == nil) {
        [success_alert hideView];
        NSLog(@"data is nil");
    }
    else
    {
        [success_alert hideView];
        NSError *error;
        json = [NSJSONSerialization
                    JSONObjectWithData:UrlData
                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                     error:&error];
        NSLog(@"%@", json);
        NSString *message = [json objectForKey:@"message"];
        if ([message isEqualToString:@"Success!"]) {
            data = [json objectForKey:@"data"];
            [_collectioView reloadData];
            NSLog(@"%lu", (unsigned long)data.count);
        }
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
    }
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        isFiltered = NO;
    }
    else{
        
        isFiltered = YES;
    }
    
    filteredArray = [[NSMutableArray alloc]init];
    
//    for (NSDictionary *item in json) {
//        NSString *str = [item objectForKey:@"image_title"];
//        NSRange strRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        if (strRange.location != NSNotFound) {
//
//            [filteredArray addObject:item];
//        }
//    }
    
    for (int i=0; i<data.count; i++) {
        NSString *str = [[data objectAtIndex:i] objectForKey:@"image_title"];
        NSRange strRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (strRange.location != NSNotFound) {
            [filteredArray addObject:[data objectAtIndex:i]];
        }
    }
    
    [_collectioView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isFiltered) {
        return filteredArray.count;
    }
    else{
        return data.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_identifier" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:10];
    UILabel *label = (UILabel*)[cell viewWithTag:11];
    
    if (isFiltered) {
        NSString *imgStr = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/traffic-education/%@", imgStr]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            imageView.image = image;
        }];
     
        label.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"image_title"];
    }
    else{
        NSString *imgStr = [[data objectAtIndex:indexPath.row] objectForKey:@"image"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://103.240.220.76/kptraffic/uploads/traffic-education/%@", imgStr]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            imageView.image = image;
        }];
        
        label.text = [[data objectAtIndex:indexPath.row] objectForKey:@"image_title"];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isFiltered) {
        [[NSUserDefaults standardUserDefaults] setObject:[filteredArray objectAtIndex:indexPath.row] forKey:@"sign_detail"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:indexPath.row] forKey:@"sign_detail"];
    }
    
    [self performSegueWithIdentifier:@"imagedetail_segue" sender:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((_collectioView.frame.size.width-50)/2, (_collectioView.frame.size.width-30)/2);
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
