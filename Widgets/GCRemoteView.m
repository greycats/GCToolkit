//
//  GCRemoteView.m
//
//  Created by Rex Sheng on 4/26/13.
//  Copyright (c) 2013 Rex Sheng

#import "GCRemoteView.h"

@implementation GCRemoteView
{
	CGFloat lastContentOffset, startContentOffset;
	NSDate *_lastLoadDate;
	NSUInteger _currentPage;
	@package
	UIActivityIndicatorView *spinner;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
		self.showsVerticalScrollIndicator = NO;
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		_resourcePath = @"items";
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.hidesWhenStopped = YES;
		spinner.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 20);
		[self addSubview:spinner];
	}
	return self;
}

- (void)setLoading:(BOOL)loading
{
	_loading = loading;
	if (_loading) {
		[spinner startAnimating];
	} else {
		[spinner stopAnimating];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (_loading) return;
	startContentOffset = lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat currentOffset = scrollView.contentOffset.y;
	spinner.center = CGPointMake(spinner.center.x, scrollView.contentSize.height - 20);
	if (currentOffset < 44) {
		[self.scrollsAffectNavigationController setNavigationBarHidden:NO animated:YES];
		return;
	}
	
	CGFloat differenceFromStart = startContentOffset - currentOffset;
	CGFloat differenceFromLast = lastContentOffset - currentOffset;
	lastContentOffset = currentOffset;
	
	if ((differenceFromStart) < 0) {
		if(scrollView.isTracking && (abs(differenceFromLast) > 1.5)) {
			[self.scrollsAffectNavigationController setNavigationBarHidden:YES animated:YES];
		}
	} else {
		if(scrollView.isTracking && (abs(differenceFromLast) > 2.0)) {
			[self.scrollsAffectNavigationController setNavigationBarHidden:NO animated:YES];
		}
	}
}

- (void)setServicePath:(NSString *)servicePath
{
	_servicePath = servicePath;
	[self reloadRemoteData:YES];
}

- (void)saveToCacheFile:(NSString *)name
{
	if (self.loading || !name) return;
	NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	if (tempDir) {
		NSMutableData *data = [NSMutableData dataWithCapacity:20000];
		NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[coder encodeBool:_reachesEnd forKey:@"R"];
		[coder encodeObject:_servicePath forKey:@"S"];
		[coder encodeInteger:_currentPage forKey:@"C"];
		[coder encodeObject:_items forKey:@"I"];
		[coder encodeObject:_lastLoadDate forKey:@"D"];
		[coder finishEncoding];
		[data writeToFile:[tempDir stringByAppendingPathComponent:name] atomically:YES];
	}
}

- (BOOL)loadFromCacheFile:(NSString *)name withinTime:(NSTimeInterval)interval
{
	NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	if (tempDir) {
		NSData *data = [NSData dataWithContentsOfFile:[tempDir stringByAppendingPathComponent:name]];
		if (data) {
			NSKeyedUnarchiver *coder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			_reachesEnd = [coder decodeBoolForKey:@"R"];
			_servicePath = [coder decodeObjectForKey:@"S"];
			_currentPage = [coder decodeIntegerForKey:@"C"];
			NSArray *items = [coder decodeObjectForKey:@"I"];
			NSDate *lastLoadDate = [coder decodeObjectForKey:@"D"];
			[coder finishDecoding];
			if (![GCRemoteView items:items isStaleForTimeInterval:interval sinceLastLoadDate:lastLoadDate]) {
				self.loading = NO;
				NSLog(@"hit cache of %d items of page '%@' on %@", items.count, name, lastLoadDate);
				[UIView animateWithDuration:.25 animations:^{
					self.alpha = items.count > 0;
				}];
				_items = items;
				_lastLoadDate = lastLoadDate;
				[self setDataSourceReady];
				[self reloadData];
				return YES;
			}
			self.loading = YES;
			_items = @[];
		}
	}
	return NO;
}

- (void)setDataSourceReady
{
}

- (void)reloadRemoteData:(BOOL)force
{
	[self setDataSourceReady];
	self.loading = YES;
	if (force)
		[UIView animateWithDuration:.25 animations:^{
			self.alpha = 0;
		}];
	dispatch_async(dispatch_get_main_queue(), ^{
		_currentPage = 1;
		[self requestData:force];
	});
}

+ (BOOL)items:(NSArray *)items isStaleForTimeInterval:(NSTimeInterval)interval sinceLastLoadDate:(NSDate *)lastLoadDate
{
	if (interval == 0) return NO;
	return !lastLoadDate || !items.count || [[NSDate date] timeIntervalSinceDate:lastLoadDate] > interval;
}

- (NSDictionary *)parametersForPage:(NSUInteger)page
{
	return @{ @"page_size" : @20, @"page" : @(_currentPage) };
}

- (void)requestData:(BOOL)force
{
	_lastLoadDate = [NSDate date];
	if ([self.remoteDelegate respondsToSelector:@selector(remoteViewShouldStartLoading:)]) {
		if (![self.remoteDelegate remoteViewShouldStartLoading:self]) {
			self.loading = NO;
			_reachesEnd = YES;
			return;
		}
	}
	
	if (_currentPage == 1) {
		_reachesEnd = NO;
	}
	NSDictionary *parameters = [self parametersForPage:_currentPage];
	if ([self.remoteDelegate respondsToSelector:@selector(remoteView:serviceParameterForPage:)]) {
		NSMutableDictionary *mParam = [parameters mutableCopy];
		[mParam setValuesForKeysWithDictionary:[self.remoteDelegate remoteView:self serviceParameterForPage:_currentPage]];
		parameters = mParam;
	}
	[self.client getPath:_servicePath parameters:parameters success:^(AFHTTPRequestOperation *request, NSDictionary *response) {
		if ([self.remoteDelegate respondsToSelector:@selector(remoteView:didLoadResponse:forPage:)]) {
			[self.remoteDelegate remoteView:self didLoadResponse:response forPage:_currentPage];
		}
		
		NSArray *items = [[NSMutableArray alloc] init];
		for (NSDictionary *item in response[_resourcePath]) {
			id entry;
			if ([self.remoteDelegate respondsToSelector:@selector(remoteView:itemFromDictionary:)]) {
				entry = [self.remoteDelegate remoteView:self itemFromDictionary:item];
			}
			if (entry) {
				[(NSMutableArray *)items addObject:entry];
			}
		}
		if (!items.count) {
			_reachesEnd = YES;
		}
		if ([self.remoteDelegate respondsToSelector:@selector(remoteView:itemsForRemoteItems:forPage:)]) {
			items = [self.remoteDelegate remoteView:self itemsForRemoteItems:items forPage:_currentPage];
		}
		if (_currentPage == 1) {
			_items = items;
		} else if (_items.count) {
			_items = [_items arrayByAddingObjectsFromArray:items];
		}
		[self reloadData];
		[UIView animateWithDuration:.25 animations:^{
			self.alpha = _items.count > 0;
		}];
		self.loading = NO;
		if ([self.remoteDelegate respondsToSelector:@selector(remoteView:didLoadWithError:forPage:)]) {
			[self.remoteDelegate remoteView:self didLoadWithError:nil forPage:_currentPage];
		}
	} failure:^(AFHTTPRequestOperation *request, NSError *error) {
		self.loading = NO;
		NSUInteger oldPage = _currentPage;
		if (_currentPage > 1) {
			_currentPage--;
		}
		if ([self.remoteDelegate respondsToSelector:@selector(remoteView:didLoadWithError:forPage:)]) {
			[self.remoteDelegate remoteView:self didLoadWithError:error forPage:oldPage];
		}
	}];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row >= self.items.count) {
		return nil;
	}

	id object = self.items[indexPath.row];
    if (!self.loading && !_reachesEnd && (indexPath.row >= (NSInteger)_items.count - 8)) {
		self.loading = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentPage++;
            [self requestData:NO];
        });
	}
	return object;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.items.count;
}

@end