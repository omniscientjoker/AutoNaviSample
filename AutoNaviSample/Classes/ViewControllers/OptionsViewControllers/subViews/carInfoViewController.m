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
#import "CarNumCell.h"
#import "attributionView.h"

@interface carInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,attributionViewDelegate,CarNumCellDelegate>
{
    NSIndexPath * selectIndex;
}
@property(nonatomic, strong)UITableView   * tableView;
@property(nonatomic, strong)NSArray       * titleArray;
@property(nonatomic, strong)NSArray       * placeholderArray;
@property(nonatomic, strong)attributionView     *attView;
@property(nonatomic, strong)UIToolViewTextField *attributionField;
@property(nonatomic, strong)UIToolViewTextField *carNumField;
@end

@implementation carInfoViewController
static NSString *const kCarInfoCellIdentifier = @"kCarInfoCellIdentifier";
static NSString *const kCarInfoCellIdentifier2 = @"kCarInfoCellIdentifier2";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车辆信息";
    [self initDataSoure];
    [self initTableView];
}

- (void)initDataSoure
{
    _titleArray = @[@"车牌号:",@"最大高度(单位:米):",@"火车总重(单位:吨):",@"避开限重路段:"];
    _placeholderArray = @[@"  6位车牌号码",@"  0-10米",@"   0-100吨"];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENRESULTHEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:_tableView];
    
    UIButton * saveBtn = [[UIButton alloc] init];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    saveBtn.backgroundColor = RGB(255, 251, 248);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius  = 5.0f;
    [saveBtn setTitleColor:RGB(243, 101, 28) forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
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
    NSMutableString * locstr = _titleArray[indexPath.row];
    CGFloat titleSize ;
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:locstr];
    NSRange rangeBengin = [locstr rangeOfString:@"("];
    NSRange rangeEnd    = [locstr rangeOfString:@")"];
    if (rangeBengin.length > 0) {
        NSInteger Location = rangeBengin.location;
        NSInteger length   = rangeEnd.location-rangeBengin.location+1;
        [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(Location, length)];
        NSString * normalStr = [locstr substringToIndex:Location];
        NSString * smallStr  = [locstr substringWithRange:NSMakeRange(Location, length)];
        titleSize = [common caculateWidth:normalStr size:[UIFont systemFontOfSize:16.0] height:kCarInfoListCellHeight] + [common caculateWidth:smallStr size:[UIFont systemFontOfSize:12.0] height:kCarInfoListCellHeight]+5;
    }else{
        titleSize = [common caculateWidth:locstr size:[UIFont systemFontOfSize:16.0] height:kCarInfoListCellHeight];
    }
    if (indexPath.row == 0) {
        CarNumCell * cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellIdentifier];
        if (cell == nil) {
            cell = [[CarNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCarInfoCellIdentifier];
        }
        cell.delegate = self;
        if ([LoginUser sharedInstance].carAttribution) {
            [cell.selectBtn setTitle:[LoginUser sharedInstance].carAttribution forState:UIControlStateNormal];
        }else{
            [cell.selectBtn setTitle:@"苏" forState:UIControlStateNormal];
        }
        [cell.selectBtn setTitle:@"苏" forState:UIControlStateNormal];
        cell.titleLabel.text = locstr;
        cell.inputField.placeholder = _placeholderArray[indexPath.row];
        if ([LoginUser sharedInstance].carNum) {
            cell.inputField.text = [LoginUser sharedInstance].carNum;
        }
        cell.inputField.delegate    = self;
        [cell updatecellUIWithSize:titleSize];
        return cell;
    }
    if (indexPath.row < _placeholderArray.count && indexPath.row > 0) {
        CarInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellIdentifier];
        if (cell == nil) {
            cell = [[CarInfoEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCarInfoCellIdentifier];
        }
        cell.titleLabel.attributedText = AttributedString;
        cell.inputField.placeholder = _placeholderArray[indexPath.row];
        if (indexPath.row == 1) {
            if ([LoginUser sharedInstance].carMaxHeight) {
                cell.inputField.text = [LoginUser sharedInstance].carMaxHeight;
            }
        }else{
            if ([LoginUser sharedInstance].carMaxWeight) {
                cell.inputField.text = [LoginUser sharedInstance].carMaxWeight;
            }
        }
        cell.inputField.delegate    = self;
        [cell updatecellUIWithSize:titleSize];
        return cell;
    }else{
        OptionsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoCellIdentifier2];
        if (cell == nil) {
            cell = [[OptionsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCarInfoCellIdentifier2];
        }
        cell.titleLabel.text = locstr;
        [cell setUpCellWithModels:_titleArray[indexPath.row] section:indexPath.section row:indexPath.row];
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
    
}

#pragma mark textDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.attView) {
        [self.attView removeFromSuperview];
    }
    CarInfoEditCell * editcell = (CarInfoEditCell *)[[textField superview] superview];
    selectIndex = [self.tableView indexPathForCell:editcell];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell * editcell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:editcell];
    if (indexPath.row == 0) {
        NSString *regex =@"[a-zA-Z0-9]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:string] == NO) {
            return NO;
        }
        if (string.length > 0) {
            if (textField.text.length > 5) {
                return NO;
            }
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UITableViewCell * editcell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:editcell];
    float num = [textField.text floatValue];
    NSString *regex = @"[0-9.]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:textField.text] == NO) {
        return NO;
    }
    if (indexPath.row == 1) {
        if ( num>10 || num<0 ) {
            return NO;
        }
    }
    if (indexPath.row == 2) {
        if ( num>100 || num<0) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(void)selectAttribution:(NSString *)str
{
    NSIndexPath * index  = [NSIndexPath indexPathForRow:0 inSection:0];
    CarNumCell *cell = [self.tableView cellForRowAtIndexPath:index];
    [cell.selectBtn setTitle:str forState:UIControlStateNormal];
    [cell.inputField endEditing:NO];
}

#pragma mark ClickBtn
- (void)clickButtonToSave
{
    NSInteger num = self.placeholderArray.count;
    for (NSInteger i = 0; i < num ; i++) {
        NSIndexPath * index  = [NSIndexPath indexPathForRow:i inSection:0];
        if (i  == 0 ) {
            CarNumCell *cell = [self.tableView cellForRowAtIndexPath:index];
            [LoginUser sharedInstance].carAttribution = cell.selectBtn.titleLabel.text;
            [LoginUser sharedInstance].carNum = cell.inputField.text;
        }else{
            CarInfoEditCell *cell = [self.tableView cellForRowAtIndexPath:index];
            if (i == 1) {
                [LoginUser sharedInstance].carMaxHeight = cell.inputField.text;
            }else{
                [LoginUser sharedInstance].carMaxWeight = cell.inputField.text;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectAttributionBtnClicked:(id)sender
{
    if (self.attView) {
        [self.attView removeFromSuperview];
    }
    if (selectIndex.row == 0) {
        CarNumCell *cell = [self.tableView cellForRowAtIndexPath:selectIndex];
        [cell.inputField endEditing:YES];
    }else{
        CarInfoEditCell *cell = [self.tableView cellForRowAtIndexPath:selectIndex];
        [cell.inputField endEditing:YES];
    }
    UIButton * btn = (UIButton *)sender;
    self.attView = [[attributionView alloc] initWithAttName:btn.titleLabel.text];
    self.attView.delegate = self;
    self.attView.frame = CGRectMake(0, SCREENHEIGHT/2, SCREENWIDTH, SCREENHEIGHT/2);
    [self.view addSubview:self.attView];
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
