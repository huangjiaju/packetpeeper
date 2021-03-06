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

#ifndef PACKETPEEPER_PACKET_H
#define PACKETPEEPER_PACKET_H

#include "../../PacketPeeper/UI Classes/OutlineViewItem.h"
#include "PPDecoderParent.h"

#import <Foundation/NSObject.h>

#include <sys/types.h>

@class NSData;
@class NSDate;
@class NSMutableArray;
@class MyDocument;
@class HostCache;
@class ColumnIdentifier;
@protocol NSCoding;
@protocol OutlineViewItem;

@interface Packet : NSObject <PPDecoderParent, NSCoding>
{
    MyDocument* document;
    /* the following variables are archived */
    NSDate* date;             /* date the packet was recieved */
    NSMutableArray* decoders; /* array of decoder objects */
    uint32_t captureLength;   /* length of this packet that was captured */
    uint32_t
        actualLength; /* original length of this packet ``off the wire''  */
    unsigned long number;
    BOOL pendingDeletion;
    NSData* data; /* packet data */
    BOOL processedPlugins;
}

- (id)initWithData:(NSData*)dataVal
     captureLength:(uint32_t)aCaptureLength
      actualLength:(uint32_t)anActualLength
         timestamp:(NSDate*)timestamp
         linkLayer:(Class)linkLayer;
- (void)setNumber:(unsigned long)aNumber;
- (unsigned long)number;
- (MyDocument*)document;
- (void)setDocument:(MyDocument*)aDocument;
- (BOOL)isPendingDeletion;
- (void)setPendingDeletion;
- (int)linkType;

@end

#endif
