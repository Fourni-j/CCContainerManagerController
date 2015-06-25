//
//  ViewController.m
//  CCContainerManagerControllerDemo
//
//  Created by Charles-Adrien Fournier on 15/06/15.
//  Copyright (c) 2015 Charles-Adrien Fournier. All rights reserved.
//

#import "ViewController.h"
#import "CCContainerManagerController.h"
#import <CCContainerViewController.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)open:(id)sender
{
    UIViewController *vc1 = [[UIViewController alloc] init];
    CCBarItem *item1 = [[CCBarItem alloc] initWithTitle:@"vc1" image:[UIImage imageNamed:@"user"]];
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTitle:@"vc1" image:[UIImage imageNamed:@"user"] selectedImage:nil];
    vc1.view.backgroundColor = [UIColor greenColor];
    vc1.barItem = item1;
    vc1.tabBarItem = barItem1;
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    CCBarItem *item2 = [[CCBarItem alloc] initWithTitle:@"vc2" image:[UIImage imageNamed:@"camera"]];
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTitle:@"vc2" image:[UIImage imageNamed:@"camera"] selectedImage:nil];
    vc2.view.backgroundColor = [UIColor redColor];
    vc2.barItem = item2;
    vc2.tabBarItem = barItem2;
    
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    CCBarItem *item3 = [[CCBarItem alloc] initWithTitle:@"vc3" image:[UIImage imageNamed:@"mail"]];
    UITabBarItem *barItem3 = [[UITabBarItem alloc] initWithTitle:@"vc3" image:[UIImage imageNamed:@"mail"] selectedImage:nil];
    vc3.view.backgroundColor = [UIColor yellowColor];
    vc3.barItem = item3;
    vc3.tabBarItem = barItem3;
    
    CCContainerManagerController *containerManagerController;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        containerManagerController = [[CCContainerManagerController alloc] init];
    }
    else {
        containerManagerController = [[CCContainerManagerController alloc] initWithTraitCollection:self.traitCollection];
    }
    [containerManagerController setSelectedLineColor:[UIColor blueColor]];
    [containerManagerController setViewControllers:[[NSArray alloc] initWithObjects:vc1, vc2, vc3, nil]];
    [containerManagerController setSelectedIndex:0];
    
    [self presentViewController:containerManagerController animated:YES completion:nil];
}

- (IBAction)openModal:(id)sender
{
    UIViewController *ctrl = [[UIViewController alloc] init];
    ctrl.view.backgroundColor = [UIColor blueColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    
    ctrl.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    
    
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
