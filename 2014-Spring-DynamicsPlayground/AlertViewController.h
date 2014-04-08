//
//  AlertViewController.h
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertView;

@interface AlertViewController : UIViewController

@property (nonatomic, strong) IBOutlet AlertView *alertView;


- (IBAction)tapShowAlert:(id)sender;

@end
