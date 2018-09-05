//
//  CMGuidePageView.m
//  UserGuidePage
//
//  Created by 陈梦 on 2018/8/29.
//  Copyright © 2018年 梦. All rights reserved.
//

#import "CMGuidePageView.h"

typedef NS_ENUM(NSInteger, CMGuidePageItemRegion) {
    CMGuidePageItemRegionLeftTop = 0,
    CMGuidePageItemRegionLeftBottom,
    CMGuidePageItemRegionRightTop,
    CMGuidePageItemRegionRightBottom
};

@interface CMGuidePageView()
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIImageView *arrowImgView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation CMGuidePageView
{
        NSInteger count; //记录items总数
}

#pragma mark - 懒加载
- (UIView *)maskView{
    if (!_maskView){
        _maskView = [[UIView alloc]initWithFrame: self.bounds];
    }
    return _maskView;
}

- (UILabel *)textLabel{
    if (!_textLabel){
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView){
        _arrowImgView = [UIImageView new];
    }
    return _arrowImgView;
}

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer){
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}

#pragma mark - 初始化UI
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self prepareUI];
    }
    return self;
}

-(void)prepareUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview: self.maskView];
    [self addSubview: self.textLabel];
    [self addSubview: self.arrowImgView];
    
    //初始化默认值
    self.maskBackgroundColor = [UIColor blackColor];
    self.maskAlpha = 0.7f;
    
    self.arrowImage = [UIImage imageNamed:@"arrow"];
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

// 显示蒙板
-(void)showMask{
    CGPathRef fromPath = self.maskLayer.path;
    
    self.maskLayer.frame = self.bounds;
    
    CGFloat cornerRadius = 5;
    if(self.delegate && [self.delegate respondsToSelector:@selector(guidePageView:cornerRadiusForItemAtIndex:)]){
        cornerRadius = [self.delegate guidePageView:self cornerRadiusForItemAtIndex:self.currentIndex];
    }
    
    //可见区域的路径
    UIBezierPath *visualPath = [UIBezierPath bezierPathWithRoundedRect:[self obtainVisualViewFrame] cornerRadius: cornerRadius];
    
    //获取终点区域的路径
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.bounds];
  
    [toPath appendPath: visualPath];
    
    //遮罩的路径
    self.maskLayer.path = toPath.CGPath;
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.layer.mask = self.maskLayer;
    
    //开始移动动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.3;
    animation.fromValue = (__bridge id _Nullable)(fromPath);
    animation.toValue = (__bridge id _Nullable)(toPath.CGPath);
    [self.maskLayer addAnimation:animation forKey:nil];
    
}

/**
 *  设置 items 的 frame
 */
