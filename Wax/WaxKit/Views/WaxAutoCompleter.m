//
//  WaxAutoCompleter.m
//  Kiwi
//
//  Created by Christian Hatch on 12/30/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "WaxAutoCompleter.h"
#import "UIScrollView+SVInfiniteScrolling.h"


@interface WaxAutoCompleter ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic) CHAutoCompleteSourceType sourceType;
@property (nonatomic, strong) UIActivityIndicatorView *loading;

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *hashtagsArray;

@end

@implementation WaxAutoCompleter
@synthesize textView, searchTerm = _searchTerm, usersArray, hashtagsArray, loading = _loading, sourceType = _sourceType;

-(id)initWithFrame:(CGRect)frame textView:(UITextView *)atextView{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.textView = atextView;
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.rowHeight = 49;
        [self fadeOut]; 
    }
    return self;
}
#pragma mark - DataSource Methods
-(void)refresh{
    [self showLoading];
    switch (self.sourceType) {
        case CHAutoCompleteSourceTypeUsers:{
            [self addObserver:self forKeyPath:kUsersArray options:NSKeyValueObservingOptionNew context:nil]; 
//            [[WaxAPIClient sharedClient] searchUsersWithUsername:[[self.searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sender:self];
        }break;
        case CHAutoCompleteSourceTypeHashTags:{
            [self addObserver:self forKeyPath:kHashTagsArray options:NSKeyValueObservingOptionNew context:nil];
//            [[WaxAPIClient sharedClient] searchTagsWithTag:[[self.searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sender:self];
        }break;
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kUsersArray]) {
        [self removeObserver:self forKeyPath:kUsersArray];
        [self doneLoading];
        if (self.usersArray.count > 0) {
            [self reloadData];
            [self showOptionsView]; 
        }else{
            [self hideOptionsView];
        }
    }else if ([keyPath isEqualToString:kHashTagsArray]){
        [self removeObserver:self forKeyPath:kHashTagsArray];
        [self doneLoading];
        if (self.hashtagsArray.count > 0) {
            [self reloadData];
            [self showOptionsView];
        }else{
            [self hideOptionsView];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; 
    }
}
#pragma mark - View Methods
-(void)showOptionsView{
    [self fadeIn];
}
-(void)hideOptionsView{
    [self fadeOut];
}
-(void)showLoading{
    [self.loading startAnimating]; 
}
-(void)doneLoading{
    [self.loading stopAnimating]; 
}
#pragma mark - Setters and Getters
-(UIActivityIndicatorView *)loading{
    if (!_loading) {
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loading.center = self.center;
        _loading.hidesWhenStopped = YES; 
        [self addSubview:_loading]; 
    }
    return _loading; 
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.sourceType) {
        case CHAutoCompleteSourceTypeUsers:{
            return self.usersArray.count;
        }break;
        case CHAutoCompleteSourceTypeHashTags:{
            return self.hashtagsArray.count;
        }break;
        default:{
            return 0; 
        }break; 
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.sourceType) {
        case CHAutoCompleteSourceTypeUsers:{
            static NSString *CellIdentifier = @"AutoCompletePersonCell";
//            PersonCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
            UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:@"PeopleCellNib" owner:self options:nil];
//                cell = [topObjects objectAtIndexNotNull:0];
//            }
//            cell.cellType = KWPersonCellTypeAutoComplete; 
//            cell.cellItem = [self.usersArray objectAtIndexNotNull:indexPath.row];
//            cell.accessoryType = UITableViewCellAccessoryNone; 
            return cell;
        }break;
        case CHAutoCompleteSourceTypeHashTags:{
            static NSString *CellIdentifier = @"AutoCompleteHashTagCell";
            UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.frame = CGRectMake(0, 0, self.bounds.size.width, 49); 
            }
            cell.textLabel.text = [[self.hashtagsArray objectAtIndexOrNil:indexPath.row] objectForKeyOrNil:@"tag"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }break;
        default:{
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
        }break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        switch (self.sourceType) {
            case CHAutoCompleteSourceTypeUsers:{
                PersonObject *person = [self.usersArray objectAtIndexOrNil:indexPath.row];
                [self.textView setText:[self.textView.text stringByReplacingOccurrencesOfString:self.searchTerm withString:[NSString stringWithFormat:@"@%@", person.username]]];
            }break;
            case CHAutoCompleteSourceTypeHashTags:{
                [self.textView setText:[self.textView.text stringByReplacingOccurrencesOfString:self.searchTerm withString:[[self.hashtagsArray objectAtIndexOrNil:indexPath.row] objectForKeyOrNil:@"tag"]]];
            }break;
        }
    }
    @catch (NSException *exception) {
        [AIKErrorManager logExceptionWithMessage:@"WaxAutoCompleter selected row and CAUGHT EXCEPTION" exception:exception]; 
    }
    [self hideOptionsView];
}
#pragma mark - Public API
-(void)searchAutoCompleteWithString:(NSString *)string{
    if (![NSString isEmptyOrNil:string]){
        NSString *word = [[string componentsSeparatedByString:@" "] lastObject];
        if ([word hasPrefix:@"@"] && ![word isEqualToString:@"@"]) {
            self.searchTerm = word;
            self.sourceType = CHAutoCompleteSourceTypeUsers;
            [self refresh]; 
        }else if ([word hasPrefix:@"#"] && ![word isEqualToString:@"#"]){
            self.searchTerm = word;
            self.sourceType = CHAutoCompleteSourceTypeHashTags;
            [self refresh]; 
        }else{
            [self hideOptionsView];
        }
    }else{
        [self hideOptionsView];
    }
}
-(BOOL)isShowing{
    return self.alpha > 0; 
}
@end
