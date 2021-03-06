//
//  MMPButton.m
//  MobMuPlatEd1
//
//  Created by Daniel Iglesia on 12/28/12.
//  Copyright (c) 2012 Daniel Iglesia. All rights reserved.
//

#import "MMPButton.h"
#define EDGE_RADIUS 5

@implementation MMPButton

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.address=@"/myButton";
        self.layer.backgroundColor=[MMPControl CGColorFromNSColor:self.color];
        self.layer.cornerRadius=EDGE_RADIUS;
        [self addHandles];
    }
    return self;
}

-(void)hackRefresh{
    [super hackRefresh];
    self.layer.cornerRadius=EDGE_RADIUS;
}

-(void)mouseDown:(NSEvent *)event{
    [super mouseDown:event];
    if(![self.editingDelegate isEditing]){
        [self setValue:1];
    }
}


-(void)mouseUp:(NSEvent *)event{
    [super mouseUp:event];
    if(![self.editingDelegate isEditing])
        [self setValue:0];
}

-(void)setColor:(NSColor *)color{
    [super setColor:color];
    self.layer.backgroundColor=[MMPControl CGColorFromNSColor:color];
}

-(void)setValue:(int)inVal{
	_value=inVal;
    
    if(self.value==1)self.layer.backgroundColor=[MMPControl CGColorFromNSColor:self.highlightColor];
    else self.layer.backgroundColor=[MMPControl CGColorFromNSColor:self.color];
	 
	//send out message
    NSMutableArray* formattedMessageArray = [[NSMutableArray alloc]init];
    [formattedMessageArray addObject:self.address];
    [formattedMessageArray  addObject:[[NSMutableString alloc]initWithString:@"i"]];//tags
    [formattedMessageArray addObject:[NSNumber numberWithInt:self.value]];
    [self.editingDelegate sendFormattedMessageArray:formattedMessageArray];
}

//receive messages from PureData (via [send toGUI], routed through the PdWrapper.pd patch), routed from Document via the address to this object
//for button, any message means a instantaneous touch down and touch up
//it does not respond to "set" anything
-(void)receiveList:(NSArray *)inArray{
    if ([inArray count]>0 && [[inArray objectAtIndex:0] isKindOfClass:[NSNumber class]]){
        //[self setValue:(int)[(NSNumber*)[inArray objectAtIndex:0] floatValue]];
        [self setValue:1];
        [self setValue:0];
    }
}





@end
