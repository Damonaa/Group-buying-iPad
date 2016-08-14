//
//  XYMetaDataTool.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMetaDataTool.h"
#import "XYCategory.h"
#import "XYCity.h"
#import "XYCityGroup.h"
#import "XYSort.h"
#import "XYRegion.h"

/**
 *  保存到沙盒的文件名
 */
#define XYSortFile     @"sort.archive"
#define XYCategoryFile @"category.archive"
#define XYRegionFile   @"region.archive"
#define XYCityFile     @"city.plist"

@interface XYMetaDataTool ()
{
    NSArray *_categories;
    
    NSArray *_cities;
    
//    NSArray *_cityGroups;
    
    NSArray *_sorts;
}
/**
 *  选中的最近的城市名
 */
@property (nonatomic, strong) NSMutableArray *selectedCityNames;

@end

@implementation XYMetaDataTool


#pragma mark - 懒加载

- (NSMutableArray *)selectedCityNames{
    if (!_selectedCityNames) {
        //先从沙盒中获取已选中的城市组
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:[self cachePathWithFileName:XYCityFile]];
        if (!_selectedCityNames) {//沙盒中没有，创建新的数组
            _selectedCityNames = [NSMutableArray array];
        }
    }
    return _selectedCityNames;
}

- (NSArray *)categories{
    if (!_categories) {
        _categories = [XYCategory mj_objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cities{
    if (!_cities) {
        _cities = [XYCity mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)cityGroups{
    NSMutableArray *cityGroups = [NSMutableArray array];
    //最近选中的城市组
    if (self.selectedCityNames.count) {
        XYCityGroup *recentCity = [[XYCityGroup alloc] init];
        recentCity.title = @"最近";
        recentCity.cities = self.selectedCityNames;
        [cityGroups addObject:recentCity];
    }
    //将plist中的数据添加到数组中
    NSArray *filesGroups = [XYCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
    [cityGroups addObjectsFromArray:filesGroups];
    return cityGroups;
}

- (NSArray *)sorts{
    if (!_sorts) {
        _sorts = [XYSort mj_objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

- (XYCity *)cityWithName:(NSString *)name{
    if (name.length == 0) {
        return nil;
    }
    
    for (XYCity *city in [self cities]) {
        if ([city.name isEqualToString:name]) {
            return city;
        }
    }
    return nil;
}


#pragma mark - 保存用户操作到沙盒
//存region
- (void)saveSelectedRegion:(XYRegion *)region{
    if (region == nil) {
        return;
    }
    
    [NSKeyedArchiver archiveRootObject:region toFile:[self cachePathWithFileName:XYRegionFile]];
}
//取region
- (XYRegion *)selectedRegion{
    XYRegion *region = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathWithFileName:XYRegionFile]];
    if (region == nil) {//沙盒中没有
        XYCity *city = [self selectedCity];
        region = city.regions[0];
        region.subregion = @"全部";
    }
    
    return region;
}
//存城市名
- (void)saveSelectedCityName:(NSString *)name{
    if (name.length == 0) {
        return;
    }
    [self.selectedCityNames removeObject:name];
    [self.selectedCityNames insertObject:name atIndex:0];
    [self.selectedCityNames writeToFile:[self cachePathWithFileName:XYCityFile] atomically:YES];
}
//取城市名
- (XYCity *)selectedCity{
    XYCity *city;
    if (self.selectedCityNames.count) {
        NSString *cityName = self.selectedCityNames[0];
        city = [self cityWithName:cityName];
        if (city == nil) {
            city = [self cityWithName:@"杭州"];
        }
    }else{
        if (city == nil) {
            city = [self cityWithName:@"杭州"];
        }
    }
    return city;
}

//存排序
- (void)saveSelectedSort:(XYSort *)sort{
    if (sort == nil) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:sort toFile:[self cachePathWithFileName:XYSortFile]];
}
//取排序
- (XYSort *)selectedSort{
    XYSort *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathWithFileName:XYSortFile]];
    
    if (sort == nil) {
        sort = self.sorts[0];
    }
    return sort;
}
//存分类
- (void)saveSelectedCategory:(XYCategory *)category{
    if (category == nil) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:category toFile:[self cachePathWithFileName:XYCategoryFile]];
}
//取分类
- (XYCategory *)selectedCategory{
    XYCategory *category = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathWithFileName:XYCategoryFile]];
    
    if (category == nil) {
        category = self.categories[0];
    }
    return category;
}

- (XYCategory *)categoryWithName:(NSString *)name{
    for (XYCategory *category in self.categories) {
        if ([category.name isEqualToString:name]) {
            return category;
        }
        
        for (NSString *subCa in category.subcategories) {
            if ([subCa isEqualToString:name]) {
                return category;
            }
        }
    }
    return nil;
}

/**
 *  获取沙盒缓存文件夹的路径
 *
 *  @param name 保存的文件名字
 */
- (NSString *)cachePathWithFileName:(NSString *)name{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingPathComponent:name];
}

#pragma mark - 单例模式
static id _instance = nil;
+ (instancetype)shareMateData{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

@end
