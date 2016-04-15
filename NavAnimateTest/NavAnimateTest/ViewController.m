//
//  ViewController.m
//  NavAnimateTest
//
//  Created by XiangKai Yin on 4/14/16.
//  Copyright © 2016 K. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;

@property (strong, nonatomic) IBOutlet UIView *topView;//导航所在的view

@property (weak, nonatomic) IBOutlet UILabel *beforeLabel;//要隐藏的label

@property (weak, nonatomic) IBOutlet UILabel *showLabel;//要展示的label


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //iOS7之后由于navigationBar.translucent默认是YES，坐标零点默认在（0，0）点  当不透明的时候，零点坐标在（0，64）；如果你想设置成透明的，而且还要零点从（0，64）开始，那就添加：self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.navigationBar.translucent = NO;
  
  [self.navigationController.navigationBar setShadowImage:[UIImage new]];
  
  //添加到导航上
  CGRect rect = _topView.frame;
  rect.size.width = self.view.frame.size.width;
  _topView.frame = rect;
  _topView.clipsToBounds = YES;//加上这句裁剪
  
  [self.navigationController.view addSubview:_topView];
  
}

#pragma mark - 
#pragma mark - UITableViewDelegate,UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGPoint offset = scrollView.contentOffset;
  
  //计算坐标
  if (offset.y >= 0) {
    //根据比例计算放大缩小的倍数
    CGFloat scale = MIN(1,(offset.y / 64));
    
    self.beforeLabel.transform = CGAffineTransformMakeScale(1-scale, 1-scale);
    //修改showlabel的y坐标
    CGRect rect = self.showLabel.frame;
    //beforeLabel的y坐标是35 ，最小不能小于35，(64+14) 这个参数来保持缩放动画和移动动画的衔接 (少了会太近)
    rect.origin.y = MAX(35, 64+14 - offset.y);
    self.showLabel.frame = rect;
  } else {
    //超出 还原
    self.beforeLabel.transform = CGAffineTransformIdentity;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
  return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"mineidentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
}

@end
