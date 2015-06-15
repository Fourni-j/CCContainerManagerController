//
//  CCContainerManagerController.h
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 12/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import <UIKit/UIKit.h>

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
- (instancetype)initWithTraitCollection:(UITraitCollection *)traitCollection;

@end
