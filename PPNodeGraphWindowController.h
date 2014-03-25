/*
 * Packet Peeper
 * Copyright 2006, 2007, Chris E. Holloway
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

#import <AppKit/NSWindowController.h>

@class PPNodeGraphView;
@class NSSlider;
@class NSPopUpButton;

@interface PPNodeGraphWindowController : NSWindowController
{
	IBOutlet PPNodeGraphView *nodeGraph;
	IBOutlet NSSlider *zoomSlider;
	IBOutlet NSPopUpButton *layoutPopUp;
}

//- (id)initWithNodeGraphController:(PPNodeGraphController *)aNodeGraphController;
- (IBAction)layoutPopUpButton:(id)sender;
- (IBAction)zoomSlider:(id)sender;

@end
