//
//  ExampleTableViewController.m
//  
//
//  Created by Hirat on 14-9-11.
//
//

#import "ExampleTableViewController.h"
#import "UIViewController+HRTPopViewController.h"

@interface ExampleTableViewController () <HRTPopViewControllerDelegate>

@end

@implementation ExampleTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return HRTPopViewAnimationNone - HRTPopViewAnimationDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ExampleTableViewCell" forIndexPath:indexPath];

    cell.textLabel.text = [self titleOfPopViewAnimation: indexPath.row];
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(tableView.frame.size.width/2 - 80, tableView.frame.size.height/2 - 80, 160, 160)];
    view.tag = indexPath.row;
    view.backgroundColor = [UIColor blueColor];
    self.popViewControllerDelegate = self;
    [self showView: view withAnimation: indexPath.row completion:^{
        
    }];
}

#pragma mark - 自定义函数

- (NSString*)titleOfPopViewAnimation:(HRTPopViewAnimationType)type
{
    NSDictionary* titiles = @{@(HRTPopViewAnimationDefault): @"渐显效果",
                              @(HRTPopViewAnimationPop): @"从屏幕中间弹出",
                              @(HRTPopViewAnimationFromBottom): @"从屏幕底部弹出",
                              @(HRTPopViewAnimationPath): @"仿Path弹出",
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

#pragma mark - HRTPopViewControllerDelegate

- (void)tapPopViewControllerBackground:(UIView*)popView
{
    [self hideViewWithAnimation: popView.tag completion:^{
        
    }];
}


@end
