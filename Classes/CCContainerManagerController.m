//
//  CCContainerManager.m
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 12/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import <Masonry.h>
#import "CCContainerManagerController.h"
#import "CCContainerViewController.h"
#import "CCTabBarController.h"

@interface CCContainerManagerController () <UITabBarControllerDelegate, CCContainerViewControllerDelegate>

@property (strong, nonatomic) UIViewController *actualController;

@property (nonatomic) BOOL  isCompact;

@end

@implementation CCContainerManagerController

- (void)buildInterfaceForTabBar:(BOOL)forTabBar {
    
    
    NSArray *viewControllers = (_actualController) ? [self.viewControllers copy] : nil;
    NSInteger index = (_actualController) ? self.selectedIndex : 0;
    _actualController = nil;
    
    if (forTabBar)
    {
        CCTabBarController *tabBar = [[CCTabBarController alloc] init];
        tabBar.delegate = self;
        [tabBar setViewControllers:viewControllers];
        [tabBar setSelectedIndex:index];
        [tabBar moveLineToSelectedTabBarItem:NO];
        _actualController = tabBar;
    }
    else
    {
        CCContainerViewController *container = [[CCContainerViewController alloc] init];
        container.delegate = self;
        [container setViewControllers:viewControllers];
        [container setSelectedIndex:index];
        _actualController = container;
    }
}

- (void)addActualInterface {
    if (!self.actualController)
        return;
    [self addChildViewController:self.actualController];
    [self.view addSubview:self.actualController.view];
    [self.actualController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)removeActualInterface {
    if (!self.actualController)
        return;
    
    
    [self.actualController removeFromParentViewController];
    [self.actualController.view removeFromSuperview];
}

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {

        _isCompact = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    
    }
    return self;
}

- (instancetype)initWithTraitCollection:(UITraitCollection *)traitCollection {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.isCompact = (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact);
    }
    return self;
    
}

- (UIViewController *)actualController {
    if (!_actualController) {
        [self buildInterfaceForTabBar:self.isCompact];
    }
    return _actualController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.actualController)
        return;
    
    [self addActualInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassUnspecified)
        return;
    self.isCompact = (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact);
    [self removeActualInterface];
    [self buildInterfaceForTabBar:self.isCompact];
    [self addActualInterface];
}


- (NSUInteger)selectedIndex {
    if ([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        return ((CCTabBarController *)self.actualController).selectedIndex;
    }
    else
    {
        return ((CCContainerViewController *)self.actualController).selectedIndex;
    }
}

- (NSArray *)viewControllers {
    if ([self.actualController isKindOfClass:[UITabBarController class]])
    {
        return ((CCTabBarController *)self.actualController).viewControllers;
    }
    else
    {
        return ((CCContainerViewController *)self.actualController).viewControllers;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if ([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        ((CCTabBarController *)self.actualController).selectedIndex = selectedIndex;
    }
    else
    {
        ((CCContainerViewController *)self.actualController).selectedIndex = selectedIndex;
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if ([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        ((CCTabBarController *)self.actualController).viewControllers = viewControllers;
    }
    else
    {
        ((CCContainerViewController *)self.actualController).viewControllers = viewControllers;
    }
}

- (BOOL)shouldSelectViewController:(UIViewController *)viewController {
    if (_delegate && [_delegate respondsToSelector:@selector(containerManager:shouldSelectViewController:)])
        return [_delegate containerManager:self shouldSelectViewController:viewController];
    return YES;
}

- (void)didSelectViewwController:(UIViewController *)viewController {
    if (_delegate && [_delegate respondsToSelector:@selector(containerManager:didSelectViewController:)])
        [_delegate containerManager:self didSelectViewController:viewController];
}

#pragma mark - CCContainer Delegate

- (BOOL)customContainerViewController:(CCContainerViewController *)container shouldSelectViewController:(UIViewController *)viewController {
    return [self shouldSelectViewController:viewController];
}

#pragma mark - UITabBarController Delegate

- (BOOL)tabBarController:(nonnull UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    return [self shouldSelectViewController:viewController];
}

- (void)tabBarController:(nonnull UITabBarController *)tabBarController didSelectViewController:(nonnull UIViewController *)viewController {
    [self didSelectViewwController:viewController];
}

@end
