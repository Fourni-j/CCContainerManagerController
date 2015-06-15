//
//  CCContainerManagerController.h
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 12/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCContainerStyle.h"

@class CCContainerManagerController;

@protocol CCContainerManagerDelegate <NSObject>
@optional

- (BOOL)containerManager:(CCContainerManagerController *)containerManagerController shouldSelectViewController:(UIViewController *)viewController;

- (void)containerManager:(CCContainerManagerController *)containerManagerController didSelectViewController:(UIViewController *)viewController;

@end

@interface CCContainerManagerController : UIViewController

/**
 *  An array of the root view controllers displayed bu the tab bar interface
 */
@property (copy, nonatomic) NSArray *viewControllers;

/**
 *  The index of the view controller associated with the currently selected tab item
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 *  The current view controller on screen
 */
@property (nonatomic) UIViewController *selectedViewController;

/**
 *  The color of the selection line on tab bar
 */
@property (nonatomic, strong) UIColor *selectedLineColor;

/**
 *  Use a CCCOntainerStyle to personalize CCContainerViewController like colors, size of the menu animations...
 */
@property (nonatomic, strong) CCContainerStyle *containerStyle;

/**
 *  The CCContainerManagerController's delegate object
 */
@property (nonatomic, weak) id<CCContainerManagerDelegate>delegate;

/**
 *  Return a newly initialized CCContainerManagerController with the specified trait collection
 *
 *  @param traitCollection The trait collection used to build CCContainerManagerController
 *
 *  @return A newly initialized CCContainerManagerController object
 */
- (instancetype)initWithTraitCollection:(UITraitCollection *)traitCollection NS_AVAILABLE_IOS(8_0);

/**
 *  If UITabBarController is showing, this method will move the line above the tabBar at the selected item
 *
 *  @param animate will animate if YES
 */
- (void)moveLineToSelectedTabBarItem:(BOOL)animate;

/**
 *  return the button's frame for the specified index
 *  usefull to show popovers
 *  @param index index of the barItem
 *  
 *  @return frame of the bar item
 */
- (CGRect)frameFormBarItemAtIndex:(NSInteger)index;

@end
