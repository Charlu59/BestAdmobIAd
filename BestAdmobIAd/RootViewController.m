//
//  RootViewController.m
//  BestAdmobIAd
//
//  Created by Charles-Hubert Basuiau on 18/11/2013.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import "RootViewController.h"
#import "Slot.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Slot *adSlot = [[Slot alloc] init];
    [self.view addSubview:adSlot.view];
    [self addChildViewController:adSlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
