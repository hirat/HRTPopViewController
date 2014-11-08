//
//  UIViewController+HRTPopViewController.m
//  HRTPopViewController
//
//  Created by Hirat on 14-8-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

#import "UIViewController+HRTPopViewController.h"
#import <objc/runtime.h>
#import "POP.h"

#define kHRTPopViews @"kHRTPopViews"

#define kHRTCurrentPopView @"kHRTCurrentPopView"
#define kHRTPopBackgroundView @"kHRTPopBackgroundView"

#define kHRTPopShowCompletionBlock @"kHRTPopShowCompletionBlock"
#define kHRTPopHideCompletionBlock @"kHRTPopHideCompletionBlock"

#define kHRTPopShowAnimationType @"kHRTPopShowAnimationType"
#define kHRTPopHideAnimationType @"kHRTPopHideAnimationType"

#define kHRTEnableHideOnTapBackground @"kHRTEnableHideOnTapBackground"
#define kHRTPopViewControllerDelegate @"kHRTPopViewControllerDelegate"

@interface UIViewController (HRTPopViewControllerInternal)
-(UIView*)hrt_parentTarget;
@end

@implementation UIViewController (HRTPopViewControllerInternal)

-(UIViewController*)hrt_parentTargetViewController
{
	UIViewController * target = self;
    while (target.parentViewController != nil)
    {
        target = target.parentViewController;
    }	return target;
}

-(UIView*)hrt_parentTarget
{
    return [self hrt_parentTargetViewController].view;
}
@end

@interface UIViewController ()
@property (nonatomic, strong) NSMutableArray* hrtPopViews;
@property (nonatomic, strong) UIView* hrtCurrentPopView;
@property (nonatomic, strong) UIView* hrtPopBackgroudView;
@property (nonatomic, strong) HRTAnimationCompletionBlock showCompletionBlock;
@property (nonatomic, strong) HRTAnimationCompletionBlock hideCompletionBlock;
@property (nonatomic) HRTPopViewAnimationType showAnimationType;
@property (nonatomic) HRTPopViewAnimationType hideAnimationType;
@end

@implementation UIViewController (HRTPopViewController)

#pragma mark - 变量 set/get

- (id<HRTPopViewControllerDelegate>)popViewControllerDelegate
{
    return objc_getAssociatedObject(self, kHRTPopViewControllerDelegate);
}

