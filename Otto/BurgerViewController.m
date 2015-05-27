//
//  BurgerViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "BurgerViewController.h"
#import "MenuTableViewController.h"
#import "StartStopViewController.h"
#import "ViewController.h"

@interface BurgerViewController () <MenuPressedDelegate>

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapItClose;
@property (strong, nonatomic) UIPanGestureRecognizer *slideAway;

@property (strong, nonatomic) UINavigationController *searchVC;
@property (nonatomic) NSInteger selectedRow;
@property (strong,nonatomic) MenuTableViewController *menuVC;
@property (strong,nonatomic) StartStopViewController *startVC;
@property (strong,nonatomic) ViewController *mainVC;


@end

@implementation BurgerViewController

NSInteger const slideRightBuffer = 300;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (!_searchVC) {
    _searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
  }
  
  [self addChildViewController:self.searchVC];
  self.searchVC.view.frame = self.view.frame;
  [self.view addSubview:self.searchVC.view];
  [self.searchVC didMoveToParentViewController:self];
  self.topViewController = self.searchVC;
  self.selectedRow = -1;
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 60, 45)];
  [button setBackgroundImage:[UIImage imageNamed:@"burgermenu.png"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.searchVC.view addSubview:button];
  
  self.burgerButton = button;
  
  self.tapItClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
  
  self.slideAway = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
  [self.topViewController.view addGestureRecognizer:self.slideAway];


}


- (void)burgerButtonPressed {
  __weak BurgerViewController *weakSelf = self;
  
  [UIView animateWithDuration:.3 animations:^{
    weakSelf.topViewController.view.center = CGPointMake(weakSelf.topViewController.view.center.x + 300, weakSelf.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapItClose];
  }
   ];
  weakSelf.burgerButton.userInteractionEnabled = false;
  
}


#pragma mark - Gesture Recognizers
- (void)closePanel {
  //disable tapping it close
  [self.topViewController.view removeGestureRecognizer:self.tapItClose];
  
  __weak BurgerViewController *weakSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    weakSelf.topViewController.view.center = weakSelf.view.center;
  } completion:^(BOOL finished) {
    weakSelf.burgerButton.userInteractionEnabled = true;
  }];
  
}

- (void)slidePanel:(id)sender {
  UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
  CGPoint translatedPoint = [pan translationInView:self.view];
  CGPoint velocity = [pan velocityInView:self.view];
  
  if ([pan state] == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0 || self.topViewController.view.frame.origin.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
      [pan setTranslation:CGPointZero inView:self.view];
    }
  }
  
  if ([pan state] == UIGestureRecognizerStateEnded) {
    __weak BurgerViewController *weakSelf = self;
    
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
      self.burgerButton.userInteractionEnabled = false;
      [UIView animateWithDuration:0.6 animations:^{
        self.topViewController.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.1, weakSelf.topViewController.view.center.y);
        
      } completion:^(BOOL finished) {
        [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapItClose];
      }];
    }
    else {
      [UIView animateWithDuration:0.2 animations:^{
        weakSelf.topViewController.view.center = weakSelf.view.center;
      }];
      [self.topViewController.view removeGestureRecognizer:self.tapItClose];
    }
  }
  
}


-(StartStopViewController *)startVC {
  if (!_startVC) {
    _startVC = [self.storyboard instantiateViewControllerWithIdentifier:@"START_VC"];
  }
  return _startVC;
}

-(ViewController *)mainVC {
  if (!_mainVC) {
    _mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
  }
  return _mainVC;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
  if ([segue.identifier isEqualToString:@"EMBED_MENU"]) {
    MenuTableViewController *destinationVC = segue.destinationViewController;
    destinationVC.delegate = self;
    self.menuVC = destinationVC;
    
  }
}

-(void)switchToViewController:(UIViewController *)destinationVC {
  
  __weak BurgerViewController *weakSelf = self;
  [UIView animateWithDuration:0.2 animations:^{
    
    weakSelf.topViewController.view.frame = CGRectMake(weakSelf.view.frame.size.width, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
  } completion:^(BOOL finished) {
    
    destinationVC.view.frame = self.topViewController.view.frame;
    
    [self.topViewController.view removeGestureRecognizer:self.slideAway];
    [self.burgerButton removeFromSuperview];
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    self.topViewController = destinationVC;
    
    [self addChildViewController:self.topViewController];
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    [self.topViewController.view addSubview:self.burgerButton];
    [self.topViewController.view addGestureRecognizer:self.slideAway];
    
    [self closePanel];
  } ];
  
}


-(void)menuOptionSelected:(NSInteger)selectedRow {
  NSLog(@"%ld",(long)selectedRow);
  if (self.selectedRow == selectedRow) {
    [self closePanel];
  } else {
    self.selectedRow = selectedRow;
    UIViewController *destinationVC;
    switch (selectedRow) {
      case 0:
        destinationVC = self.mainVC;
        break;
      case 1:
        destinationVC = self.startVC;
        break;
      case 2:
        //destinationVC = self.profileVC;
        break;
      default:
        break;
    }
    [self switchToViewController:destinationVC];
  }
}



@end
