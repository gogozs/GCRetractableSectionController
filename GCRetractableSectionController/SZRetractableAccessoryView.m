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
    }
    
    return self;
}

- (void)opened
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGAffineTransform transform = self.layer.affineTransform;
    transform = CGAffineTransformRotate(transform, M_PI);
    self.layer.affineTransform = transform;
    
    [UIView commitAnimations];
}

- (void)closed
{
    [self opened];
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

@end
