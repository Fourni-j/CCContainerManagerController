//
//  CCContainerManager.h
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

@property (copy, nonatomic) NSArray *viewControllers;

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, weak) id<CCContainerManagerDelegate>delegate;

- (instancetype)initWithTraitCollection:(UITraitCollection *)traitCollection;

@end
