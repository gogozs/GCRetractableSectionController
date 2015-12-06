//
//  GCRetractableSectionController.h
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

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
- (void) didSelectCellAtRow:(NSUInteger) row;
- (void) didSelectContentCellAtRow:(NSUInteger) row;
- (void) didSelectTitleCell;

@end

@interface GCRetractableSectionController : NSObject <GCRetractableSectionDataSource, GCRetractableSectionDelegate>

@property (nonatomic, assign, getter = isOpen) BOOL open;

- (id) initWithViewController:(UIViewController*) givenViewController;

//Used by the UITableView's dataSource
- (UITableViewCell*) cellForRow:(NSUInteger) row;
@property (nonatomic, readonly) NSUInteger numberOfRow;

//Customize appearance
 //Use only white images if the cells background is dark
@property (nonatomic, assign, getter = isOnlyUsingWhiteImages) BOOL useOnlyWhiteImages;
@property (nonatomic, assign) UIColor* titleTextColor; //nil by default, black text
@property (nonatomic, assign) UIColor* titleAlternativeTextColor; //nil by default, dark blue
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation; //Animation to insert/remove cells, UITableViewRowAnimationTop by default


// Behavior
@property (nonatomic, getter=isContentCellRetractable) BOOL contentCellRetractable;
//Reserved for subclasses
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, readonly) UITableView *tableView;

@end
