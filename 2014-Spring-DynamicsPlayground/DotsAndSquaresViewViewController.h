//
//  DotsAndSquaresViewViewController.h
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotsAndSquaresViewViewController : UIViewController <UIGestureRecognizerDelegate,UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate>

@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) UIGravityBehavior* gravityBehavior;
@property (nonatomic) UICollisionBehavior* collisionBehavior;
@property (nonatomic) UICollisionBehavior* collisionBehaviorBox;
@property (nonatomic) UIDynamicItemBehavior* propertiesBehavior;
@property (nonatomic) UIPushBehavior* pushBehavior;
@property (nonatomic) UIAttachmentBehavior* attachmentBehavior;
@property (nonatomic) UILabel *animatorState;
@property (nonatomic) UITapGestureRecognizer *addTap;
@property int counter;
@property (nonatomic, strong) NSTimer *timer;

@end
