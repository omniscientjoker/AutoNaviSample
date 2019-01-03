//
//  RoutePreferencesViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/22.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "RoutePreferencesViewController.h"

@interface RoutePreferencesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView   * tableView;
@end

@implementation RoutePreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
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


#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView * footView = [[UITableViewHeaderFooterView alloc] init];
    return footView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headView = [[UITableViewHeaderFooterView alloc] init];
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"oddda"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"oddda"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}











-(void)clickButtonToSave
{
    NSLog(@"nothing");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
