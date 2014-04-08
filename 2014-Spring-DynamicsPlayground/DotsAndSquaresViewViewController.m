//
//  DotsAndSquaresViewViewController.m
//  2014-Spring-DynamicsPlayground
//
//  Created by T. Andrew Binkowski on 4/7/14.
//  Copyright (c) 2014 T. Andrew Binkowski. All rights reserved.
//

@import AudioToolbox;
#import "DotsAndSquaresViewViewController.h"

#define kHomeView CGRectMake(100,100,100,100)

@interface DotsAndSquaresViewViewController ()
@property (strong,nonatomic) NSMutableArray *items;
@end

@implementation DotsAndSquaresViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the tap to add a new ball
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapHandler:)];
    [self.view addGestureRecognizer:addTap];
    
    // Add a label so we know when the animator is
    _animatorState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.animatorState.text = @"UIAnimator";
    [self.view addSubview:self.animatorState];
    
    // Create the animator
    UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    animator.delegate = self;
    
    // Gray Square
    UIView *home = [[UIView alloc] initWithFrame:kHomeView];
    home.tag = 500;
    home.backgroundColor = [UIColor grayColor];
    [self.view addSubview:home];
    
    //
    //
    _items = [NSMutableArray array];
    [self.items addObject:home];
    
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.items];
    
    
    //
    _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionDelegate = self;
    
    //
    _propertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.propertiesBehavior.elasticity = 0.5;
    
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:nil mode:UIPushBehaviorModeInstantaneous];
    
    //
    [animator addBehavior:_propertiesBehavior];
    [animator addBehavior:_gravityBehavior];
    [animator addBehavior:_collisionBehavior];
    [animator addBehavior:_pushBehavior];
    
    self.animator = animator;
}

- (void)viewDidAppear:(BOOL)animated
{
    UILabel *label;
    for (int i=0;i<4;i++) {
        [self newBallAtPoint:CGPointMake(i*20, i*30) size:1 tag:i];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(i*10, i*10, 50, 50)];
        label.text = [NSString stringWithFormat:@"Hello %d",i];
        label.font = [UIFont systemFontOfSize:20];
        label.userInteractionEnabled = YES;
        [label sizeToFit];
        [self.view addSubview:label];
        [self.items addObject:label];
        [self addGestureToView:label];
        [self.gravityBehavior addItem:label];
        [self.collisionBehavior addItem:label];
        [self.propertiesBehavior addItem:label];
    }
}

- (void)addTapHandler:(UITapGestureRecognizer*)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    [self newBallAtPoint:point size:0.5 tag:999];
}

- (void)incrementCounter {
    self.counter++;
}

- (void)newBallAtPoint:(CGPoint)point size:(float)theSize tag:(int)tag
{
    int size = 50*theSize;
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(point.x,point.y, size, size)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = circle.bounds.size.width / 2.;
    circle.backgroundColor = [UIColor redColor];
    [self.view addSubview:circle];
    
    // Add the funs stuff
    [self addGestureToView:circle];
    [self.gravityBehavior addItem:circle];
    [self.collisionBehavior addItem:circle];
    [self.propertiesBehavior addItem:circle];
    [self sound];
    
}

- (void)addGestureToView:(UIView*)view
{
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:pan];
    [view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  NO;
}

/*! When we tap it freeze it
 */
- (IBAction)handleTap:(UITapGestureRecognizer*)gesture
{
    // Remove all the properties from the current dot (freeze it)
    [self.gravityBehavior removeItem:gesture.view];
    [self.collisionBehavior removeItem:gesture.view];
    //[self.propertiesBehavior removeItem:gesture.view];
    [self.pushBehavior removeItem:gesture.view];
    
    // Remove Pan
    for (UIGestureRecognizer *g in gesture.view.gestureRecognizers) {
        if ([g isKindOfClass:[UIPanGestureRecognizer class]]) {
            [gesture.view removeGestureRecognizer:g];
        }
    }
    
    // Add a new boundary from its position
    gesture.view.backgroundColor = [UIColor blueColor];
    UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:gesture.view.frame];
    [self.collisionBehavior addBoundaryWithIdentifier:[NSString stringWithFormat:@"%d",gesture.view.tag] forPath:p];
}

/*! Remove all the view items from the push behaviors.  This essentially clears
 *  the push to only act on a single object
 */
- (void)removeAllPushBehaviors
{
    for (UIView *v in self.pushBehavior.items) {
        [self.pushBehavior removeItem:v];
    }
}


-(IBAction)handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    //[self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
    //self.redSquare.center = self.attachmentBehavior.anchorPoint;
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:piece attachedToAnchor:[gestureRecognizer locationInView:self.view]];
        //self.attachmentBehavior =  attachmentBehavior;
        //[self.attachmentBehavior setAnchorPoint:[gestureRecognizer locationInView:self.view]];
        //piece.center = self.attachmentBehavior.anchorPoint;
        
        [self.gravityBehavior removeItem:gestureRecognizer.view];
        [self.collisionBehavior removeItem:gestureRecognizer.view];
        [self.propertiesBehavior removeItem:gestureRecognizer.view];
        [self removeAllPushBehaviors];
        
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        //[self.attachmentBehavior setAnchorPoint:[gestureRecognizer locationInView:self.view]];
        //piece.center = self.attachmentBehavior.anchorPoint;
        
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gestureRecognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y))/100;
        //[self.pushBehavior setXComponent:velocity.x yComponent:velocity.y];
        [self.pushBehavior setMagnitude:magnitude];
        [self.pushBehavior addItem:gestureRecognizer.view];
        
        [self.gravityBehavior addItem:gestureRecognizer.view];
        [self.collisionBehavior addItem:gestureRecognizer.view];
        [self.propertiesBehavior addItem:gestureRecognizer.view];
        
        [self.pushBehavior setActive:TRUE];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1
                 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    UIView *i1 = (UIView*)item1;
    UIView *i2 = (UIView*)item2;
    //NSLog(@"Begin item1:%d item2:%d",i1.tag,i2.tag);
    
    if (i1.tag == 500 || i2.tag == 500) {
        i1.backgroundColor = [UIColor yellowColor];
        
    }
    
    [self sound];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    UIView *i1 = (UIView*)item1;
    UIView *i2 = (UIView*)item2;
    NSLog(@"\tEnd item1:%d item2:%d",i1.tag,i2.tag);
}

//------------------------------------------------------------------------------
#pragma mark - Dyanimic Protocol
//------------------------------------------------------------------------------
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"Pause");
    self.animatorState.textColor = [UIColor blackColor];
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    self.animatorState.textColor = [UIColor greenColor];
}


//------------------------------------------------------------------------------
#pragma mark - Sound Effects
//------------------------------------------------------------------------------
- (void)sound
{
    NSString *squishPath = [[NSBundle mainBundle]pathForResource:@"Tink" ofType:@"aiff"];
    NSURL *squishURL = [NSURL fileURLWithPath:squishPath];
    SystemSoundID squishSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)squishURL, &squishSoundID);
    AudioServicesAddSystemSoundCompletion (squishSoundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc,(__bridge void *)(self));
    AudioServicesPlaySystemSound(squishSoundID);
}

void MyAudioServicesSystemSoundCompletionProc(SystemSoundID ssID,  void *clientData)
{
    NSLog(@"%s :: Release Sound", __PRETTY_FUNCTION__);
    AudioServicesDisposeSystemSoundID(ssID);
}



@end
