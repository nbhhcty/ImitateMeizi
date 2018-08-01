//
//  CYLTabBar.m
//  CYLTabBarController
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLTabBar.h"
#import "CYLPlusButton.h"
#import "CYLTabBarController.h"


@interface CYLTabBar (){
    void * CYLTabBarContext;
}

/** 发布按钮 */
@property (nonatomic, strong) UIButton<CYLPlusButtonSubclassing> *plusButton;
@property (nonatomic, assign) CGFloat tabBarItemWidth;

@end

@implementation CYLTabBar

#pragma mark -
#pragma mark - LifeCycle Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    CYLTabBarContext = (void*)&CYLTabBarContext;
    // KVO注册监听
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:CYLTabBarContext];
    return self;
}

- (void)layoutSubviews {
    
    if (((CYLTabBarController*)self.delegate).CYLExternPlusButton && !self.plusButton) {
        self.plusButton = ((CYLTabBarController*)self.delegate).CYLExternPlusButton;
        [self addSubview:(UIButton *)self.plusButton];
    }
    [super layoutSubviews];
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth = (barWidth - ((CYLTabBarController*)self.delegate).CYLPlusButtonWidth) / ((CYLTabBarController*)self.delegate).CYLTabbarItemsCount;
    self.tabBarItemWidth = ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth;
    if (!((CYLTabBarController*)self.delegate).CYLExternPlusButton) {
        return;
    }
    CGFloat multiplerInCenterY = [self multiplerInCenterY];
    self.plusButton.center = CGPointMake(barWidth * 0.5, barHeight * multiplerInCenterY);
    NSUInteger plusButtonIndex = [self plusButtonIndex];
    NSArray *sortedSubviews = [self sortedSubviews];
    NSArray *tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    [self setupSwappableImageViewDefaultOffset:tabBarButtonArray[0]];
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= plusButtonIndex) {
            childViewX = buttonIndex * ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth + ((CYLTabBarController*)self.delegate).CYLPlusButtonWidth;
        } else {
            childViewX = buttonIndex * ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth;
        }
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];
    //bring the plus button to top
    [self bringSubviewToFront:self.plusButton];
}

#pragma mark -
#pragma mark - Private Methods

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != CYLTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == CYLTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CYLTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc {
    // KVO反注册
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

- (void)setSwappableImageViewDefaultOffset:(CGFloat)swappableImageViewDefaultOffset {
    if (swappableImageViewDefaultOffset != 0.f) {
        [self willChangeValueForKey:@"swappableImageViewDefaultOffset"];
        _swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
        [self didChangeValueForKey:@"swappableImageViewDefaultOffset"];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

- (CGFloat)multiplerInCenterY {
    CGFloat multiplerInCenterY;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplerInCenterY = [[self.plusButton class] multiplerInCenterY];
    } else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplerInCenterY = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.height * 0.5);
            center.y = center.y - heightDifference * 0.5;
            multiplerInCenterY = center.y / self.bounds.size.height;
        }
    }
    return multiplerInCenterY;
}

- (NSUInteger)plusButtonIndex {
    NSUInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
        //仅修改self.plusButton的x,ywh值不变
        self.plusButton.frame = CGRectMake(plusButtonIndex * ((CYLTabBarController*)self.delegate).CYLTabBarItemWidth,
                                           CGRectGetMinY(self.plusButton.frame),
                                           CGRectGetWidth(self.plusButton.frame),
                                           CGRectGetHeight(self.plusButton.frame)
                                           );
    } else {
        if (((CYLTabBarController*)self.delegate).CYLTabbarItemsCount % 2 != 0) {
            [NSException raise:@"CYLTabBarController" format:@"If the count of CYLTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果CYLTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = ((CYLTabBarController*)self.delegate).CYLTabbarItemsCount * 0.5;
    }
    ((CYLTabBarController *)self.delegate).CYLPlusButtonIndex = plusButtonIndex;
    return plusButtonIndex;
}

/*!
 *  Deal with some trickiness by Apple, You do not need to understand this method, somehow, it works.
 *  NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.
 */
- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}

- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (((CYLTabBarController*)self.delegate).CYLPlusChildViewController) {
        [tabBarButtonMutableArray removeObjectAtIndex:((CYLTabBarController *)self.delegate).CYLPlusButtonIndex];
    }
    return [tabBarButtonMutableArray copy];
}

- (void)setupSwappableImageViewDefaultOffset:(UIView *)tabBarButton {
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat swappableImageViewHeight = 0.f;
    __block CGFloat swappableImageViewDefaultOffset = 0.f;
    CGFloat tabBarHeight = self.frame.size.height;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj class] isSubclassOfClass:[UILabel class]]) {
            shouldCustomizeImageView = NO;
        }
        swappableImageViewHeight = obj.frame.size.height;
        BOOL isNotSelectionIndicatorView = swappableImageViewHeight < (tabBarHeight - 5);
        BOOL isSwappableImageView = ([[obj class] isSubclassOfClass:[UIImageView class]]) && isNotSelectionIndicatorView;
        if (isSwappableImageView) {
            swappableImageViewDefaultOffset = (tabBarHeight - swappableImageViewHeight) * 0.5 * 0.5;
        }
        if (isSwappableImageView && swappableImageViewDefaultOffset == 0.f) {
            shouldCustomizeImageView = NO;
        }
    }];
    if (shouldCustomizeImageView) {
        self.swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
    }
}

/*!
 *  Capturing touches on a subview outside the frame of its superview.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}

@end
