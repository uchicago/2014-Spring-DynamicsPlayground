//
//  AlertView.h
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

@import UIKit;

@interface AlertView : UIView <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) UIView *superviewReference;

- (id)initWithView:(UIView*)superview;

@end
