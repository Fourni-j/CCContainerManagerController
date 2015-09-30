//
//  CCContainerManagerController.m
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 12/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import <Masonry.h>
#import <CCContainerViewController.h>
#import "CCContainerManagerController.h"
#import "CCTabBarController.h"

#define BOTTOM_MESSAGE_HEIGHT 20.0

@interface CCContainerManagerController () <UITabBarControllerDelegate, CCContainerViewControllerDelegate>

@property (strong, nonatomic) UIViewController *actualController;
@property (nonatomic, weak) UILabel *bottomMessageLabel;
@property (nonatomic) BOOL transitioning;

@end

@implementation CCContainerManagerController

#pragma mark - Init

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
        _isCompact = (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact);
    }
    return self;
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.selectedLineColor)
        self.selectedLineColor = [UIColor redColor];
    
    if (!self.actualController)
        return;
    
    [self addActualInterface];
    
    self.view.backgroundColor = self.containerStyle.sideBarBackground;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateFrames];
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    [self updateFrames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Public Methods

- (void)moveLineToSelectedTabBarItem:(BOOL)animate
{
    if([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        [(CCTabBarController *)self.actualController moveLineToSelectedTabBarItem:animate];
    }
}

- (CGRect)frameFormBarItemAtIndex:(NSInteger)index
{
    if([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        return [(CCTabBarController *)self.actualController frameForTabBarItemAtIndex:index];
    }
    else
    {
        return [(CCContainerViewController *)self.actualController frameForTabBarItemAtIndex:index];
    }
}

- (UIView *)viewForTabAtIndex:(NSUInteger)index
{
    if([self.actualController isKindOfClass:[CCTabBarController class]])
    {
        return [(CCTabBarController *)self.actualController viewForTabAtIndex:index];
    }
    else
    {
        return [(CCContainerViewController *)self.actualController viewForTabAtIndex:index];
    }
}

#pragma mark - Bottom Message

- (void)showBottomMessage:(NSAttributedString *)message animated:(BOOL)animate
{
    if(!_bottomMessageLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.minimumScaleFactor = 0.5;
        label.userInteractionEnabled = YES;
        [self.view addSubview:label];
        _bottomMessageLabel = label;
        label.alpha = 0.0;
        
        _bottomMessageLabel.attributedText = message;
        
        [_bottomMessageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomMessageLabelTapped)]];
        
        if(!animate)
        {
            [_actualController.view setNeedsLayout];
            [self updateFrames];
            [self.view layoutIfNeeded];
        }
        else
        {
            _bottomMessageLabel.frame = [self frameForBottomMessage];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
                [_actualController.view setNeedsLayout];
                _actualController.view.frame = [self frameForActualController];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
                _bottomMessageLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        _bottomMessageLabel.attributedText = message;
    }
}

- (void)hideBottomMessageAnimated:(BOOL)animate
{
    if(_bottomMessageLabel == nil) return;
    
    if(!animate)
    {
        [_bottomMessageLabel removeFromSuperview];
        _bottomMessageLabel = nil;
        [self updateFrames];
    }
    else
    {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
            _bottomMessageLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [_bottomMessageLabel removeFromSuperview];
            _bottomMessageLabel = nil;
            
        }];
        
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
            [_actualController.view setNeedsLayout];
            _actualController.view.frame = [self frameForActualController];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Getters & Setters

- (UIViewController *)actualController {
    if (!_actualController) {
        [self buildInterfaceForTabBar:self.isCompact];
    }
    return _actualController;
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

- (UIViewController *)selectedViewController
{
    if ([self.actualController isKindOfClass:[UITabBarController class]])
    {
        return ((CCTabBarController *)self.actualController).selectedViewController;
    }
    else
    {
        return ((CCContainerViewController *)self.actualController).selectedViewController;
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if([self.viewControllers containsObject:selectedViewController])
    {
        self.selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
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

- (void)setSelectedLineColor:(UIColor *)selectedLineColor {
    _selectedLineColor = selectedLineColor;
    
    if (_actualController && [_actualController isKindOfClass:[CCTabBarController class]])
        [(CCTabBarController *)_actualController setSelectedLineColor:_selectedLineColor];
}

#pragma mark - Private Methods

- (void)bottomMessageLabelTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(containerManagerDidSelectBottomMessage:)])
    {
        [_delegate containerManagerDidSelectBottomMessage:self];
    }
}

- (CGRect)frameForActualController
{
    CGRect frame = self.view.bounds;
    if(_bottomMessageLabel)
    {
        frame.size.height -= BOTTOM_MESSAGE_HEIGHT;
    }
    
    return frame;
}

- (CGRect)frameForBottomMessage
{
    CGFloat x = 0;
    if([self.actualController isKindOfClass:[CCContainerViewController class]])
    {
        x = ((CCContainerViewController *)self.actualController).containerStyle.sideBarWidth;
    }
    return CGRectMake(x, self.view.bounds.size.height-BOTTOM_MESSAGE_HEIGHT, self.view.bounds.size.width-x, BOTTOM_MESSAGE_HEIGHT);
}

- (void)updateFrames
{
    if(_actualController)
    {
        _actualController.view.frame = [self frameForActualController];
        [_actualController.view layoutIfNeeded];
    }
    if(_bottomMessageLabel) _bottomMessageLabel.frame = [self frameForBottomMessage];
}

- (void)buildInterfaceForTabBar:(BOOL)forTabBar {
    
    NSArray *tmpViewControllers = (_actualController) ? [self.viewControllers copy] : nil;
    NSArray *viewControllers = nil;
    
    NSInteger index = (_actualController) ? self.selectedIndex : 0;
    _actualController = nil;
    
    if(_transitioning
       && _delegate
       && [_delegate respondsToSelector:@selector(viewControllersForContainerManager:inCompactMode:withViewControllers:)])
    {
        viewControllers = [_delegate viewControllersForContainerManager:self inCompactMode:_isCompact withViewControllers:tmpViewControllers];
    }
    else
    {
        viewControllers = tmpViewControllers;
    }
    
    if (forTabBar)
    {
        CCTabBarController *tabBar = [[CCTabBarController alloc] init];
        tabBar.delegate = self;
        [tabBar setSelectedLineColor:self.selectedLineColor];
        [tabBar setViewControllers:viewControllers];
        [tabBar setSelectedIndex:index];
        [tabBar moveLineToSelectedTabBarItem:NO];
        _actualController = tabBar;
    }
    else
    {
        CCContainerViewController *container = [[CCContainerViewController alloc] init];
        container.delegate = self;
        if(_containerStyle) container.containerStyle = _containerStyle;
        [container setViewControllers:viewControllers];
        container.forceSelection = YES;
        [container setSelectedIndex:index];
        container.forceSelection = NO;
        _actualController = container;
    }
}

- (void)addActualInterface {
    if (!self.actualController)
        return;
    [self addChildViewController:self.actualController];
    [self.view addSubview:self.actualController.view];
    [self updateFrames];
}

- (void)removeActualInterface {
    if (!self.actualController)
        return;
    
    
    [self.actualController removeFromParentViewController];
    [self.actualController.view removeFromSuperview];
}


- (BOOL)shouldSelectViewController:(UIViewController *)viewController {
    if (_delegate && [_delegate respondsToSelector:@selector(containerManager:shouldSelectViewController:)])
        return [_delegate containerManager:self shouldSelectViewController:viewController];
    return YES;
}

- (void)didSelectViewController:(UIViewController *)viewController {
    if (_delegate && [_delegate respondsToSelector:@selector(containerManager:didSelectViewController:)])
        [_delegate containerManager:self didSelectViewController:viewController];
}

#pragma mark - Container Delegate

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassUnspecified)
        return;
    _transitioning = YES;
    _isCompact = (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact);
    [self removeActualInterface];
    [self buildInterfaceForTabBar:self.isCompact];
    [self addActualInterface];
    if(_delegate && [_delegate respondsToSelector:@selector(containerManager:didTransionInCompactMode:)])
    {
        [_delegate containerManager:self didTransionInCompactMode:_isCompact];
    }
    _transitioning = NO;
}


#pragma mark - CCContainer Delegate

- (BOOL)customContainerViewController:(CCContainerViewController *)container shouldSelectViewController:(UIViewController *)viewController {
    return [self shouldSelectViewController:viewController];
}

- (void)customContainerViewController:(CCContainerViewController *)container didSelectViewController:(UIViewController *)viewController {
    [self didSelectViewController:viewController];
}

#pragma mark - UITabBarController Delegate

- (BOOL)tabBarController:(nonnull UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    return [self shouldSelectViewController:viewController];
}

- (void)tabBarController:(nonnull UITabBarController *)tabBarController didSelectViewController:(nonnull UIViewController *)viewController {
    [self didSelectViewController:viewController];
}

@end
