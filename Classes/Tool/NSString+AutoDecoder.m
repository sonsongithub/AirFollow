//
//  NSString+AutoDecoder.m
// 
// The MIT License
// 
// Copyright (c) 2009 sonson, sonson@Picture&Software
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  Created by sonson on 09/05/20.
//  Copyright 2009 sonson, sonson@Picture&Software. All rights reserved.
//

#import "NSString+AutoDecoder.h"

#define NUMBER_OF_CODE 5

unsigned int	*codes = NULL;

#ifdef AUTO_DECODE_DEBUG
NSMutableArray	*codeNames = nil;
#endif

@implementation NSString(AutoDecoder)

+ (void)initialize {
	if (codes == NULL) {
		codes = (unsigned int*)malloc( sizeof( unsigned int ) * NUMBER_OF_CODE );
		unsigned int* p = codes;
		*(p++) = NSUTF8StringEncoding;
		*(p++) = NSShiftJISStringEncoding;
		*(p++) = NSISO2022JPStringEncoding;
		*(p++) = CFStringConvertEncodingToNSStringEncoding(CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacJapanese));
		*(p++) = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS_X0213_00);
#ifdef AUTO_DECODE_DEBUG
		codeNames = [[NSMutableArray alloc] init];
		[codeNames addObject:@"NSUTF8StringEncoding"];
		[codeNames addObject:@"NSShiftJISStringEncoding"];
		[codeNames addObject:@"kCFStringEncodingISO_2022_JP"];
		[codeNames addObject:@"kCFStringEncodingMacJapanese"];
		[codeNames addObject:@"kCFStringEncodingShiftJIS_X0213_00"];
#endif
	}
}

+ (unsigned int)encodeingFromBytes:(char*)p length:(int)length {
	if( length < 1 )
		return 0;
	NSString *decoded_strings = nil;
	int i;
	for( i = 0; i < NUMBER_OF_CODE; i++ ) {
		decoded_strings = [[NSString alloc] initWithBytes:p length:length encoding:codes[i]];
		if( decoded_strings ) {
			if( [decoded_strings length] > 0 ) {
				[decoded_strings release];
				return codes[i];
			}
			[decoded_strings release];
		}
	}
	return 0;
}

+ (NSString*)stringAutoDecodeFromData:(NSData*)data {
	char *p = (char*)[data bytes];
	int length = [data length];
	return [NSString stringAutoDecodeBytesFrom:p length:length];
}

+ (NSString*)stringAutoDecodeNoCopyBytesFrom:(char*)p length:(int)length {
	if (length < 1) {
		return nil;
	}
	NSString *decoded_strings = nil;
	int i;
	for (i = 0; i < NUMBER_OF_CODE; i++) {
		decoded_strings = [[NSString alloc] initWithBytesNoCopy:p length:length encoding:codes[i] freeWhenDone:NO];
		if (decoded_strings) {
			if ([decoded_strings length] > 0) {
#ifdef AUTO_DECODE_DEBUG
				NSLog(@"Decoding with %@", [codeNames objectAtIndex:i]);
				NSLog(@"%@", decoded_strings);
#endif
				return [decoded_strings autorelease];
			}
			[decoded_strings release];
		}
	}
	return nil;
};

+ (NSString*)stringAutoDecodeBytesFrom:(char*)p length:(int)length {
	if (length < 1) {
		return nil;
	}
	NSString *decoded_strings = nil;
	int i;
	for (i = 0; i < NUMBER_OF_CODE; i++) {
		decoded_strings = [[NSString alloc] initWithBytes:p length:length encoding:codes[i]];
		if (decoded_strings) {
			if ([decoded_strings length] > 0) {
#ifdef AUTO_DECODE_DEBUG
				NSLog(@"Decoding with %@", [codeNames objectAtIndex:i]);
				NSLog(@"%@", decoded_strings);
#endif
				return [decoded_strings autorelease];
			}
			[decoded_strings release];
		}
	}
	return nil;
};

+ (NSString*)stringAutoDecodeBytesFrom:(char*)p length:(int)length encoding:(int*)encoding {
	if( length < 1 )
		return @"";
	NSString *decoded_strings = nil;
	int i;
	for( i = 0; i < NUMBER_OF_CODE; i++ ) {
		decoded_strings = [[NSString alloc] initWithBytes:p length:length encoding:codes[i]];
		if( decoded_strings ) {
			if( [decoded_strings length] > 0 ) {
				// DNSLog( @"Decoding with %@", [codeNames objectAtIndex:i]);
				//	DNSLog( @"%@", decoded_strings );
				*encoding = codes[i];
				return [decoded_strings autorelease];
			}
			[decoded_strings release];
		}
	}
	return nil;
};

+ (NSString*)stringAutoDecodeBytes:(char*)p from:(int)from to:(int)to {
	return [NSString stringAutoDecodeBytesFrom:p+from length:to-from];
}

@end
