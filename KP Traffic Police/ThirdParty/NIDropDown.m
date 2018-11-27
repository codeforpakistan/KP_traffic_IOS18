//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation NIDropDown{
    int country_id;
    NSMutableArray *cities_id;
}
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(float)width :(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction {
    
    
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.layer.borderWidth = 2;
        table.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(0, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        table.center = CGPointMake(width/2, table.center.y);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    //btn background color.
    UIButton *btn = (UIButton*)btnSender;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"issue"];
    if ([str isEqualToString:@"category"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row+1 forKey:@"ddcomplaint_type"];
        NSLog(@"%ld", indexPath.row+1);
    }
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    imgView.image = c.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    [btnSender addSubview:imgView];
    [self myDelegate];

}



//-(void)ftn2{
//    NSString *urlStr = [NSString stringWithFormat:@"https://wefpae.com/screen/app/city.php?country_id=%ld", (long)_selected_country_id2];
//    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
//                       [NSURL URLWithString:urlStr]];
//    NSError *error;
//    NSMutableDictionary *data = [NSJSONSerialization
//                                 JSONObjectWithData:UrlData
//                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
//                                 error:&error];
//    NSLog(@"city   ..%@", data);
//    NSArray *arr = [data objectForKey:@"cityinfo"];
//    NSMutableArray *cities = [[NSMutableArray alloc] init];
//
//    for (int i=0; i<arr.count; i++) {
//        [cities addObject:[[arr objectAtIndex:i] objectForKey:@"title"]];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:cities forKey:@"city1"];
//}
//
//-(void)ftn3{
//    NSString *urlStr = [NSString stringWithFormat:@"https://wefpae.com/screen/app/city.php?country_id=%ld", (long)_selected_country_id3];
//    NSData *UrlData = [[NSData alloc] initWithContentsOfURL:
//                       [NSURL URLWithString:urlStr]];
//    NSError *error;
//    NSMutableDictionary *data = [NSJSONSerialization
//                                 JSONObjectWithData:UrlData
//                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
//                                 error:&error];
//    NSArray *arr = [data objectForKey:@"cityinfo"];
//    NSMutableArray *cities = [[NSMutableArray alloc] init];
//
//    for (int i=0; i<arr.count; i++) {
//        [cities addObject:[[arr objectAtIndex:i] objectForKey:@"title"]];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:cities forKey:@"city2"];
//
//    NSLog(@"city   ..%@", data);
//}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
