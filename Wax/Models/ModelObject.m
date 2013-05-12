//
//  ModelObject.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@implementation ModelObject

-(id)initWithDictionary:(NSDictionary *)dictionary{
    //override in subclasses
    return nil; 
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    //override in subclasses
    return nil; 
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //override in subclasses
}



@end
