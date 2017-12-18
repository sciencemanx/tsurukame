#import <Foundation/Foundation.h>

#import "Client.h"
#import "Reachability.h"
#import "proto/Wanikani.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^StudyMaterialHandler)(WKStudyMaterials * _Nullable);

extern NSNotificationName kLocalCachingClientBusyChangedNotification;
extern NSNotificationName kLocalCachingClientBusyChangedNotification;

@protocol LocalCachingClientDelegate

- (void)localCachingClientDidReportError:(NSError *)error;

@end

@interface LocalCachingClient : NSObject

@property(nonatomic, getter=isBusy, readonly) bool busy;
@property(nonatomic) id<LocalCachingClientDelegate> delegate;

- (instancetype)initWithClient:(Client *)client
                  reachability:(Reachability *)reachability NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)update;

- (void)getAllAssignments:(AssignmentHandler)handler;
- (void)getStudyMaterialForID:(int)subjectID handler:(StudyMaterialHandler)handler;
- (void)sendProgress:(NSArray<WKProgress *> *)progress
             handler:(ProgressHandler)handler;

@end

NS_ASSUME_NONNULL_END