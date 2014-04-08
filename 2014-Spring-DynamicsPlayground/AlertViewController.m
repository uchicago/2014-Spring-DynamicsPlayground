//
//  AlertViewController.m
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

#import "AlertViewController.h"
#import "AlertView.h"

@interface AlertViewController ()
@end

@implementation AlertViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapShowAlert:(id)sender
{
    NSLog(@"Tap alertview");
    _alertView = [[AlertView alloc] initWithView:self.view];
    
   /* UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];

    [keyWindow addSubview:self.alertView];
*/
}
@end
