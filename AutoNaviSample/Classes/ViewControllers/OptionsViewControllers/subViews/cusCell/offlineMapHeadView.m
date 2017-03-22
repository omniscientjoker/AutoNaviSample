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
@property (nonatomic, assign, readwrite) BOOL        expanded;
@property (nonatomic, strong) UIImageView            *expandImageView;
@property (nonatomic, strong) UILabel                *label;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@end

@implementation offlineMapHeadView
@synthesize delegate,expanded,section,expandImageView,label,singleTapGestureRecognizer;

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

#pragma mark - Utility
- (void)toggle{
    self.expanded = !self.expanded;
    [self updateUI];
    [self notifyDelegate];
}

- (void)updateUI{
    self.expandImageView.highlighted = self.expanded;
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
    self.expandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]
                                             highlightedImage:[UIImage imageNamed:@"arrow_down"]];
    self.expandImageView.center = CGPointMake(MAHeaderViewMargin + CGRectGetWidth(self.expandImageView.bounds) / 2.f, CGRectGetMidY(self.bounds));
    self.expandImageView.highlighted = self.expanded;
    [self addSubview:self.expandImageView];
}

- (void)setupLabel
{
    CGFloat x = CGRectGetMaxX(self.expandImageView.frame) + MAHeaderViewMargin;
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
- (id)initWithFrame:(CGRect)frame expanded:(BOOL)expand
{
    if (self = [super initWithFrame:frame])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor lightGrayColor];
        expanded = expand;
        
        [self setupBackgroundMaskView];
        [self setupExpandImageView];
        [self setupLabel];
        [self setupTapGestureRecognizer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame expanded:NO];
}
@end
