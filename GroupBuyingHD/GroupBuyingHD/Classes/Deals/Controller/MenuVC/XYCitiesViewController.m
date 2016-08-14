//
//  XYCitiesViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/4.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCitiesViewController.h"
#import "XYCityGroup.h"
#import "XYCitySearchViewController.h"
#import "XYCity.h"

@interface XYCitiesViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavConstraint;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
/**
 *  存放全部的城市组
 */
@property (nonatomic, strong) NSArray *cityGroups;
/**
 *  城市搜索结果表格
 */
@property (nonatomic, strong) XYCitySearchViewController *citySearchVC;

- (IBAction)dismissBtnClick;
- (IBAction)coverClick;

@end

@implementation XYCitiesViewController

#pragma mark - 懒加载
- (XYCitySearchViewController *)citySearchVC{
    if (!_citySearchVC) {
        _citySearchVC = [[XYCitySearchViewController alloc] init];
        [self addChildViewController:_citySearchVC];
    }
    
    return _citySearchVC;
}
- (NSArray *)cityGroups{
    if (!_cityGroups) {
        _cityGroups = [XYMetaDataTool shareMateData].cityGroups;
    }
    return _cityGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - UISearchBarDelegate
//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //更换背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    //取消按钮展示
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //隐藏导航栏
    self.topNavConstraint.constant = -62;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsDisplay];
        self.coverBtn.alpha = 0.4;
    }];
    
    
}
//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //更换背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    //取消按钮隐藏
    [searchBar setShowsCancelButton:NO animated:YES];
    //显示导航栏
    self.topNavConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsDisplay];
        self.coverBtn.alpha = 0.0;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.citySearchVC.view removeFromSuperview];
    
    if (searchText.length > 0) {
        [self.view addSubview:self.citySearchVC.view];
        //约束
        [self.citySearchVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar];
        //传递搜索条件
        self.citySearchVC.searchText = searchText;
    }
}


- (IBAction)dismissBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)coverClick {
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XYCityGroup *cityGroup = self.cityGroups[section];
    NSArray *citys = cityGroup.cities;
    return citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reusedID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    XYCityGroup *cityGroup = self.cityGroups[indexPath.section];
    NSArray *citys = cityGroup.cities;
    cell.textLabel.text = citys[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    XYCityGroup *cityGroup = self.cityGroups[section];
    return cityGroup.title;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED{
    
    return [self.cityGroups valueForKey:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    XYCityGroup *cityGroup = self.cityGroups[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    XYCity *city = [[XYMetaDataTool shareMateData] cityWithName:cityName];
    
    //发出通知
    [XYNotificationCenter postNotificationName:XYCityDidChangeNotification object:self userInfo:@{XYSelectedCity: city}];
}
#pragma mark - 让控制器在formSheet情况下也能正常退出键盘
- (BOOL)disablesAutomaticKeyboardDismissal{
    return NO;
}
@end
