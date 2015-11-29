//
//  ViewController.m
//  ZhihuFindPageTest
//
//  Created by shoron on 15/11/29.
//  Copyright © 2015年 com. All rights reserved.
//

#import "ViewController.h"

static const CGFloat kNotificationButtonWidth = 38.0f;
static const CGFloat kPraiseAndThanksButtonWidth = 74.0f;
static const CGFloat kPrivateLetterButtonWidth = 38.0f;
static const CGFloat kButtonHorizontalMargin = 100.0f;
static NSString *kObserverKeyPath = @"contentOffset";
static const NSTimeInterval kAnimationTimeInterval = 0.5;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderViewCenterXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderViewWidthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addObserVerForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handler

- (IBAction)notificationButtonHandler:(id)sender {
    [self scrollSliderWithHorizontalMargin:0 sliderWidth:kNotificationButtonWidth];
}

- (IBAction)praiseAndThanksButtonHandler:(id)sender {
    [self scrollSliderWithHorizontalMargin:kButtonHorizontalMargin sliderWidth:kPraiseAndThanksButtonWidth];
}

- (IBAction)privateLetterButtonHandler:(id)sender {
    [self scrollSliderWithHorizontalMargin:kButtonHorizontalMargin * 2 sliderWidth:kPrivateLetterButtonWidth];
}

#pragma mark - KVO



- (void)addObserVerForScrollView {
    [self.scrollView addObserver:self forKeyPath:kObserverKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserVerForScrollView {
    [self.scrollView removeObserver:self forKeyPath:kObserverKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kObserverKeyPath]) {
        CGPoint contentOffset = [[object valueForKey:keyPath] CGPointValue];
        [self scrollSliderWithHorizontalMargin:[self sliderViewCenterXConstraintConstantWithScrollViewContentOffSet:contentOffset] sliderWidth:[self sliderWidthWithScrollViewContentOffSet:contentOffset]];
    }
}

- (CGFloat)sliderViewCenterXConstraintConstantWithScrollViewContentOffSet:(CGPoint)contentOffSet {
    CGFloat screenWidth = self.view.bounds.size.width;
    if (contentOffSet.x <= 0) {
        return 0;
    } else if (contentOffSet.x >= screenWidth * 2) {
        return kButtonHorizontalMargin * 2;
    } else {
        return kButtonHorizontalMargin * (contentOffSet.x / screenWidth);
    }
}

- (CGFloat)sliderWidthWithScrollViewContentOffSet:(CGPoint)contentOffSet {
    CGFloat screenWidth = self.view.bounds.size.width;
    if (contentOffSet.x <= 0) {
        return kNotificationButtonWidth;
    } else if (contentOffSet.x < screenWidth && contentOffSet.x > 0) {
        return kNotificationButtonWidth + (kPraiseAndThanksButtonWidth - kNotificationButtonWidth) * (contentOffSet.x / screenWidth);
    } else if (contentOffSet.x >= screenWidth && contentOffSet.x < screenWidth * 2) {
        return kPraiseAndThanksButtonWidth - (kPraiseAndThanksButtonWidth - kNotificationButtonWidth) * ((contentOffSet.x - screenWidth)/ screenWidth);
    } else {
        return kPrivateLetterButtonWidth;
    }
}

- (void)scrollSliderWithHorizontalMargin:(CGFloat)horizontalMargin sliderWidth:(CGFloat)sliderWidth {
    NSLog(@"horizontalMargin And Width ===== (%f, %f)",horizontalMargin,sliderWidth);
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.sliderViewCenterXConstraint.constant = horizontalMargin;
        self.sliderViewWidthConstraint.constant = sliderWidth;
    }];
}

@end
