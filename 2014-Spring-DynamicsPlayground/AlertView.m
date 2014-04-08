//
//  AlertView.m
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

#import "AlertView.h"
#import "CombinedBehaviors.h"

@implementation AlertView


- (id)initWithView:(UIView*)superview
{
    self = [super init];
    if (self) {
        // Initialization code
        NSLog(@"programmatically");
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:superview];
        NSLog(@"animator:%@",superview);
        
        self.animator.delegate = self;
        self.superviewReference = superview;
        [self _initWithTitle:@"Title" message:@"Message"];
    }
    return self;
}

- (void)_initWithTitle:(NSString*)title message:(NSString*)message
{
    NSLog(@"Common init");
    self.frame = CGRectMake(0, 0, 100, 100);
    CGPoint middle = [UIApplication sharedApplication].keyWindow.center;
    self.backgroundColor = [UIColor lightGrayColor];
    [self.superviewReference addSubview:self];
    
    // Combined Behaviors
    CombinedBehaviors *combinedBehaviors = [[CombinedBehaviors alloc] initWithItems:@[self]];
    [self.animator addBehavior:combinedBehaviors];
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self
                                                             snapToPoint:middle];
    snapBehaviour.damping = 0.65f;
    
    [self.animator addBehavior:snapBehaviour];
    
    // Hide it after 2 seconds
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self]];
        gravityBehavior.gravityDirection = CGVectorMake(0.0f, 10.0f);
        gravityBehavior.action = ^{
            NSLog(@"%@, %@",
              NSStringFromCGAffineTransform(self.transform),
              NSStringFromCGPoint(self.center));
            if (self.center.y > 500) {
                [self.animator removeAllBehaviors];
            }
        };
        [self.animator addBehavior:gravityBehavior];

        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
        [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self];
        [self.animator addBehavior:itemBehaviour];
    });
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    NSLog(@"Starting animator for:%@",animator.behaviors);
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    NSLog(@"Stopping animator:%@",animator.behaviors);
    if ([animator.behaviors.firstObject isKindOfClass:[UISnapBehavior class]]) {
        [self.animator removeAllBehaviors];
    }

    if ([animator.behaviors.firstObject isKindOfClass:[UIGravityBehavior class]]) {
        [self removeFromSuperview];
        NSLog(@"Removing alertview after fall");
    }

}
@end
