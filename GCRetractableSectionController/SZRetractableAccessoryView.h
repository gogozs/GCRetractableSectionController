//
//  SZRetractableAccessoryView.h
//  Demo
//
//  Created by Song Zhou on 15/12/5.
//  Copyright © 2015 Song Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SZAccessoryViewStyle) {
    SZAccessoryViewStyleBottom,
    SZAccessoryViewStyleLeft
};

@interface SZRetractableAccessoryView : UIImageView

@property (nonatomic) SZAccessoryViewStyle accessoryViewStyle; // accessoryView arrow direction, left or bottom

- (void)updateWithState: (BOOL)open;
@end
