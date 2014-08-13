//
//  MasterViewController.m
//  LostCharacterDatabase
//
//  Created by Iván Mervich on 8/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddCharacterViewController.h"
#import "LostCharacter.h"
#import "LostCharacterTableViewCell.h"

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

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.lostCharacters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LostCharacter *character = self.lostCharacters[indexPath.row];
	LostCharacterTableViewCell *cell = (LostCharacterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];

	[cell setActor:character.actor
		 passenger:character.passenger
		 hairColor:character.hair_color
		 planeSeat:character.plane_seat
			   age:character.age];

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		LostCharacter *character = self.lostCharacters[indexPath.row];
		[self.managedObjectContext deleteObject:character];
		[self saveManagedObject];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"SMOKE MONSTER";
}

#pragma mark - Segues

- (IBAction)unwindFromAddCharacterViewController:(UIStoryboardSegue *)segue
{
	AddCharacterViewController *addCharacterViewController = (AddCharacterViewController *)segue.sourceViewController;

	NSDictionary *characterToAdd = [addCharacterViewController characterToAdd];

	[self insertNewCharacterWithPassenger:characterToAdd[@"passenger"]
									actor:characterToAdd[@"actor"]
								hairColor:characterToAdd[@"hairColor"]
								planeSeat:characterToAdd[@"planeSeat"]
									  age:characterToAdd[@"age"]];
	[self saveManagedObject];
}

#pragma mark - Helper methods

- (void)insertNewCharacterWithPassenger:(NSString *)passenger actor:(NSString *)actor hairColor:(NSString *)hairColor planeSeat:(NSNumber *)planeSeat age:(NSNumber *)age
{
	LostCharacter *character = [NSEntityDescription insertNewObjectForEntityForName:lostCharacterEntityName inManagedObjectContext:self.managedObjectContext];
	character.passenger = passenger;
	character.actor = actor;
	character.hair_color = hairColor;
	character.plane_seat = planeSeat;
	character.age = age;

}

- (void)saveManagedObject
{
	NSError *saveError;
	[self.managedObjectContext save:&saveError];

	if (saveError) {
		[self showAlertViewWithTitle:@"Save error" message:saveError.localizedDescription buttonText:@"OK"];
	} else {
		// finally loaded, fetch again the results
		[self loadCharactersFromDB];
	}
}

- (void)loadCharactersFromPlist
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSURL *plistURL = [bundle URLForResource:lostCharactersPlistName withExtension:@"plist"];

	NSArray *plist = [NSArray arrayWithContentsOfURL:plistURL];

	// for each dictionary on the plist, create an entity on db
	for (NSDictionary *characterDictionary in plist) {
		[self insertNewCharacterWithPassenger:characterDictionary[@"passenger"]
										actor:characterDictionary[@"actor"]
									hairColor:@"I don't know"
									planeSeat:@1
										  age:@25];
	}

	[self saveManagedObject];
}

- (void)loadCharactersFromDB
{
	// sort by passenger
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:YES];
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:lostCharacterEntityName];
	request.sortDescriptors = @[sortDescriptor];

	NSError *fetchError;
	self.lostCharacters = [self.managedObjectContext executeFetchRequest:request error:&fetchError];

	if (fetchError) {
		[self showAlertViewWithTitle:@"Fetch error" message:fetchError.localizedDescription buttonText:@"OK"];
	}

	// db empty, load from plist
	if (self.lostCharacters.count == 0) {
		[self loadCharactersFromPlist];
	} else {
		//characters already set, show them on tableView
		[self.tableView reloadData];
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
