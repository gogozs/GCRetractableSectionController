//
//  GCRetractableSectionController.m
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import "GCRetractableSectionController.h"

@interface GCRetractableSectionController ()

@property (nonatomic) UITableView *privateTableView;

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell;

@end

@implementation GCRetractableSectionController

#pragma mark - Initialisation
// Designated initializer
- (id) initWithTableView:(UITableView*)view
{
	if ((self = [super init])) {
        self.tableView = view;
		self.open = NO;
        self.rowAnimation = UITableViewRowAnimationTop;
        self.contentCellRetractable = NO;
        self.accessoryViewStyle = SZAccessoryViewStyleLeft;
	}
    
    return self;
}

#pragma mark - Accessors
- (UITableView*) tableView {
    return _privateTableView;
}

- (void)setTableView:(UITableView *)tableView
{
    _privateTableView = tableView;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) cellForRow:(NSUInteger)row {
	UITableViewCell* cell = nil;
	
    if (row == 0) {
     cell = [self titleCell];
    } else {
        if (self.isOpen) {
            if (row == [self contentNumberOfRow] + 1){ // bottom cell
                cell = [self bottomCell];
            } else {
                 cell = [self contentCellForRow:row - 1];
            }
        } else {
            if (row == 1) {
                cell = [self bottomCell];
            }
        }
    }
        
	return cell;
}


#pragma mark - Private Methods
- (void) setAccessoryViewOnCell:(UITableViewCell*) cell {
	if (cell.accessoryView == nil) {
        cell.accessoryView = [[SZRetractableAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [(SZRetractableAccessoryView *)cell.accessoryView setAccessoryViewStyle:self.accessoryViewStyle];
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
    NSUInteger result = 0;
    if (self.hasBottomCell) {
        result += 1;
    }
    if (self.isOpen) {
        result += self.contentNumberOfRow + 1;
    } else {
        result += 1;
    }
    
    return result;
}

- (NSUInteger) contentNumberOfRow {
	return 0;
}

- (NSString*) title {
	return NSLocalizedString(@"",);
}

- (NSString*) titleContentForRow:(NSUInteger) row {
	return NSLocalizedString(@"",);
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor blackColor];
	}
	
	return cell;
}

- (UITableViewCell *) bottomCell {
	NSString* titleCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"bottom"];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier];
    	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}

- (UITableViewCell *) contentCellForRow:(NSUInteger)row {
	NSString* contentCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"content"];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = [self titleContentForRow:row];
	
	return cell;
}

#pragma mark - GCRetractableSectionDataDelegate
- (void) didSelectCellAtRow:(NSUInteger)row {
    if (row == 0) {
     [self privateDidSelectTitleCell];
    } else {
     [self privateDidSelectContentCellAtRow:row - 1];
    }
}

- (void) privateDidSelectTitleCell {
	self.open = !self.open;
    if (self.contentNumberOfRow != 0) {
        [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]];
    }
    [self updateContentCell];
    
    if ([self.delegate respondsToSelector:@selector(didSelectTitleCell)]) {
        [self.delegate didSelectTitleCell];
    }
}

- (void) privateDidSelectContentCellAtRow:(NSUInteger)row {
    if (self.isContentCellRetractable) {
        self.open = !self.open;
        [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:
                                      [NSIndexPath indexPathForRow:0 inSection: [self.tableView indexPathForSelectedRow].section]]];
        [self updateContentCell];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectContentCellAtRow:)]) {
        [self.delegate didSelectContentCellAtRow:row];
    }
}

@end
