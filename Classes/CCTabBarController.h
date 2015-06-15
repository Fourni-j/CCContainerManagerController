//
//  CCTabBarController.h
//  CCContainerMultitask
//
//  Created by Charles-Adrien Fournier on 15/06/15.
//  Copyright © 2015 Charles-Adrien Fournier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTabBarController : UITabBarController

@property (nonatomic, strong) UIColor *selectedLineColor;

- (void)moveLineToSelectedTabBarItem:(BOOL)animate;

- (CGRect)frameForTabBarItemAtIndex:(NSInteger)index;

- (UIView *)viewForTabAtIndex:(NSUInteger)index;

@end
