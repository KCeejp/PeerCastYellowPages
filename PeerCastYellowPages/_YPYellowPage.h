// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPYellowPage.h instead.

#import <CoreData/CoreData.h>


extern const struct YPYellowPageAttributes {
	__unsafe_unretained NSString *indexDotTxtURL;
	__unsafe_unretained NSString *name;
} YPYellowPageAttributes;

extern const struct YPYellowPageRelationships {
} YPYellowPageRelationships;

extern const struct YPYellowPageFetchedProperties {
} YPYellowPageFetchedProperties;





@interface YPYellowPageID : NSManagedObjectID {}
@end

@interface _YPYellowPage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (YPYellowPageID*)objectID;





@property (nonatomic, strong) NSString* indexDotTxtURL;



//- (BOOL)validateIndexDotTxtURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _YPYellowPage (CoreDataGeneratedAccessors)

@end

@interface _YPYellowPage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveIndexDotTxtURL;
- (void)setPrimitiveIndexDotTxtURL:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
