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
static const NSTimeInterval kAnimationTimeInterval = 0.3;

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

    [self removeObserVerForScrollView];
    
    [self scrollSliderWithHorizontalMargin:0 sliderWidth:kNotificationButtonWidth timeInterval:kAnimationTimeInterval];
    [self scrollScrollViewWithContentOffSet:CGPointMake(0, 0) timeInterval:kAnimationTimeInterval];
    
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self addObserVerForScrollView];
    }];
}

- (IBAction)praiseAndThanksButtonHandler:(id)sender {
    [self removeObserVerForScrollView];
    
    [self scrollSliderWithHorizontalMargin:kButtonHorizontalMargin sliderWidth:kPraiseAndThanksButtonWidth timeInterval:kAnimationTimeInterval];
    [self scrollScrollViewWithContentOffSet:CGPointMake(self.view.bounds.size.width, 0) timeInterval:kAnimationTimeInterval];
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self addObserVerForScrollView];
    }];
}

- (IBAction)privateLetterButtonHandler:(id)sender {
    [self removeObserVerForScrollView];
    
    [self scrollSliderWithHorizontalMargin:kButtonHorizontalMargin * 2 sliderWidth:kPrivateLetterButtonWidth timeInterval:kAnimationTimeInterval];
    [self scrollScrollViewWithContentOffSet:CGPointMake(self.view.bounds.size.width * 2, 0) timeInterval:kAnimationTimeInterval];
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self addObserVerForScrollView];
    }];
}

- (void)scrollScrollViewWithContentOffSet:(CGPoint)contentOffSet timeInterval:(NSTimeInterval)timeInterval {
    [UIView animateWithDuration:timeInterval animations:^{
        [self.scrollView setContentOffset:contentOffSet];
    }];
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
        [self scrollSliderWithHorizontalMargin:[self sliderViewCenterXConstraintConstantWithScrollViewContentOffSet:contentOffset] sliderWidth:[self sliderWidthWithScrollViewContentOffSet:contentOffset] timeInterval:0.01];
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

- (void)scrollSliderWithHorizontalMargin:(CGFloat)horizontalMargin sliderWidth:(CGFloat)sliderWidth timeInterval:(NSTimeInterval)timeInterval {
    [UIView animateWithDuration:timeInterval animations:^{
        self.sliderViewCenterXConstraint.constant = horizontalMargin;
        self.sliderViewWidthConstraint.constant = sliderWidth;
    }];
}

@end
