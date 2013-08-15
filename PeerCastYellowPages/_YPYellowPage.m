// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPYellowPage.m instead.

#import "_YPYellowPage.h"

const struct YPYellowPageAttributes YPYellowPageAttributes = {
	.indexDotTxtURLString = @"indexDotTxtURLString",
	.name = @"name",
};

const struct YPYellowPageRelationships YPYellowPageRelationships = {
};

const struct YPYellowPageFetchedProperties YPYellowPageFetchedProperties = {
};

@implementation YPYellowPageID
@end

@implementation _YPYellowPage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"YellowPage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"YellowPage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"YellowPage" inManagedObjectContext:moc_];
}

- (YPYellowPageID*)objectID {
	return (YPYellowPageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic indexDotTxtURLString;






@dynamic name;











@end
