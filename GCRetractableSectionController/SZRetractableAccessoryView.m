//
//  SZRetractableAccessoryView.m
//  Demo
//
//  Created by Song Zhou on 15/12/5.
//  Copyright © 2015 Song Zhou. All rights reserved.
//

#import "SZRetractableAccessoryView.h"

@interface SZRetractableAccessoryView ()

@property (nonatomic) CABasicAnimation *rotationAnimation;
@property (getter=isOpen) BOOL open;

@end

@implementation SZRetractableAccessoryView

// Designated initializer
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"accessory"]];
        self.open = NO;
        self.accessoryViewStyle = SZAccessoryViewStyleBottom;
    }
    
    return self;
}

- (void)opened
{
    switch (self.accessoryViewStyle) {
        case SZAccessoryViewStyleBottom: {
            [self accessoryViewAnimationWithAngle:M_PI];
            
            break;
        }
        case SZAccessoryViewStyleLeft: {
            [self accessoryViewAnimationWithAngle:-M_PI_2];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)closed
{
    switch (self.accessoryViewStyle) {
        case SZAccessoryViewStyleBottom: {
            [self accessoryViewAnimationWithAngle:M_PI];
            
            break;
        }
        case SZAccessoryViewStyleLeft: {
            [self accessoryViewAnimationWithAngle:M_PI_2];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)updateWithState: (BOOL)open
{
    if (open != self.isOpen) {
        self.open = open;
        if (open == YES) {
            [self opened];
        } else {
            [self closed];
        }
    }
}

#pragma mark - Accessors
- (void)setAccessoryViewStyle:(SZAccessoryViewStyle)accessoryViewStyle
{
    if (accessoryViewStyle == SZAccessoryViewStyleLeft) {
        _accessoryViewStyle = SZAccessoryViewStyleLeft;
        [self accessoryViewAnimationWithAngle:M_PI_2];
    }
}

#pragma mark - Private Methods
- (void)accessoryViewAnimationWithAngle: (CGFloat)angle
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGAffineTransform transform = self.layer.affineTransform;
    transform = CGAffineTransformRotate(transform, angle);
    self.layer.affineTransform = transform;
    
    [UIView commitAnimations];
}
@end
