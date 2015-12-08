//
//  GCRetractableSectionController.h
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZRetractableAccessoryView.h"

@class GCRetractableSectionController;

@protocol GCRetractableSectionDataSource <NSObject>

@required
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, readonly) NSUInteger contentNumberOfRow;
- (NSString*) titleContentForRow:(NSUInteger) row;

@optional
- (UITableViewCell*) titleCell;
- (UITableViewCell*) contentCellForRow:(NSUInteger) row;

@end

@protocol GCRetractableSectionDelegate <NSObject>

@optional
- (void) didSelectTitleCell;
- (void) didSelectContentCellAtRow:(NSUInteger) row;

@end

@interface GCRetractableSectionController : NSObject <GCRetractableSectionDataSource, GCRetractableSectionDelegate>

@property (nonatomic, weak) id <GCRetractableSectionDelegate> delegate;
@property (nonatomic, assign, getter = isOpen) BOOL open;

- (id) initWithView:(UITableView*)view;

//Used by the UITableView's dataSource
- (UITableViewCell*) cellForRow:(NSUInteger) row;
@property (nonatomic, readonly) NSUInteger numberOfRow;

//Customize appearance
 //Use only white images if the cells background is dark
@property (nonatomic, assign, getter = isOnlyUsingWhiteImages) BOOL useOnlyWhiteImages;
@property (nonatomic, assign) UIColor* titleTextColor; //nil by default, black text
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation; //Animation to insert/remove cells, UITableViewRowAnimationTop by default
@property (nonatomic) SZAccessoryViewStyle accessoryViewStyle;

// Behavior
@property (nonatomic, getter=isContentCellRetractable) BOOL contentCellRetractable;
//Reserved for subclasses
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, readonly) UITableView *tableView;

- (void) didSelectCellAtRow:(NSUInteger) row;
@end
