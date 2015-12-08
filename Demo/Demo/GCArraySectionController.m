//
//  GCArraySectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCArraySectionController.h"

@interface GCArraySectionController ()

@property (nonatomic, retain) NSArray* content;

@end

@implementation GCArraySectionController

@synthesize content, title;

- (id) initWithArray:(NSArray *)array tableView:(UITableView*)view{
    if ((self = [super initWithTableView:(UITableView*)view])) {
        self.content = array;
        self.contentCellRetractable = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Subclass

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
}

@end
