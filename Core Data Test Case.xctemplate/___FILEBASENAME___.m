//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Test cases for ___FILEBASENAMEASIDENTIFIER___.
//  Setup will instantiate an instance from the storyboard.
//
//  Instructions: modify setup to match the names of your storyboard and vc.
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CoreData;

@interface ___FILEBASENAMEASIDENTIFIER___ : XCTestCase

@property   (nonatomic, strong) NSPersistentStoreCoordinator    *coordinator;

@end

@implementation ___FILEBASENAMEASIDENTIFIER___
@synthesize coordinator;

- (void)setUp {
	NSError                         *error                          = nil;
	NSManagedObjectModel            *managedObjectModel             = nil;
	NSPersistentStoreCoordinator    *persistentStoreCoordinator     = nil;

	[super setUp];

	// Create a managed object model from the test bundle.
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]] ];
	persistentStoreCoordinator  = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

	// Register a custom store class.
	if ([self storeClass] != nil){
		[[persistentStoreCoordinator class] registerStoreClass:[self storeClass] forStoreType:[self storeType]];
	}
	
	[self setCoordinator:persistentStoreCoordinator];
	// Add the store to the coordinator
    // Note that in many cases, a test should also remove any previously created file at the storeURL location.
	// Doing so should work as follows:
	// [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:&error];
	if (![[self coordinator] addPersistentStoreWithType:[self storeType] configuration:nil URL:[self storeURL] options:[self storeOptions] error:&error]){
	    XCTFail(@"Could not add store, %@", error);
	}
}

- (void)tearDown {
	NSPersistentStore   *store  = nil;
	NSError             *error  = nil;

	store = [[self coordinator] persistentStoreForURL:[self storeURL]];
	// Remove the store from the coordinator. If this fails that is fine.
	[[self coordinator] removePersistentStore:store error:&error];
	// Note that in many cases, a test should also remove any file created at the storeURL location.
	// Doing so should work as follows:
	// [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:&error];
	// Unregister the store
	if ([self storeClass] != nil){
		[[[self coordinator] class] registerStoreClass:nil forStoreType:[self storeType]];
	}

	[super tearDown];
}

- (NSURL *)storeURL {
	[NSException raise:NSInvalidArgumentException format:@"[%@ %@]: Test case classes should implement this method, returning the URL to the store data.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
	return nil;
}

- (NSString *)storeType {
	[NSException raise:NSInvalidArgumentException format:@"[%@ %@]: Test case classes should implement this method, returning the store type to use.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
	return nil;
}

- (Class )storeClass {
	// Only override if you are testing a custom store, such as an NSAtomicStore or NSIncrementalStore
	return nil;
}

- (NSDictionary *)storeOptions {
	return nil;
}

- (void)testFetchDoesNotThrowException {
	NSManagedObjectContext  *context        = nil;
	NSError                 *error          = nil;
	NSPredicate             *predicate      = nil;
	NSEntityDescription	*entity		= nil;
	NSFetchRequest          *fetchRequest   = nil;
	
	// Note that in a production application you should not use NSConfinementConcurrencyType. 
	context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
	[context setPersistentStoreCoordinator:[self coordinator]];

	entity = [[[[context persistentStoreCoordinator] managedObjectModel] entities] lastObject];
	fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[entity name]];
	// A nil predicate will return everything.
	[fetchRequest setPredicate:predicate];

	// The objective for this test is to perform a fetch without throwing an exception.
	XCTAssertNoThrow([context executeFetchRequest:fetchRequest error:&error], @"Fetch threw exception.");
}

@end