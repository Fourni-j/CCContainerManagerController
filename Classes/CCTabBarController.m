//
//  CCTabBarController.m
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 15/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import "CCTabBarController.h"

@interface CCTabBarController ()

@property (nonatomic, weak) UIView *selectedLine;

@end

@implementation CCTabBarController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.selectedLineColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1 / [UIScreen mainScreen].scale, self.tabBar.bounds.size.width, 1)];
    view.backgroundColor = self.selectedLineColor;
    view.hidden = YES;
    [self.tabBar addSubview:view];
    _selectedLine = view;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self moveLineToSelectedTabBarItem:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [NSThread sleepForTimeInterval:0.02];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self moveLineToSelectedTabBarItem:YES];
        });
    });
}

- (void)moveLineToSelectedTabBarItem:(BOOL)animate {
    if (self.selectedIndex >= 5 ) return;
    
    CGRect itemFrame = [[self class] frameForTabInTabBar:self.tabBar withIndex:self.selectedIndex];
    itemFrame = CGRectMake(itemFrame.origin.x, -1 / [UIScreen mainScreen].scale, itemFrame.size.width, 1);
    
    if (_selectedLine.hidden || !animate)
    {
        _selectedLine.frame = itemFrame;
        _selectedLine.hidden = NO;
    }
    else
    {
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:0 animations:^{
            _selectedLine.frame = itemFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (CGRect)frameForTabBarItemAtIndex:(NSInteger)index {
    return [[self class] frameForTabInTabBar:self.tabBar withIndex:index];
}

- (UIView *)viewForTabAtIndex:(NSUInteger)index {
    NSUInteger currentTabIndex = 0;
    
    for (UIView* subview in self.tabBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            if (currentTabIndex == index)
                return subview;
            else
                currentTabIndex++;
        }
    }
    return nil;
}

- (void)setSelectedLineColor:(UIColor *)selectedLineColor {
    _selectedLineColor = selectedLineColor;
    if (_selectedLine){
        _selectedLine.backgroundColor = _selectedLineColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (CGRect)frameForTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index
{
    NSUInteger currentTabIndex = 0;
    
    for (UIView* subView in tabBar.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            if (currentTabIndex == index)
                return subView.frame;
            else
                currentTabIndex++;
        }
    }
    
    NSAssert(NO, @"Index is out of bounds");
    return CGRectNull;
}

@end
