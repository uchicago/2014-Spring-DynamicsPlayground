//
//  CombinedBehaviors.m
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

#import "CombinedBehaviors.h"

@implementation CombinedBehaviors

-(instancetype)initWithItems:(NSArray *)items
{
    if (!(self = [super init])) return nil;
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
    [self addChildBehavior:gravityBehavior];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self addChildBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    elasticityBehavior.elasticity = 0.7f;
    [self addChildBehavior:elasticityBehavior];
    
    return self;
}

@end
