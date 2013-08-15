// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPFavorite.m instead.

#import "_YPFavorite.h"

const struct YPFavoriteAttributes YPFavoriteAttributes = {
	.keyword = @"keyword",
};

const struct YPFavoriteRelationships YPFavoriteRelationships = {
};

const struct YPFavoriteFetchedProperties YPFavoriteFetchedProperties = {
};

@implementation YPFavoriteID
@end

@implementation _YPFavorite

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Favorite";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:moc_];
}

- (YPFavoriteID*)objectID {
	return (YPFavoriteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic keyword;











@end
