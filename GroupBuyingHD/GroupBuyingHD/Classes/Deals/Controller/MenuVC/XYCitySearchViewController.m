//
//  XYCitySearchViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/5.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCitySearchViewController.h"

@interface XYCitySearchViewController ()
/**
 *  搜索结果城市数据
 */
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation XYCitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setSearchText:(NSString *)searchText{
    _searchText = [searchText copy];
    
    //全部的城市数据
    NSArray *cities = [XYMetaDataTool shareMateData].cities;
    
    searchText = searchText.lowercaseString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    self.resultCities = [cities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusedID = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    
    cell.textLabel.text = [self.resultCities[indexPath.row] name];
    
    return cell;
}

#pragma mark - Table view dalegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"共有%ld个搜索结果", self.resultCities.count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    XYCity *city = self.resultCities[indexPath.row];
    //发出通知
    [XYNotificationCenter postNotificationName:XYCityDidChangeNotification object:self userInfo:@{XYSelectedCity: city}];
}
@end
