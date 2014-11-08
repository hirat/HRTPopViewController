//
//  UIViewController+HRTPopViewController.h
//  HRTPopViewController
//
//  Created by Hirat on 14-8-15.
//  Copyright (c) 2014年 Hirat. All rights reserved.
//

// 需要加入 pop
// pod 'pop', '~> 1.0.6'

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, HRTPopViewAnimationType) {
    HRTPopViewAnimationDefault,
    HRTPopViewAnimationFade = HRTPopViewAnimationDefault,   //渐显
    HRTPopViewAnimationPop,                                 //从屏幕中间弹出
    HRTPopViewAnimationPath,                                //仿Path效果
    HRTPopViewAnimationFromBottom,                          //从底部弹出
    HRTPopViewAnimationNone                                 //未定义
};

@protocol HRTPopViewControllerDelegate <NSObject>
- (void)tapPopViewControllerBackground:(UIView*)popView;
@end

typedef void (^HRTAnimationCompletionBlock)(void);

@interface UIViewController (HRTPopViewController)

@property (nonatomic) BOOL enableHideOnTapBackground;   //点击空白处消失
@property (nonatomic, weak) id<HRTPopViewControllerDelegate> popViewControllerDelegate;

/*!
 *  以动画方式展示 UIView
 *
 *  @param popView       需要展示的 UIView
 *  @param animationType 动画类型
 *  @param completion    动画完成后的block
 */
- (void)showView: (UIView*)popView
   withAnimation: (HRTPopViewAnimationType)animationType
      completion: (HRTAnimationCompletionBlock)completion;

/*!
 *  隐藏 UIView
 *
 *  @param animationType 动画类型
 *  @param completion    动画完成后的block
 */
- (void)hideViewWithAnimation: (HRTPopViewAnimationType)animationType
                   completion: (HRTAnimationCompletionBlock)completion;

/**
 *  根据动画类型返回动画名称
 *
 *  @param type 动画类型
 *
 *  @return 动画名称
 */
- (NSString*)titleOfAnimation:(HRTPopViewAnimationType)type;

@end
