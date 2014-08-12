//
//  LostCharacter.h
//  LostCharacterDatabase
//
//  Created by Iván Mervich on 8/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LostCharacter : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * passenger;
@property (nonatomic, retain) NSString * hair_color;
@property (nonatomic, retain) NSNumber * plane_seat;
@property (nonatomic, retain) NSNumber * age;

@end
