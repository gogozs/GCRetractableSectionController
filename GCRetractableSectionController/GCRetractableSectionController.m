//
//  GCRetractableSectionController.m
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import "GCRetractableSectionController.h"
#import "SZRetractableAccessoryView.h"

@interface GCRetractableSectionController ()

@property (nonatomic, assign) UIViewController *viewController;

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell;

@end

@implementation GCRetractableSectionController

#pragma mark - Initialisation
- (id) initWithViewController:(UIViewController*) givenViewController {
	if ((self = [super init])) {
        if (![givenViewController respondsToSelector:@selector(tableView)]) {
            //The view controller MUST have a tableView proprety
            [NSException raise:@"Wrong view controller" 
                        format:@"The passed view controller to GCRetractableSectionController must respond to the tableView proprety"];
        }
        
		self.viewController = givenViewController;
		self.open = NO;
        self.useOnlyWhiteImages = NO;
        self.rowAnimation = UITableViewRowAnimationTop;
        self.contentCellRetractable = NO;
	}
	return self;
}


#pragma mark - Accessors
- (UITableView*) tableView {
	return [self.viewController performSelector:@selector(tableView)];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) cellForRow:(NSUInteger)row {
	UITableViewCell* cell = nil;
	
	if (row == 0) cell = [self titleCell];
	else cell = [self contentCellForRow:row - 1];
	
	return cell;
}


#pragma mark - Private Methods
- (void) setAccessoryViewOnCell:(UITableViewCell*) cell {
	if (self.open) {
        if (self.titleAlternativeTextColor == nil) cell.textLabel.textColor =  [UIColor colorWithRed:0.191 green:0.264 blue:0.446 alpha:1.000];
        else cell.textLabel.textColor = self.titleAlternativeTextColor;
	}	
	else {
		cell.textLabel.textColor = (self.titleTextColor == nil ? [UIColor blackColor] : self.titleTextColor);
	}
	
	if (cell.accessoryView == nil) {
        cell.accessoryView = [[SZRetractableAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [(SZRetractableAccessoryView *)cell.accessoryView setAccessoryViewStyle:SZAccessoryViewStyleBottom];
    }
    [(SZRetractableAccessoryView *)cell.accessoryView updateWithState:self.open];
}

- (void)updateContentCell
{
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
	NSUInteger section = indexPath.section;
	NSUInteger contentCount = self.contentNumberOfRow;
	
	[self.tableView beginUpdates];
	
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (self.open) [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:self.rowAnimation];
	else [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:self.rowAnimation];
	
	[self.tableView endUpdates];
	
	if (self.open) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - GCRetractableSectionDataSource
- (NSUInteger) numberOfRow {
    return (self.open) ? self.contentNumberOfRow + 1 : 1;
}

- (NSUInteger) contentNumberOfRow {
	return 0;
}

- (NSString*) title {
	return NSLocalizedString(@"No title",);
}

- (NSString*) titleContentForRow:(NSUInteger) row {
	return NSLocalizedString(@"No title",);
}

- (UITableViewCell *) titleCell {
	NSString* titleCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"title"];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier];
	}
	
	cell.textLabel.text = self.title;
	if (self.contentNumberOfRow != 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self setAccessoryViewOnCell:cell];
	}
	else {
		cell.detailTextLabel.text = NSLocalizedString(@"No item",);
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor blackColor];
	}
	
	return cell;
}

- (UITableViewCell *) contentCellForRow:(NSUInteger)row {
	NSString* contentCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"content"];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [self titleContentForRow:row];
	
	return cell;
}

#pragma mark - GCRetractableSectionDataDelegate
- (void) didSelectCellAtRow:(NSUInteger)row {
	if (row == 0) [self didSelectTitleCell];
	else [self didSelectContentCellAtRow:row - 1];
}

- (void) didSelectTitleCell {
	self.open = !self.open;
    if (self.contentNumberOfRow != 0) {
        [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]];
    }
	
    [self updateContentCell];
}

- (void) didSelectContentCellAtRow:(NSUInteger)row {
    if (self.isContentCellRetractable) {
        self.open = !self.open;
        [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:
                                      [NSIndexPath indexPathForRow:0 inSection: [self.tableView indexPathForSelectedRow].section]]];
        
        [self updateContentCell];
    }
}


@end
