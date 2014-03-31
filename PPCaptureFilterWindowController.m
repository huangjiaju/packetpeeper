/*
 * Packet Peeper
 * Copyright 2006, 2007, 2008, 2014 Chris E. Holloway
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>
#import <AppKit/NSApplication.h>
#import <AppKit/NSWindow.h>
#import <AppKit/NSTextField.h>
#import <AppKit/NSComboBox.h>
#include "PPCaptureFilter.h"
#include "PPCaptureFilterManager.h"
#include "PPCaptureFilterFormatter.h"
#include "PPHexNumberFormatter.h"
#include "MyDocument.h"
#include "PPCaptureFilterWindowController.h"

@implementation PPCaptureFilterWindowController

- (id)init
{
	if((self = [super initWithWindowNibName:@"PPCaptureFilterSheet"]) != nil) {
		filters = nil;
	}
	return self;
}

- (PPCaptureFilter *)filter
{
	return [filterTextField objectValue];
}

- (void)windowDidLoad
{
	PPCaptureFilterFormatter *filterFormatter;
	PPHexNumberFormatter *hexFormatter;

	[[self window] setExcludedFromWindowsMenu:YES];

	if((filterFormatter = [[PPCaptureFilterFormatter alloc] init]) != nil) {
		[filterTextField setFormatter:filterFormatter];
		[filterFormatter release];
	}

	if((hexFormatter = [[PPHexNumberFormatter alloc] init]) != nil) {
		[filterNetmaskTextField setFormatter:hexFormatter];
		[hexFormatter release];
	}

	/* should save the last filter? */

	filters = [[[PPCaptureFilterManager sharedCaptureFilterManager] allFilters] retain];

	[filterTextField setDelegate:self];

	[filterNameComboBox setDataSource:self];
	[filterNameComboBox setDelegate:self];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if(returnCode) {
		[[self document] setCaptureFilter:[self filter]];
	}

	[[self window] orderOut:self];
	[[self document] removeWindowController:self];
}

/* NSControl delegate methods */

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error
{
	if(error != nil)
		[filterErrorTextField setStringValue:[NSString stringWithFormat:@"Error: %@", error]];

	return NO;
}

/* NSComboBox data source methods */

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox
{
	return [filters count];
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)itemIndex
{
	return [[filters objectAtIndex:itemIndex] name];
}

/* NSComboBox delegate methods */

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
	int itemIndex;

	if((itemIndex = [filterNameComboBox indexOfSelectedItem]) == -1)
		return;

	[filterTextField setObjectValue:[filters objectAtIndex:itemIndex]];
	[filterNetmaskTextField setObjectValue:[NSNumber numberWithUnsignedLong:[[filters objectAtIndex:itemIndex] netmask]]];
}

- (IBAction)saveFilterButtonPressed:(id)sender
{
	PPCaptureFilterManager *filterManager;
	PPCaptureFilter *filter;

	if([[filterNameComboBox stringValue] length] < 1) {
		[filterErrorTextField setStringValue:@"Error: Please enter a filter name"];
		return;
	}

	if([[filterTextField stringValue] length] < 1) {
		[filterErrorTextField setStringValue:@"Error: No filter text entered to save"];
		return;
	}

	filterManager = [PPCaptureFilterManager sharedCaptureFilterManager];

	filter = [filterTextField objectValue];
	[filter setName:[filterNameComboBox stringValue]];
	[filter setNetmask:[[filterNetmaskTextField objectValue] unsignedLongValue]];

	[filterManager addFilter:filter];

	[filters release];
	filters = [[[PPCaptureFilterManager sharedCaptureFilterManager] allFilters] retain];

	[filterErrorTextField setStringValue:@"Filter saved"];
}

- (IBAction)deleteFilterButtonPressed:(id)sender
{
	PPCaptureFilterManager *filterManager;
	PPCaptureFilter *filter;

	filterManager = [PPCaptureFilterManager sharedCaptureFilterManager];

	if((filter = [filterManager filterForName:[filterNameComboBox stringValue]]) == nil)
		return;

	if([filters count] < 2) {
		/* no more items, clear all */
		[filterNameComboBox setStringValue:@""];
		[filterTextField setStringValue:@""];
		[filterNetmaskTextField setStringValue:@""];
	} else {
		int itemIndex;

		/* select item below, or next lowest if we were bottom item */

		if([filterNameComboBox indexOfSelectedItem] < 1)
			itemIndex = 0;
		else
			itemIndex = [filterNameComboBox indexOfSelectedItem] - 1;

		[filterNameComboBox selectItemAtIndex:itemIndex];
	}

	[filterManager removeFilter:filter];

	[filters release];
	filters = [[[PPCaptureFilterManager sharedCaptureFilterManager] allFilters] retain];

	[filterErrorTextField setStringValue:@""];
}

- (IBAction)applyButtonPressed:(id)sender
{
	[[self window] orderOut:sender];
	[NSApp endSheet:[self window] returnCode:1];
}

- (IBAction)cancelButtonPressed:(id)sender
{
	[[self window] orderOut:sender];
	[NSApp endSheet:[self window] returnCode:0];
}

- (void)dealloc
{
	[filters release];
	[super dealloc];
}

@end
