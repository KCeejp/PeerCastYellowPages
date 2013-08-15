// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPChannel.h instead.

#import <CoreData/CoreData.h>


extern const struct YPChannelAttributes {
	__unsafe_unretained NSString *bitrate;
	__unsafe_unretained NSString *comment;
	__unsafe_unretained NSString *contactURLString;
	__unsafe_unretained NSString *detail;
	__unsafe_unretained NSString *format;
	__unsafe_unretained NSString *genre;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *ipAddress;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *new;
	__unsafe_unretained NSString *port;
	__unsafe_unretained NSString *relayCount;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *viewerCount;
	__unsafe_unretained NSString *yellowPageURLString;
} YPChannelAttributes;

extern const struct YPChannelRelationships {
} YPChannelRelationships;

extern const struct YPChannelFetchedProperties {
} YPChannelFetchedProperties;


















@interface YPChannelID : NSManagedObjectID {}
@end

@interface _YPChannel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (YPChannelID*)objectID;





@property (nonatomic, strong) NSNumber* bitrate;



@property int64_t bitrateValue;
- (int64_t)bitrateValue;
- (void)setBitrateValue:(int64_t)value_;

//- (BOOL)validateBitrate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* comment;



//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contactURLString;



//- (BOOL)validateContactURLString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* detail;



//- (BOOL)validateDetail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* format;



//- (BOOL)validateFormat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* genre;



//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* identifier;



//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ipAddress;



//- (BOOL)validateIpAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* new;



@property BOOL newValue;
- (BOOL)newValue;
- (void)setNewValue:(BOOL)value_;

//- (BOOL)validateNew:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* port;



@property int64_t portValue;
- (int64_t)portValue;
- (void)setPortValue:(int64_t)value_;

//- (BOOL)validatePort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* relayCount;



@property int16_t relayCountValue;
- (int16_t)relayCountValue;
- (void)setRelayCountValue:(int16_t)value_;

//- (BOOL)validateRelayCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* status;



//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* viewerCount;



@property int64_t viewerCountValue;
- (int64_t)viewerCountValue;
- (void)setViewerCountValue:(int64_t)value_;

//- (BOOL)validateViewerCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* yellowPageURLString;



//- (BOOL)validateYellowPageURLString:(id*)value_ error:(NSError**)error_;






@end

@interface _YPChannel (CoreDataGeneratedAccessors)

@end

@interface _YPChannel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBitrate;
- (void)setPrimitiveBitrate:(NSNumber*)value;

- (int64_t)primitiveBitrateValue;
- (void)setPrimitiveBitrateValue:(int64_t)value_;




- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;




- (NSString*)primitiveContactURLString;
- (void)setPrimitiveContactURLString:(NSString*)value;




- (NSString*)primitiveDetail;
- (void)setPrimitiveDetail:(NSString*)value;




- (NSString*)primitiveFormat;
- (void)setPrimitiveFormat:(NSString*)value;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSString*)primitiveIpAddress;
- (void)setPrimitiveIpAddress:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveNew;
- (void)setPrimitiveNew:(NSNumber*)value;

- (BOOL)primitiveNewValue;
- (void)setPrimitiveNewValue:(BOOL)value_;




- (NSNumber*)primitivePort;
- (void)setPrimitivePort:(NSNumber*)value;

- (int64_t)primitivePortValue;
- (void)setPrimitivePortValue:(int64_t)value_;




- (NSNumber*)primitiveRelayCount;
- (void)setPrimitiveRelayCount:(NSNumber*)value;

- (int16_t)primitiveRelayCountValue;
- (void)setPrimitiveRelayCountValue:(int16_t)value_;




- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;




- (NSNumber*)primitiveViewerCount;
- (void)setPrimitiveViewerCount:(NSNumber*)value;

- (int64_t)primitiveViewerCountValue;
- (void)setPrimitiveViewerCountValue:(int64_t)value_;




- (NSString*)primitiveYellowPageURLString;
- (void)setPrimitiveYellowPageURLString:(NSString*)value;




@end
