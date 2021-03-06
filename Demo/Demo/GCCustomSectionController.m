//
//  GCCustomSectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCCustomSectionController.h"

@interface GCCustomSectionController ()

@property (nonatomic) NSArray* content;

@end

@implementation GCCustomSectionController

#pragma mark -
#pragma mark Simple subclass

- (NSString *)title {
    return NSLocalizedString(@"Custom",);
}

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

#pragma mark -
#pragma mark Customization

- (UITableViewCell *)cellForRow:(NSUInteger)row {
    //All cells in the GCRetractableSectionController will be indented
    UITableViewCell* cell = [super cellForRow:row];
    
    cell.indentationLevel = 1;
    
    return cell;
}

- (UITableViewCell *)titleCell {
    //I removed the detail text here, but you can do whatever you want
    UITableViewCell* titleCell = [super titleCell];
    titleCell.detailTextLabel.text = nil;
    
    return titleCell;
}

- (UITableViewCell *)contentCellForRow:(NSUInteger)row {
    //You can reuse GCRetractableSectionController work by calling super, but you can start from scratch and give a new cell
    UITableViewCell* contentCell = [super contentCellForRow:row];
    
    if (row == 0) {
        contentCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        contentCell.accessoryView = nil;
        contentCell.backgroundColor = [UIColor whiteColor];
    }
    else if (row == 1) {
        contentCell.backgroundColor = [UIColor whiteColor];
    }
    else if (row == 2) {
        contentCell.backgroundColor = [UIColor blueColor];
        contentCell.accessoryView = nil;
        contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
        
    return contentCell;
}

#pragma mark -
#pragma mark Getters 

- (NSArray *)content {
    if (_content == nil) {
        _content = [[NSArray alloc] initWithObjects:@"You can do", @"WHATEVER", @"you want!", nil];
    }
    return _content;
}

@end
