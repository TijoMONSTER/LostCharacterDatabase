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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	LostCharacter *character = self.lostCharacters[indexPath.row];
	cell.textLabel.text = character.passenger;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Actor: %@", character.actor];

	return cell;
}

#pragma mark - Segues

- (IBAction)unwindFromAddCharacterViewController:(UIStoryboardSegue *)segue
{
	AddCharacterViewController *addCharacterViewController = (AddCharacterViewController *)segue.sourceViewController;

	NSString *passengerToAdd = [addCharacterViewController passengerToAdd];
	NSString *actorToAdd = [addCharacterViewController actorToAdd];

	[self insertNewCharacterWithPassenger:passengerToAdd actor:actorToAdd];
	[self saveManagedObject];
}

#pragma mark - Helper methods

- (void)insertNewCharacterWithPassenger:(NSString *)passenger actor:(NSString *)actor
{
	LostCharacter *character = [NSEntityDescription insertNewObjectForEntityForName:lostCharacterEntityName inManagedObjectContext:self.managedObjectContext];
	character.passenger = passenger;
	character.actor = actor;
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
		[self insertNewCharacterWithPassenger:characterDictionary[@"passenger"] actor:characterDictionary[@"actor"]];
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
