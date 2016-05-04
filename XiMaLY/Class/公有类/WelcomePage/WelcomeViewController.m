//
//  WelcomeViewController.m
//  LiangCeApp
//
//  Created by YunHan on 9/24/15.
//  Copyright (c) 2015 YunHan. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeImageView.h"

#import "AppDelegate.h"

@interface WelcomeViewController () <WelcomeImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;

@property (nonatomic, retain) NSArray *welImageArray;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Step 1: make the outer paging scroll view
    self.scrollView.contentSize = [self _scrollViewContentSize];
    
    self.pageControl.hidden = YES;
    
    // Step 2: prepare to tile content
    _recycledPages = [[NSMutableSet alloc] init];
    _visiblePages  = [[NSMutableSet alloc] init];
    
    self.welImageArray = @[@"welcome001.jpg", @"welcome002.jpg", @"welcome003.jpg"];
    
//    [self tilePages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pageControl.numberOfPages = [self _pageCount];
    
    self.scrollView.contentSize = [self _scrollViewContentSize];
    
    [self tilePages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Methods
- (void)tilePages
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1)/CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, (int)([self _pageCount]-1));
    
    // Recycle no-longer-visible pages
    for (WelcomeImageView *page in _visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [_recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [_visiblePages minusSet:_recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            WelcomeImageView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[WelcomeImageView alloc] init];
                page.delegate = self;
            }
            [self configurePage:page forIndex:index];
            [self.scrollView addSubview:page];
            [_visiblePages addObject:page];
        }
        
        self.pageControl.currentPage = index;
    }
}

- (WelcomeImageView *)dequeueRecycledPage
{
    WelcomeImageView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (WelcomeImageView *page in _visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(WelcomeImageView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    page.backgroundColor = [UIColor blueColor];
    
    UIImage *img = [self imageAtIndex:index];
    [page displayImage:img];
}

#define PADDING 0
- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = self.scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGRect)_scrollViewFrame
{
    return CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGSize)_scrollViewContentSize
{
    return CGSizeMake(self.scrollView.bounds.size.width*[self.welImageArray count], self.scrollView.bounds.size.height);
}

#define PAGE_IND_VIEW_HEIGHT    20.0

- (NSInteger)_pageCount
{
    return [self.welImageArray count];
}

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    if (index < [self _pageCount]) {
        NSString *imgName = [self.welImageArray objectAtIndex:index];
        if ([NSNull null] != (NSNull *)imgName) {
            UIImage * img = [UIImage imageNamed:imgName];
            return img;
        }
    }
    
    return nil;
}

#pragma mark - -- UIScrollView Delegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

#pragma mark -
- (void)enterToHomeViewController:(id)sender
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    [appDel welcomeEntryToHome];
}

@end
