//
//  UIView+xllayout.h
//  XLLoger
//
//  Created by mgfjx on 2021/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (xllayout)
- (void)activateConstraints:(NSArray<NSLayoutConstraint *> *)constraints;
- (void)reactivateConstraints:(NSArray<NSLayoutConstraint *> *)constraints;
- (void)deactivateAttributes:(NSLayoutAttribute)attributes, ...;
- (void)deactivateToItem:(UIView *)toItem attributes:(NSLayoutAttribute)attributes, ...;
@end

@interface NSLayoutAnchor (xllayout)
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^equalTo)(NSLayoutAnchor * anchor);
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^greaterEqualTo)(NSLayoutAnchor * anchor);
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^lessEqualTo)(NSLayoutAnchor * anchor);
@end

@interface NSLayoutDimension (xllayout)
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^equalToValue)(CGFloat value);
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^greaterEqualToValue)(CGFloat value);
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^lessEqualToValue)(CGFloat value);
@end

@interface NSLayoutConstraint (xllayout)
@property (nonatomic, copy, readonly)NSLayoutConstraint * (^offset)(CGFloat value);
@end

NS_ASSUME_NONNULL_END
