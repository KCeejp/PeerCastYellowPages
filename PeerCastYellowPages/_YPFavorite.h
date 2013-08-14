// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPFavorite.h instead.

#import <CoreData/CoreData.h>


extern const struct YPFavoriteAttributes {
	__unsafe_unretained NSString *keyword;
} YPFavoriteAttributes;

extern const struct YPFavoriteRelationships {
} YPFavoriteRelationships;

extern const struct YPFavoriteFetchedProperties {
} YPFavoriteFetchedProperties;




@interface YPFavoriteID : NSManagedObjectID {}
@end

@interface _YPFavorite : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (YPFavoriteID*)objectID;





@property (nonatomic, strong) NSString* keyword;



//- (BOOL)validateKeyword:(id*)value_ error:(NSError**)error_;






@end

@interface _YPFavorite (CoreDataGeneratedAccessors)

@end

@interface _YPFavorite (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKeyword;
- (void)setPrimitiveKeyword:(NSString*)value;




@end
