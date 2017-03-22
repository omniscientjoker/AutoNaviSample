//
//  carInfoViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "carInfoViewController.h"
#import "LoginUser.h"
#import "OptionsListCell.h"
#import "CarInfoEditCell.h"

@interface carInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic, strong)UITableView   * tableView;
@property(nonatomic, strong)NSArray       * titleArray;
@property(nonatomic, strong)NSArray       * placeholderArray;
@property(nonatomic, strong)UIToolViewTextField *attributionField;
@property(nonatomic, strong)UIToolViewTextField *carNumField;
@end

@implementation carInfoViewController
static NSString *const kCarInfoCellIdentifier = @"kCarInfoCellIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车辆信息";
    [self initDataSoure];
    [self initTableView];
    
    
}
- (void)initDataSoure
{
    _titleArray = @[@"车辆所属省:",@"车牌号:",@"最大高度(单位：米)",@"火车总重(单位：吨)",@"避开限重路段"];
    _placeholderArray = @[@"车辆所属省市",@"6位车牌号码",@"0-10米",@"0-100吨"];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENRESULTHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:_tableView];
    [_tableView registerClass:[OptionsListCell class] forCellReuseIdentifier:kCarInfoCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton * saveBtn = [[UIButton alloc] init];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    saveBtn.backgroundColor = RGB(255, 251, 248);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius  = 5.0f;
    [saveBtn setTitleColor:RGB(243, 101, 28) forState:UIControlStateNormal];
    [saveBtn setTitle:@"登录" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(clickButtonToSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
         make.centerX.equalTo(self.view.mas_centerX);
         make.width.mas_equalTo(@250);
         make.height.mas_equalTo(@44);
     }];
}
#pragma mark - tableview dataSoure and  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOptionsListCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _placeholderArray.count) {
        CarInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellIdentifier];
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.inputField.placeholder = _placeholderArray[indexPath.row];
        return cell;
    }else{
        OptionsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellIdentifier];
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.cusSwitch.hidden = NO;
        [cell.cusSwitch setOn:[LoginUser sharedInstance].avoidWeightLimit];
        [cell.cusSwitch addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        if(indexPath.row==0){
        }
        if(indexPath.row==1){
        }
    }else if(indexPath.section==1){
       
        
        
    }
}
- (void)switchViewChanged:(UISwitch *)switchStatus
{
    [LoginUser sharedInstance].avoidWeightLimit = switchStatus.on;
}

- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton*)sender;
    UITouch *touch = [[event allTouches] anyObject];
    if (![button pointInside:[touch locationInView:button] withEvent:event]){
        return nil;
    }
    CGPoint touchPosition = [touch locationInView:self.tableView];
    return [self.tableView indexPathForRowAtPoint:touchPosition];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1)
    {
        
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
