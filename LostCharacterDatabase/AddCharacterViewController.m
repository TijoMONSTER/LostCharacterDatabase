//
//  AddCharacterViewController.m
//  LostCharacterDatabase
//
//  Created by Iván Mervich on 8/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "AddCharacterViewController.h"

@interface AddCharacterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passengerTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UITextField *hairColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *planeSeatTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation AddCharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationItem.hidesBackButton = YES;
}

- (NSDictionary *)characterToAdd
{
	NSNumber *planeSeat = [NSNumber numberWithInt:[self.planeSeatTextField.text intValue]];
	NSNumber *age = [NSNumber numberWithInt:[self.ageTextField.text intValue]];

	NSDictionary *character = @{@"passenger": self.passengerTextField.text,
								@"actor": self.actorTextField.text,
								@"hairColor": self.hairColorTextField.text,
								@"planeSeat": planeSeat,
								@"age": age};
	return character;
}

#pragma mark - IBActions

- (IBAction)onTextFieldEndOnExit:(UITextField *)sender
{
	[sender resignFirstResponder];
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"unwindFromAddCharacterViewControllerSegue"]) {

		if (self.passengerTextField.text.length > 0 &&
			self.actorTextField.text.length > 0 &&
			self.hairColorTextField.text.length > 0 &&
			self.planeSeatTextField.text.length > 0 && [self.planeSeatTextField.text intValue] > 0 &&
			self.ageTextField.text.length > 0 && [self.ageTextField.text intValue] > 0) {
			return YES;
		} else {
			UIAlertView *alertView = [UIAlertView new];
			alertView.message = @"Fields must not be empty.";
			[alertView addButtonWithTitle:@"OK"];
			[alertView show];
		}
	}
	return NO;
}

@end
