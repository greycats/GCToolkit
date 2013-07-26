//
//  LNRemoteView.h
//
//  Created by Rex Sheng on 4/26/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@class LNRemoteView;

#pragma mark - LNRemoteView

@protocol LNRemoteViewDelegate;

@interface LNRemoteView : UICollectionView <UICollectionViewDelegate, NSCoding>

@property (nonatomic, strong) NSString *servicePath;
@property (nonatomic, strong) NSString *resourcePath;

@property (nonatomic, readonly) NSUInteger currentPage;
@property (nonatomic, readonly) BOOL reachesEnd;

@property (nonatomic, strong, readonly) NSDate *lastUpdate;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, readonly) BOOL loading;

@property (nonatomic, weak) UINavigationController *scrollsAffectNavigationController;
@property (nonatomic, weak) id<LNRemoteViewDelegate> remoteDelegate;
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

@protocol LNRemoteViewDelegate <NSObject>

@optional
- (NSDictionary *)remoteView:(LNRemoteView *)remoteView serviceParameterForPage:(NSUInteger)page;

- (BOOL)remoteViewShouldStartLoading:(LNRemoteView *)remoteView;

- (void)remoteView:(LNRemoteView *)remoteView didLoadResponse:(id)response forPage:(NSUInteger)page;
- (void)remoteView:(LNRemoteView *)remoteView didLoadWithError:(NSError *)error forPage:(NSUInteger)page;

- (id)remoteView:(LNRemoteView *)remoteView itemFromDictionary:(NSDictionary *)JSON;

- (NSArray *)remoteView:(LNRemoteView *)remoteView itemsForRemoteItems:(NSArray *)items forPage:(NSUInteger)page;

@end
