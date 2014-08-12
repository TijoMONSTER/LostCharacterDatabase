//
//  MasterViewController.m
//  LostCharacterDatabase
//
//  Created by Iván Mervich on 8/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#define lostCharacterEntityName @"LostCharacter"
#define lostCharactersPlistName @"lost"

@interface MasterViewController ()

@property NSArray *lostCharacters;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self loadCharactersFromDB];
}

#pragma mark - Helper methods

- (void)loadCharactersFromPlist
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSURL *plistURL = [bundle URLForResource:lostCharactersPlistName withExtension:@"plist"];
	self.lostCharacters = [NSArray arrayWithContentsOfURL:plistURL];
}

- (void)loadCharactersFromDB
{
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:lostCharacterEntityName];

	NSError *fetchError;
	self.lostCharacters = [self.managedObjectContext executeFetchRequest:request error:&fetchError];

	if (fetchError) {
		[self showAlertViewWithTitle:@"Fetch error" message:fetchError.localizedDescription buttonText:@"OK"];
	}

	// db empty, load from plist
	if (self.lostCharacters.count == 0) {
		[self loadCharactersFromPlist];
	}
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText
{
	UIAlertView *alertView = [UIAlertView new];
	alertView.title = title;
	alertView.message = message;
	[alertView addButtonWithTitle:buttonText];
	[alertView show];
	NSLog(@"%@, %@", title, message);
}

@end
