//
//  GCRemoteView.h
//
//  Created by Rex Sheng on 4/26/13.
//  Copyright (c) 2013 Rex Sheng

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@class GCRemoteView;

#pragma mark - GCRemoteView

@protocol GCRemoteViewDelegate;

@interface GCRemoteView : UICollectionView <UICollectionViewDelegate, NSCoding>

@property (nonatomic, strong) NSString *servicePath;
@property (nonatomic, strong) NSString *resourcePath;

@property (nonatomic, readonly) NSUInteger currentPage;
@property (nonatomic, readonly) BOOL reachesEnd;

@property (nonatomic, strong, readonly) NSDate *lastUpdate;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, readonly) BOOL loading;

@property (nonatomic, weak) UINavigationController *scrollsAffectNavigationController;
@property (nonatomic, weak) id<GCRemoteViewDelegate> remoteDelegate;
@property (nonatomic, weak) AFHTTPClient *client;

- (void)saveToCacheFile:(NSString *)name;
- (BOOL)loadFromCacheFile:(NSString *)name withinTime:(NSTimeInterval)interval;
- (void)reloadRemoteData:(BOOL)force;
// subclasses should use this method for pagination feature
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/** Subclasses should override this method. */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (void)setDataSourceReady;

@end


#pragma mark - Delegate Protocols

@protocol GCRemoteViewDelegate <NSObject>

@optional
- (NSDictionary *)remoteView:(GCRemoteView *)remoteView serviceParameterForPage:(NSUInteger)page;

- (BOOL)remoteViewShouldStartLoading:(GCRemoteView *)remoteView;

- (void)remoteView:(GCRemoteView *)remoteView didLoadResponse:(id)response forPage:(NSUInteger)page;
- (void)remoteView:(GCRemoteView *)remoteView didLoadWithError:(NSError *)error forPage:(NSUInteger)page;

- (id)remoteView:(GCRemoteView *)remoteView itemFromDictionary:(NSDictionary *)JSON;

- (NSArray *)remoteView:(GCRemoteView *)remoteView itemsForRemoteItems:(NSArray *)items forPage:(NSUInteger)page;

@end
