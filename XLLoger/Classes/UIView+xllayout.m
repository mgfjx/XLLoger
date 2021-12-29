//
//  UIView+xllayout.m
//  XLLoger
//
//  Created by mgfjx on 2021/12/29.
//

#import "UIView+xllayout.h"

@implementation UIView (xllayout)

/**
 添加约束
 */
- (void)activateConstraints:(NSArray<NSLayoutConstraint *> *)constraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)reactivateConstraints:(NSArray<NSLayoutConstraint *> *)constraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray<NSLayoutConstraint *> * currentConstraints = [NSMutableArray arrayWithArray:self.constraints];
    if (self.superview) {
        [currentConstraints addObjectsFromArray:self.superview.constraints];
    }
    NSMutableArray * deactivateArray = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint * constraint in currentConstraints) {
        if (constraint.firstItem == self) {
            [deactivateArray addObject:constraint];
        }
    }
    if (deactivateArray.count > 0) {
        [NSLayoutConstraint deactivateConstraints:deactivateArray];
    }
    [NSLayoutConstraint activateConstraints:constraints];
}

/**
 移除自身约束或者与父视图之间的约束
 */

- (void)deactivateAttributes:(NSLayoutAttribute)attributes, ... {
    @autoreleasepool {
        if (self.constraints.count > 0) {
            NSMutableArray * argsArray = [[NSMutableArray alloc] init];
            [argsArray addObject:@(attributes)];
            va_list params;
            va_start(params, attributes);
            NSLayoutAttribute arg;
            while((arg = va_arg(params, NSLayoutAttribute))) {
                if(arg) {
                    [argsArray addObject:@(arg)];
                }
            }
            va_end(params);
            NSMutableArray * constraints = [NSMutableArray arrayWithArray:self.constraints];
            if (self.superview) {
                [constraints addObjectsFromArray: self.superview.constraints];
            }
            NSMutableArray * deactivateArray = [[NSMutableArray alloc] init];
            for (NSNumber * arg in argsArray) {
                NSLayoutAttribute attribute = arg.integerValue;
                NSMutableArray * currentDeactivateArray = [[NSMutableArray alloc] init];
                for (NSLayoutConstraint * constraint in constraints) {
                    if ((constraint.firstItem == self &&
                        constraint.firstAttribute == attribute &&
                        constraint.secondItem == nil &&
                        constraint.secondAttribute == NSLayoutAttributeNotAnAttribute) ||
                        (self.superview &&
                         ((constraint.firstItem == self &&
                         constraint.secondItem == self.superview &&
                         constraint.firstAttribute == attribute) ||
                         (constraint.firstItem == self.superview &&
                          constraint.secondItem == self &&
                          constraint.secondAttribute == attribute)))) {
                        [currentDeactivateArray addObject:constraint];
                    }
                }
                [constraints removeObjectsInArray:currentDeactivateArray];
                [deactivateArray addObjectsFromArray:currentDeactivateArray];
            }
            if (deactivateArray.count > 0) {
                [NSLayoutConstraint deactivateConstraints:deactivateArray];
            }
        }
    }
}

/**
 移除自身与兄弟视图之间的约束
 */
- (void)deactivateToItem:(UIView *)toItem attributes:(NSLayoutAttribute)attributes, ... {
    @autoreleasepool {
        if (self.superview && self.constraints.count > 0) {
            NSMutableArray * argsArray = [[NSMutableArray alloc] init];
            [argsArray addObject:@(attributes)];
            va_list params;
            va_start(params, attributes);
            NSLayoutAttribute arg;
            while((arg = va_arg(params, NSLayoutAttribute))) {
                if(arg) {
                    [argsArray addObject:@(arg)];
                }
            }
            va_end(params);
            NSMutableArray * constraints = [NSMutableArray arrayWithArray:self.superview.constraints];
            NSMutableArray * deactivateArray = [[NSMutableArray alloc] init];
            for (NSNumber * arg in argsArray) {
                NSLayoutAttribute attribute = arg.integerValue;
                NSMutableArray * currentDeactivateArray = [[NSMutableArray alloc] init];
                for (NSLayoutConstraint * constraint in constraints) {
                    if ((constraint.firstItem == self &&
                        constraint.firstAttribute == attribute &&
                        constraint.secondItem == toItem) ||
                        (constraint.secondItem == self &&
                         constraint.secondAttribute == attribute &&
                         constraint.firstItem == toItem)) {
                        [currentDeactivateArray addObject:constraint];
                    }
                }
                [constraints removeObjectsInArray:currentDeactivateArray];
                [deactivateArray addObjectsFromArray:currentDeactivateArray];
            }
            if (deactivateArray.count > 0) {
                [NSLayoutConstraint deactivateConstraints:deactivateArray];
            }
        }
    }
}

@end

@implementation NSLayoutAnchor (xllayout)

- (NSLayoutConstraint * _Nonnull (^)(NSLayoutAnchor * anchor))equalTo {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (NSLayoutAnchor * anchor) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintEqualToAnchor:anchor];
    };
}

- (NSLayoutConstraint * _Nonnull (^)(NSLayoutAnchor * anchor))lessEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (NSLayoutAnchor * anchor) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintLessThanOrEqualToAnchor:anchor];
    };
}

- (NSLayoutConstraint * _Nonnull (^)(NSLayoutAnchor * anchor))greaterEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (NSLayoutAnchor * anchor) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintGreaterThanOrEqualToAnchor:anchor];
    };
}

@end

@implementation NSLayoutDimension (xllayout)

- (NSLayoutConstraint * _Nonnull (^)(CGFloat value))equalToValue {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (CGFloat value) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintEqualToConstant:value];
    };
}

- (NSLayoutConstraint * _Nonnull (^)(CGFloat value))lessEqualToValue {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (CGFloat value) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintLessThanOrEqualToConstant:value];
    };
}

- (NSLayoutConstraint * _Nonnull (^)(CGFloat value))greaterEqualToValue {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (CGFloat value) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf constraintGreaterThanOrEqualToConstant:value];
    };
}

@end

@implementation NSLayoutConstraint (xllayout)

- (NSLayoutConstraint * _Nonnull (^)(CGFloat value))offset {
    __weak typeof(self) weakSelf = self;
    return ^NSLayoutConstraint * (CGFloat value) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.constant = value;
        return strongSelf;
    };
}

@end
