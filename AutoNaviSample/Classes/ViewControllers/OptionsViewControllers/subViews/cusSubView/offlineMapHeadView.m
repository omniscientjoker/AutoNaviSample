//
//  offlineMapHeadView.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "offlineMapHeadView.h"
#define MAHeaderViewMargin 5.f

@interface offlineMapHeadView ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign, readwrite) BOOL         expanded;
@property (nonatomic, strong) UIButton               *selectedBtn;
@property (nonatomic, strong) UIImageView            *expandImageView;
@property (nonatomic, strong) UILabel                *label;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@end

@implementation offlineMapHeadView
@synthesize delegate, expanded, selected, section, expandImageView, selectedBtn, selectedImageView, label,singleTapGestureRecognizer;

#pragma mark - Interface
- (NSString *)text{
    return self.label.text;
}

- (void)setText:(NSString *)text{
    self.label.text = text;
}

#pragma mark - Handle Gesture
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self toggle];
}
- (void)clickSelectedBtn:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(headerView:section:selected:)])
    {
        [self.delegate headerView:self section:self.section selected:self.selected];
    }
}
#pragma mark - Utility
- (void)toggle{
    self.expanded = !self.expanded;
    [self updateUI];
    [self notifyDelegate];
}

- (void)updateUI{
    self.expandImageView.highlighted = self.expanded;
    self.selectedImageView.highlighted = self.selected;
}


- (void)notifyDelegate{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(headerView:section:expanded:)])
    {
        [self.delegate headerView:self section:self.section expanded:self.expanded];
    }
}

#pragma mark - Initialization
- (void)setupExpandImageView
{
    self.expandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]
                                             highlightedImage:[UIImage imageNamed:@"icon_arrow_down"]];
    
    self.expandImageView.center = CGPointMake(MAHeaderViewMargin*2 + CGRectGetWidth(self.selectedImageView.bounds) + CGRectGetWidth(self.expandImageView.bounds) / 2.f, CGRectGetMidY(self.bounds));
    self.expandImageView.highlighted = self.expanded;
    [self addSubview:self.expandImageView];
}
- (void)setupSelectedBtn
{
    self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MAHeaderViewMargin*2 + CGRectGetWidth(self.selectedImageView.bounds), CGRectGetHeight(self.bounds))];
    [self.selectedBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedBtn];
    
}
- (void)setupSelectedImageView
{
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unselected_round"]
                                             highlightedImage:[UIImage imageNamed:@"icon_selected_round"]];
    self.selectedImageView.center = CGPointMake(MAHeaderViewMargin + CGRectGetWidth(self.selectedImageView.bounds) / 2.f, CGRectGetMidY(self.bounds));
    self.selectedImageView.highlighted = self.selected;
    [self addSubview:self.selectedImageView];
}
- (void)setupLabel
{
    CGFloat x = CGRectGetMaxX(self.expandImageView.frame) + MAHeaderViewMargin;;
    
    CGRect theRect = CGRectMake(x,
                                MAHeaderViewMargin,
                                CGRectGetWidth(self.bounds) - x - MAHeaderViewMargin,
                                CGRectGetHeight(self.bounds) - MAHeaderViewMargin * 2.f);
    
    self.label = [[UILabel alloc] initWithFrame:theRect];
    self.label.backgroundColor  = [UIColor clearColor];
    self.label.textColor        = [UIColor blackColor];
    [self addSubview:self.label];
}

- (void)setupBackgroundMaskView
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)];
    maskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:maskView];
}

- (void)setupTapGestureRecognizer
{
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    self.singleTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.singleTapGestureRecognizer];
}

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame expanded:(BOOL)expand isManager:(BOOL)manager
{
    if (self = [super initWithFrame:frame])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor lightGrayColor];
        expanded = expand;
        selected = NO;
        
        [self setupBackgroundMaskView];
        if (manager) {
            [self setupSelectedImageView];
            [self setupSelectedBtn];
        }
        [self setupExpandImageView];
        
        [self setupLabel];
        [self setupTapGestureRecognizer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame expanded:NO isManager:NO];
}
@end
