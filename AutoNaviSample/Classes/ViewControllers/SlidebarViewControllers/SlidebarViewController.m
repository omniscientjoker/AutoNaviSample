//
//  SlidebarViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "SlidebarViewController.h"
#import "UIImage+blur.h"
#import "UIView+instrument.h"
#import "LoginUser.h"

#import "AmapViewController.h"
#import "MineViewController.h"

@interface SlidebarViewController()
@property (strong, readwrite, nonatomic) UITableView *tableView;
@end

@implementation SlidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([LoginUser sharedInstance].setSlidebarIndex  == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
    }else{
        [LoginUser sharedInstance].setSlidebarIndex = indexPath.row;
        switch (indexPath.row) {
            case 0:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[AmapViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            default:
                break;
        }
    }
    
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Mine", @"Map"];
    NSArray *images = @[@"head_portrait_icon", @"map_portrait_icon"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}
@end
