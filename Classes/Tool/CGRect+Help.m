//
//  CGRect+Help.m
//  2tch
//
//  Created by sonson on 09/08/01.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CGRect+Help.h"

void dropFractionOfRect(CGRect *rect) {
	rect->origin.x = (int)rect->origin.x;
	rect->origin.y = (int)rect->origin.y;
	rect->size.width = (int)rect->size.width;
	rect->size.height = (int)rect->size.height;
}