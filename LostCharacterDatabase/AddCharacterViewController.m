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

- (NSString *)passengerToAdd
{
	if (self.passengerTextField.text.length > 0) {
		return self.passengerTextField.text;
	}
	return nil;
}

- (NSString *)actorToAdd
{
	if (self.actorTextField.text.length > 0) {
		return self.actorTextField.text;
	}
	return nil;
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
		if (self.passengerTextField.text.length > 0 || self.actorTextField.text.length > 0) {
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