- (void)setPopViewControllerDelegate:(id<HRTPopViewControllerDelegate>)popViewControllerDelegate
{
    objc_setAssociatedObject(self, kHRTPopViewControllerDelegate, popViewControllerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enableHideOnTapBackground
{
    id enable = objc_getAssociatedObject(self, kHRTEnableHideOnTapBackground);
    return [enable boolValue];
}

- (void)setEnableHideOnTapBackground:(BOOL)enableHideOnTapBackground
{
    objc_setAssociatedObject(self, kHRTEnableHideOnTapBackground, @(enableHideOnTapBackground), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray*)hrtPopViews
{
    return objc_getAssociatedObject(self, kHRTPopViews);
}

- (void)setHrtPopViews:(NSMutableArray *)hrtPopViews
{
    objc_setAssociatedObject(self, kHRTPopViews, hrtPopViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)hrtCurrentPopView
{
    return objc_getAssociatedObject(self, kHRTCurrentPopView);
}

- (void)setHrtCurrentPopView:(UIView *)hrtCurrentPopView
{
    objc_setAssociatedObject(self, kHRTCurrentPopView, hrtCurrentPopView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)hrtPopBackgroudView
{
    return objc_getAssociatedObject(self, kHRTPopBackgroundView);
}

- (void)setHrtPopBackgroudView:(UIView *)hrtPopBackgroudView
{
    objc_setAssociatedObject(self, kHRTPopBackgroundView, hrtPopBackgroudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setShowCompletionBlock:(HRTAnimationCompletionBlock)showCompletionBlock
{
    objc_setAssociatedObject(self, kHRTPopShowCompletionBlock, showCompletionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HRTAnimationCompletionBlock)showCompletionBlock
{
    return objc_getAssociatedObject(self, kHRTPopShowCompletionBlock);
}

- (void)setHideCompletionBlock:(HRTAnimationCompletionBlock)hideCompletionBlock
{
    objc_setAssociatedObject(self, kHRTPopHideCompletionBlock, hideCompletionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HRTAnimationCompletionBlock)hideCompletionBlock
{
    return objc_getAssociatedObject(self, kHRTPopHideCompletionBlock);
}

- (void)setShowAnimationType:(HRTPopViewAnimationType)showAnimationType
{
    objc_setAssociatedObject(self, kHRTPopShowAnimationType, @(showAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HRTPopViewAnimationType)showAnimationType
{
    id type = objc_getAssociatedObject(self, kHRTPopShowAnimationType);
    return [type integerValue];
}

- (void)setHideAnimationType:(HRTPopViewAnimationType)hideAnimationType
{
    objc_setAssociatedObject(self, kHRTPopHideAnimationType, @(hideAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HRTPopViewAnimationType)hideAnimationType
{
    id type = objc_getAssociatedObject(self, kHRTPopHideAnimationType);
    return [type integerValue];
}

#pragma mark - 公用函数

- (void)showView:(UIView *)popView
   withAnimation:(HRTPopViewAnimationType)animationType
      completion:(HRTAnimationCompletionBlock)completion
{
    if(!self.hrtPopViews)
    {
        self.hrtPopViews = [NSMutableArray array];
    }
    
    if(![self.hrtPopViews containsObject: popView])
    {
        [self.hrtPopViews addObject: popView];
    }
    
    self.hrtCurrentPopView = [self.hrtPopViews lastObject];
    self.showCompletionBlock = completion;
    self.showAnimationType = animationType;
    
	UIView* target = [self hrt_parentTarget];
    if(![target.subviews containsObject: popView])
    {
        if(!(self.hrtPopBackgroudView && [target.subviews containsObject: self.hrtPopBackgroudView]))
        {
            UIView* backgroudView = [[UIView alloc] initWithFrame: target.bounds];
            backgroudView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.45];
            backgroudView.alpha = 0;
            self.hrtPopBackgroudView = backgroudView;
            [target addSubview: self.hrtPopBackgroudView];
            
            UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(hrtPanView:)];
            [self.hrtPopBackgroudView addGestureRecognizer: pan];
            
            UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
            dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            dismissButton.backgroundColor = [UIColor clearColor];
            dismissButton.frame = self.hrtPopBackgroudView.bounds;
            [self.hrtPopBackgroudView addSubview:dismissButton];
            
            [dismissButton addTarget:self action:@selector(hrtDismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [target addSubview: self.hrtCurrentPopView];
        }
        
        [self hrtShowPopViewWithAnimation];
    }
}

- (void)hideViewWithAnimation: (HRTPopViewAnimationType)animationType
                   completion: (HRTAnimationCompletionBlock)completion
{
    self.hideAnimationType = animationType;
    self.hideCompletionBlock = completion;
    
	UIView * target = [self hrt_parentTarget];
    self.hrtCurrentPopView = [self.hrtPopViews lastObject];
    if([target.subviews containsObject: self.hrtCurrentPopView])
    {
        [self hrtHidePopViewWithAnimation];
    }
}

- (NSString*)titleOfAnimation:(HRTPopViewAnimationType)type
{
    NSDictionary* titiles = @{@(HRTPopViewAnimationDefault): @"渐显效果",
                              @(HRTPopViewAnimationPop): @"从屏幕中间弹出",
                              @(HRTPopViewAnimationPath): @"仿 Path 通知",
                              @(HRTPopViewAnimationFromBottom): @"从底部弹出",
                              @(HRTPopViewAnimationNone): @"未定义",};
    if([titiles.allKeys containsObject: @(type)])
    {
        return titiles[@(type)];
    }
    else
    {
        return @"不明飞行物";
    }
}

#pragma mark - 私有函数

- (void)hrtShowPopViewWithAnimation
{
	UIView * target = [self hrt_parentTarget];
    
    switch (self.showAnimationType)
    {
        case HRTPopViewAnimationPop:
        {
            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(0);
            alphaForAlertAnimation.toValue = @(1);
            [self.hrtPopBackgroudView pop_addAnimation: alphaForAlertAnimation forKey: @"showAlpha"];
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8, 0.8)];
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
            scaleAnimation.springBounciness = 15;
            scaleAnimation.springSpeed = 15;
            scaleAnimation.name = @"show";
            scaleAnimation.delegate = self;
            [self.hrtCurrentPopView pop_addAnimation:scaleAnimation forKey:@"show"];
        }
            break;
            
        case HRTPopViewAnimationFade:
        {
            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(0);
            alphaForAlertAnimation.toValue = @(1);
            alphaForAlertAnimation.delegate = self;
            alphaForAlertAnimation.name = @"showAlpha";
            [self.hrtCurrentPopView pop_addAnimation: alphaForAlertAnimation forKey: @"showAlpha"];
            
            POPBasicAnimation* alphaForBackgroundAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForBackgroundAnimation.fromValue = @(0);
            alphaForBackgroundAnimation.toValue = @(1);
            alphaForBackgroundAnimation.delegate = self;
            alphaForBackgroundAnimation.name = @"show";
            [self.hrtPopBackgroudView pop_addAnimation: alphaForBackgroundAnimation forKey:@"show"];
        }
            break;
            
        case HRTPopViewAnimationPath:
        {
            self.hrtCurrentPopView.center = CGPointMake(target.center.x, -self.hrtCurrentPopView.frame.size.height);

            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(0);
            alphaForAlertAnimation.toValue = @(1);
            [self.hrtPopBackgroudView pop_addAnimation: alphaForAlertAnimation forKey: @"showAlpha"];
            
            POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationAnim.beginTime = CACurrentMediaTime();
            rotationAnim.fromValue = @(-M_PI_4/12);
            rotationAnim.toValue = @(0);
            [self.hrtCurrentPopView.layer pop_addAnimation: rotationAnim forKey: @"rotation"];

            POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPosition];
            positionAnimation.toValue = [NSValue valueWithCGPoint: CGPointMake(target.center.x, target.center.y - target.frame.size.height / 4)];
            positionAnimation.duration = 0.15;
            [self.hrtCurrentPopView.layer pop_addAnimation:positionAnimation forKey: @"show1"];
            
            POPSpringAnimation *springPositionAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPosition];
            springPositionAnimation.toValue = [NSValue valueWithCGPoint: target.center];
            springPositionAnimation.springSpeed = 20;
            springPositionAnimation.dynamicsTension = 10;
            springPositionAnimation.dynamicsFriction = 20.0f;
            springPositionAnimation.springBounciness = 10.0f;
            springPositionAnimation.beginTime = CACurrentMediaTime() + 0.10;
            [self.hrtCurrentPopView.layer pop_addAnimation:springPositionAnimation forKey: @"show"];
        }
            break;
            
        case HRTPopViewAnimationFromBottom:
        {
            self.hrtCurrentPopView.center = CGPointMake(target.center.x, self.view.frame.size.height + self.hrtCurrentPopView.frame.size.height);
            
            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(0);
            alphaForAlertAnimation.toValue = @(1);
            [self.hrtPopBackgroudView pop_addAnimation: alphaForAlertAnimation forKey: @"showAlpha"];
            
            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPosition];
            CGPoint center = CGPointMake(target.center.x, target.frame.size.height - self.hrtCurrentPopView.frame.size.height/2);
            positionAnimation.toValue = [NSValue valueWithCGPoint: center];
            positionAnimation.dynamicsFriction = 20.0f;
            positionAnimation.springBounciness = 0.0f;
            [self.hrtCurrentPopView.layer pop_addAnimation:positionAnimation forKey: @"show"];
        }
            break;
            
        default:
            break;
    }
}

- (void)hrtHidePopViewWithAnimation
{
    switch (self.hideAnimationType)
    {
        case HRTPopViewAnimationPop:
        case HRTPopViewAnimationFade:
        {
            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(1);
            alphaForAlertAnimation.toValue = @(0);
            alphaForAlertAnimation.delegate = self;
            alphaForAlertAnimation.name = @"hide";
            [self.hrtCurrentPopView pop_addAnimation: alphaForAlertAnimation forKey: @"hide"];
            
            if(self.hrtPopViews.count < 2)
            {
                POPBasicAnimation* alphaForBackgroundAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
                alphaForBackgroundAnimation.fromValue = @(1);
                alphaForBackgroundAnimation.toValue = @(0);
                alphaForBackgroundAnimation.delegate = self;
                alphaForBackgroundAnimation.name = @"hideAll";
                [self.hrtPopBackgroudView pop_addAnimation: alphaForBackgroundAnimation forKey:@"hideAll"];
            }
        }
            
        case HRTPopViewAnimationPath:
        {
            UIView* target = [self hrt_parentTarget];
            
            POPBasicAnimation* alphaForAlertAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
            alphaForAlertAnimation.fromValue = @(1);
            alphaForAlertAnimation.toValue = @(0);
            alphaForAlertAnimation.delegate = self;
            alphaForAlertAnimation.name = @"hide";
            [self.hrtCurrentPopView pop_addAnimation: alphaForAlertAnimation forKey: @"hide"];
            
            POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationAnim.beginTime = CACurrentMediaTime();
            rotationAnim.fromValue = (0);
            rotationAnim.toValue = @(M_PI_4/4);
            rotationAnim.duration = 1.5;
            [self.hrtCurrentPopView.layer pop_addAnimation: rotationAnim forKey: @"rotation"];
            
            POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPosition];
            positionAnimation.toValue = [NSValue valueWithCGPoint: CGPointMake(target.center.x, target.frame.size.height + self.hrtCurrentPopView.frame.size.height/2)];
            [self.hrtCurrentPopView.layer pop_addAnimation:positionAnimation forKey: @"position"];
            
            if(self.hrtPopViews.count < 2)
            {
                POPBasicAnimation* alphaForBackgroundAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
                alphaForBackgroundAnimation.fromValue = @(1);
                alphaForBackgroundAnimation.toValue = @(0);
                alphaForBackgroundAnimation.delegate = self;
                alphaForBackgroundAnimation.name = @"hideAll";
                [self.hrtPopBackgroudView pop_addAnimation: alphaForBackgroundAnimation forKey:@"hideAll"];
            }
        }
            break;
            
        case HRTPopViewAnimationFromBottom:
        {
            UIView* target = [self hrt_parentTarget];
            
            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPosition];
            positionAnimation.toValue = [NSValue valueWithCGPoint: CGPointMake(target.center.x, target.frame.size.height + self.hrtCurrentPopView.frame.size.height/2)];
            positionAnimation.dynamicsFriction = 20.0f;
            positionAnimation.springBounciness = 0.0f;
            positionAnimation.delegate = self;
            positionAnimation.name = @"hide";
            [self.hrtCurrentPopView.layer pop_addAnimation:positionAnimation forKey: @"hide"];
            
            if(self.hrtPopViews.count < 2)
            {
                POPBasicAnimation* alphaForBackgroundAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPViewAlpha];
                alphaForBackgroundAnimation.fromValue = @(1);
                alphaForBackgroundAnimation.toValue = @(0);
                alphaForBackgroundAnimation.delegate = self;
                alphaForBackgroundAnimation.name = @"hideAll";
                [self.hrtPopBackgroudView pop_addAnimation: alphaForBackgroundAnimation forKey:@"hideAll"];
            }
        }
            
            
        default:
            break;
    }
}


#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if ([anim.name isEqualToString: @"show"])
    {
        if(self.showCompletionBlock)
        {
            self.showCompletionBlock();
        }
    }
    
    if ([anim.name isEqualToString: @"hide"])
    {
        if(self.hrtPopViews.count < 2)
        {
            [self.hrtPopBackgroudView pop_removeAllAnimations];
            [self.hrtPopBackgroudView removeFromSuperview];
        }
        
        POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnim.beginTime = CACurrentMediaTime();
        rotationAnim.toValue = @(0);
        [self.hrtCurrentPopView.layer pop_addAnimation: rotationAnim forKey: @"rotation"];

        [self.hrtCurrentPopView removeFromSuperview];
        self.hrtCurrentPopView.alpha = 1;
        [self.hrtCurrentPopView pop_removeAllAnimations];
        
        if([self.hrtPopViews containsObject: self.hrtCurrentPopView])
        {
            [self.hrtPopViews removeObject: self.hrtCurrentPopView];
        }

        if(self.hideCompletionBlock)
        {
            self.hideCompletionBlock();
        }
    }
}

#pragma mark - 按键/拖拽

- (IBAction)hrtDismissButtonPressed:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing: YES];    
    
//    if(self.enableHideOnTapBackground)
//    {
//        [self hideViewWithAnimation: self.hideAnimationType completion:^{
//            
//        }];
//    }
    
    if(self.popViewControllerDelegate)
    {
        [self.popViewControllerDelegate tapPopViewControllerBackground: self.hrtCurrentPopView];
    }
}

- (void)hrtPanView:(UIGestureRecognizer*)gestureRecognizer
{
    
}

@end
