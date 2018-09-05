//
//  CMGuidePageView.h
//  UserGuidePage
//
//  Created by 陈梦 on 2018/8/29.
//  Copyright © 2018年 梦. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMGuidePageView;
@protocol CMGuidePageViewDataSource <NSObject>
@required
/**
 Item的个数
 */
- (NSInteger)numberOfItemsInGuidePageView:(CMGuidePageView *)guidePageView;

/**
 每个Item对应的视图View
 */
- (UIView *)guidePageView:(CMGuidePageView *)guidePageView viewForItemAtIndex:(NSInteger)index;

/**
 每个Item对应的的描述
 */
- (NSString *)guidePageView:(CMGuidePageView *)guidePageView descriptionLabelForItemAtIndex:(NSInteger)index;
@optional
/**
 描述文字的颜色：默认白色
 */
- (UIColor *)guidePageView:(CMGuidePageView *)guidePageView colorForDescriptionLabelAtIndex:(NSInteger)index;

/**
 描述文字的大小：默认15
 */
- (UIFont *)guidePageView:(CMGuidePageView *)guidePageView fontForDescriptionLabelAtIndex:(NSInteger)index;

@end

@protocol CMGuidePageViewDelegate <NSObject>
@optional

/**
 每个Item的蒙版的圆角:默认为5
 */
- (CGFloat)guidePageView:(CMGuidePageView *)guidePageView cornerRadiusForItemAtIndex:(NSInteger)index;

/**
 每个Item与蒙版的边距:默认为(-8, -8, -8, -8)
 */
- (UIEdgeInsets)guidePageView:(CMGuidePageView *)guidePageView insetForItemAtIndex:(NSInteger)index;

/**
 每个Item的子视图的间距：默认为 10（子视图包括当前的view、arrowImage、textLabel）
 */
- (CGFloat)guidePageView:(CMGuidePageView *)guidePageView spaceForSubviewsAtIndex:(NSInteger)index;

/**
 每个Item的文字与左右边框的间距：默认为 50
 */
- (CGFloat)guidePageView:(CMGuidePageView *)guidePageView horizontalSpaceForDescriptionLabelAtIndex:(NSInteger)index;
@end

@interface CMGuidePageView : UIView
@property (strong, nonatomic) UIImage *arrowImage;
@property (strong, nonatomic) UIColor *maskBackgroundColor;
@property (assign, nonatomic) CGFloat maskAlpha;

@property (weak, nonatomic) id<CMGuidePageViewDelegate> delegate;
@property (weak, nonatomic) id<CMGuidePageViewDataSource> dataSource;

- (void)show;
- (void)hide;
@end
