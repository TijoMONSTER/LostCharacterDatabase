//
//  LostCharacterTableViewCell.m
//  LostCharacterDatabase
//
//  Created by Iván Mervich on 8/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "LostCharacterTableViewCell.h"

@interface LostCharacterTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerLabel;
@property (weak, nonatomic) IBOutlet UILabel *hairColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *planeSeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation LostCharacterTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActor:(NSString *)actor passenger:(NSString *)passenger hairColor:(NSString *)hairColor planeSeat:(NSNumber *)planeSeat age:(NSNumber *)age
{
	self.actorLabel.text = actor;
	self.passengerLabel.text = passenger;
	self.hairColorLabel.text = hairColor;
	self.planeSeatLabel.text = [NSString stringWithFormat:@"%@", planeSeat];
	self.ageLabel.text = [NSString stringWithFormat:@"%@", age];
}

@end
