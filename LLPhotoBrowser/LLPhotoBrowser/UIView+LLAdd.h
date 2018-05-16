//
//  UIView+LLAdd.h
//  LLPhotosBrowser
//
//  Created by LianLeven on 2017/12/26.
//  Copyright © 2017年 LianLeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LLAdd)

@property (nonatomic, strong, readonly) UIViewController *ll_viewController;

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (UIImage *)snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;        

@end

@interface CALayer (LLAdd)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  size;

@property (nonatomic) CGFloat transformRotation;
@property (nonatomic) CGFloat transformRotationX;
@property (nonatomic) CGFloat transformRotationY;
@property (nonatomic) CGFloat transformRotationZ;
@property (nonatomic) CGFloat transformScale;
@property (nonatomic) CGFloat transformScaleX;
@property (nonatomic) CGFloat transformScaleY;
@property (nonatomic) CGFloat transformScaleZ;
@property (nonatomic) CGFloat transformTranslationX;
@property (nonatomic) CGFloat transformTranslationY;
@property (nonatomic) CGFloat transformTranslationZ; 

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic) CGFloat transformDepth;

/**
 Wrapper for `contentsGravity` property.
 */
@property (nonatomic) UIViewContentMode contentMode;

/**
 Add a fade animation to layer's contents when the contents is changed.
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/**
 Cancel fade animation which is added with "-addFadeAnimationWithDuration:curve:".
 */
- (void)removePreviousFadeAnimation;

@end