- (void)configureItemsFrame
{
    //文字颜色
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(guidePageView:colorForDescriptionLabelAtIndex:)]){
        self.textLabel.textColor = [self.dataSource guidePageView:self colorForDescriptionLabelAtIndex:self.currentIndex];
        
    }
    
     //文字大小
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(guidePageView:fontForDescriptionLabelAtIndex:)]){
        self.textLabel.font = [self.dataSource guidePageView:self fontForDescriptionLabelAtIndex:self.currentIndex];
    }
    
    // 描述文字
    NSString *desc = [self.dataSource guidePageView:self descriptionLabelForItemAtIndex: self.currentIndex];
    self.textLabel.text = desc;
    
    CGFloat descInsetsX = 50;
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidePageView:horizontalSpaceForDescriptionLabelAtIndex:)]){
        descInsetsX = [self.delegate guidePageView:self horizontalSpaceForDescriptionLabelAtIndex:self.currentIndex];
    }
    
    CGFloat space = 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidePageView:spaceForSubviewsAtIndex:)]){
        space = [self.delegate guidePageView:self spaceForSubviewsAtIndex: self.currentIndex];
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect textRect,arrowRect;
    
    CGFloat maxWidth = self.bounds.size.width - descInsetsX*2;
    
    CGSize textSize = [desc boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.textLabel.font} context:NULL].size;
    CGSize arrowSize = self.arrowImgView.image.size;
    
    CMGuidePageItemRegion itemRegion = [self obtainVisualViewRegion];
    
    switch (itemRegion) {
        case CMGuidePageItemRegionLeftTop:// - 左上
        {
            transform = CGAffineTransformMakeScale(-1, 1);
            
            arrowRect = CGRectMake(CGRectGetMidX([self obtainVisualViewFrame]) - arrowSize.width/2, CGRectGetMaxY([self obtainVisualViewFrame]) + space, arrowSize.width, arrowSize.height);
            CGFloat x = descInsetsX;
            
            if (textSize.width < CGRectGetWidth([self obtainVisualViewFrame])){
                x = CGRectGetMaxX(arrowRect) - textSize.width/2;
            }
            
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
        case CMGuidePageItemRegionLeftBottom:// - 左下
        {
            transform = CGAffineTransformMakeScale(-1, -1);
            
            arrowRect = CGRectMake(CGRectGetMidX([self obtainVisualViewFrame]) - arrowSize.width/2, CGRectGetMinY([self obtainVisualViewFrame]) - space - arrowSize.height, arrowSize.width, arrowSize.height);
            CGFloat x = descInsetsX;
            if (textSize.width < CGRectGetWidth([self obtainVisualViewFrame])){
                x = CGRectGetMaxX(arrowRect) - textSize.width/2;
            }
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
        case CMGuidePageItemRegionRightTop:// - 右上
        {
            arrowRect = CGRectMake(CGRectGetMidX([self obtainVisualViewFrame]) - arrowSize.width/2, CGRectGetMaxY([self obtainVisualViewFrame]) + space, arrowSize.width, arrowSize.height);
            CGFloat x = descInsetsX;
            if (textSize.width < CGRectGetWidth([self obtainVisualViewFrame])){
                x = CGRectGetMinX(arrowRect) - textSize.width/2;
            }
            else{
                x = descInsetsX + maxWidth - textSize.width;
            }
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
        case CMGuidePageItemRegionRightBottom:// - 右下
        {
            transform = CGAffineTransformMakeScale(1, -1);
            arrowRect = CGRectMake(CGRectGetMidX([self obtainVisualViewFrame]) - arrowSize.width/2, CGRectGetMinY([self obtainVisualViewFrame]) - space - arrowSize.height, arrowSize.width, arrowSize.height);
            CGFloat x = descInsetsX;
            if (textSize.width < CGRectGetWidth([self obtainVisualViewFrame])){
                x = CGRectGetMinX(arrowRect) - textSize.width/2;
            }
            else{
                x = descInsetsX + maxWidth - textSize.width;
            }
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
    }
    
    // 图片 和 文字的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowImgView.transform = transform;
        self.arrowImgView.frame = arrowRect;
        self.textLabel.frame = textRect;
    }];
    
}

// 获取可见视图的frame
- (CGRect)obtainVisualViewFrame{
    if (self.currentIndex >= count) return CGRectZero;
    
    UIView *visualView = [self.dataSource guidePageView:self viewForItemAtIndex:self.currentIndex];
    
    CGRect visualRect = [self convertRect:visualView.frame fromView:visualView.superview];
    
    UIEdgeInsets maskInset = UIEdgeInsetsMake(-8, -8, -8, -8);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidePageView:insetForItemAtIndex:)]){
        maskInset = [self.delegate guidePageView:self insetForItemAtIndex:self.currentIndex];
    }
    visualRect.origin.x = visualRect.origin.x + maskInset.left;
    visualRect.origin.y = visualRect.origin.y + maskInset.top;
    visualRect.size.height = visualRect.size.height - maskInset.top - maskInset.bottom;
    visualRect.size.width = visualRect.size.width - maskInset.right - maskInset.left;
    
    return visualRect;
}

-(CMGuidePageItemRegion)obtainVisualViewRegion{
    CGPoint visualCenter = CGPointMake(CGRectGetMidX([self obtainVisualViewFrame]), CGRectGetMidY([self obtainVisualViewFrame]));
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (visualCenter.x < viewCenter.x && visualCenter.y <= viewCenter.y){
          return CMGuidePageItemRegionLeftTop;
    }
    else if (visualCenter.x >= viewCenter.x && visualCenter.y <= viewCenter.y){
           return CMGuidePageItemRegionRightTop;
    }
    else if (visualCenter.x < viewCenter.x && visualCenter.y > viewCenter.y){
        return CMGuidePageItemRegionLeftBottom;
    }
    else{
        return CMGuidePageItemRegionRightBottom;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**
     *  如果当前下标不是最后一个，则移到下一个引导图
     *  如果当前为最后一个下标，则直接返回
     */
    if (self.currentIndex < count - 1){
        self.currentIndex++;
    }else{
        [self hide];
    }
}

-(void)show{
    if (self.dataSource){
        count = [self.dataSource numberOfItemsInGuidePageView: self];
    }
   
    if (count <= 0) return;
    
    // 从 0 开始进行显示
    self.currentIndex = 0;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview: self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];

}

- (void)hide{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
         self.alpha = 0;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}

#pragma mark - Setter Method
- (void)setMaskBackgroundColor:(UIColor *)maskBackgroundColor{
    _maskBackgroundColor = maskBackgroundColor;
    self.maskView.backgroundColor = maskBackgroundColor;
}

- (void)setMaskAlpha:(CGFloat)maskAlpha{
    _maskAlpha = maskAlpha;
    self.maskView.alpha = maskAlpha;
}

- (void)setArrowImage:(UIImage *)arrowImage{
    _arrowImage = arrowImage;
    self.arrowImgView.image = arrowImage;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self configureItemsFrame];
    [self showMask];
    
}
@end
