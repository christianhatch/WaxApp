//
//  TagObject.h
//  Wax
//
//  Created by Christian Hatch on 6/21/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@interface TagObject : ModelObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSNumber *totalCount;

@end
