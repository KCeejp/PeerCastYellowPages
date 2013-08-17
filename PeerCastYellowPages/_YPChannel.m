// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YPChannel.m instead.

#import "_YPChannel.h"

const struct YPChannelAttributes YPChannelAttributes = {
	.bitrate = @"bitrate",
	.comment = @"comment",
	.contactURLString = @"contactURLString",
	.detail = @"detail",
	.format = @"format",
	.genre = @"genre",
	.identifier = @"identifier",
	.ipAddress = @"ipAddress",
	.name = @"name",
	.new = @"new",
	.port = @"port",
	.relayCount = @"relayCount",
	.status = @"status",
	.viewerCount = @"viewerCount",
	.yellowPageURLString = @"yellowPageURLString",
};

const struct YPChannelRelationships YPChannelRelationships = {
};

const struct YPChannelFetchedProperties YPChannelFetchedProperties = {
};

@implementation YPChannelID
@end

@implementation _YPChannel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Channel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Channel" inManagedObjectContext:moc_];
}

- (YPChannelID*)objectID {
	return (YPChannelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"bitrateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bitrate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"newValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"new"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"portValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"port"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"relayCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"relayCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"viewerCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"viewerCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bitrate;



- (int16_t)bitrateValue {
	NSNumber *result = [self bitrate];
	return [result shortValue];
}

- (void)setBitrateValue:(int16_t)value_ {
	[self setBitrate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBitrateValue {
	NSNumber *result = [self primitiveBitrate];
	return [result shortValue];
}

- (void)setPrimitiveBitrateValue:(int16_t)value_ {
	[self setPrimitiveBitrate:[NSNumber numberWithShort:value_]];
}





@dynamic comment;






@dynamic contactURLString;






@dynamic detail;






@dynamic format;






@dynamic genre;






@dynamic identifier;






@dynamic ipAddress;






@dynamic name;






@dynamic new;



- (BOOL)newValue {
	NSNumber *result = [self new];
	return [result boolValue];
}

- (void)setNewValue:(BOOL)value_ {
	[self setNew:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveNewValue {
	NSNumber *result = [self primitiveNew];
	return [result boolValue];
}

- (void)setPrimitiveNewValue:(BOOL)value_ {
	[self setPrimitiveNew:[NSNumber numberWithBool:value_]];
}





@dynamic port;



- (int16_t)portValue {
	NSNumber *result = [self port];
	return [result shortValue];
}

- (void)setPortValue:(int16_t)value_ {
	[self setPort:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePortValue {
	NSNumber *result = [self primitivePort];
	return [result shortValue];
}

- (void)setPrimitivePortValue:(int16_t)value_ {
	[self setPrimitivePort:[NSNumber numberWithShort:value_]];
}





@dynamic relayCount;



- (int16_t)relayCountValue {
	NSNumber *result = [self relayCount];
	return [result shortValue];
}

- (void)setRelayCountValue:(int16_t)value_ {
	[self setRelayCount:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRelayCountValue {
	NSNumber *result = [self primitiveRelayCount];
	return [result shortValue];
}

- (void)setPrimitiveRelayCountValue:(int16_t)value_ {
	[self setPrimitiveRelayCount:[NSNumber numberWithShort:value_]];
}





@dynamic status;






@dynamic viewerCount;



- (int16_t)viewerCountValue {
	NSNumber *result = [self viewerCount];
	return [result shortValue];
}

- (void)setViewerCountValue:(int16_t)value_ {
	[self setViewerCount:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveViewerCountValue {
	NSNumber *result = [self primitiveViewerCount];
	return [result shortValue];
}

- (void)setPrimitiveViewerCountValue:(int16_t)value_ {
	[self setPrimitiveViewerCount:[NSNumber numberWithShort:value_]];
}





@dynamic yellowPageURLString;











@end
