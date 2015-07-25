//
//  ComplicationController.swift
//  Clockkit与复杂功能 WatchKit Extension
//
//  Created by Ricardo on 15/7/19.
//  Copyright © 2015年 Fate. All rights reserved.
//

import ClockKit

struct Show {
    var 名称: String
    var 简称: String?
    var 类型: String
    
    var 开始时间: NSDate
    var 播放时长: NSTimeInterval
}

let hour: NSTimeInterval = 60 * 60
let shows = [
    Show(名称: "舌尖上的中国", 简称: "舌尖", 类型: "纪录片", 开始时间: NSDate(), 播放时长: hour * 1),
    Show(名称: "盗墓笔记", 简称: nil, 类型: "电视剧", 开始时间: NSDate(timeIntervalSinceNow: hour * 1), 播放时长: hour),
    Show(名称: "泰坦尼克号", 简称: nil, 类型: "电影", 开始时间: NSDate(timeIntervalSinceNow: hour * 2), 播放时长: hour * 3),
    Show(名称: "新闻30分", 简称: nil, 类型: "新闻", 开始时间: NSDate(timeIntervalSinceNow: hour * 5), 播放时长: hour)
]

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.Forward)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: (60 * 60 * 24)))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let show = shows[0]
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.开始时间, endDate: NSDate(timeInterval: show.播放时长, sinceDate: show.开始时间))
        template.body1TextProvider = CLKSimpleTextProvider(text: show.名称, shortText: show.简称)
        template.body2TextProvider = CLKSimpleTextProvider(text: show.类型, shortText: nil)
        
        let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.开始时间), complicationTemplate: template)
        handler(entry)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
       
        var entries: [CLKComplicationTimelineEntry] = []
        
        for show in shows
        {
            if entries.count < limit && show.开始时间.timeIntervalSinceDate(date) > 0
            {
                let template = CLKComplicationTemplateModularLargeStandardBody()
                
                template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.开始时间, endDate: NSDate(timeInterval: show.播放时长, sinceDate: show.开始时间))
                template.body1TextProvider = CLKSimpleTextProvider(text: show.名称, shortText: show.简称)
                template.body2TextProvider = CLKSimpleTextProvider(text: show.类型, shortText: nil)
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.开始时间), complicationTemplate: template)
                entries.append(entry)
            }
        }
        
        handler(entries)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 60 * 60 * 1.5))
        template.body1TextProvider = CLKSimpleTextProvider(text: "剧名", shortText: "名字")
        template.body2TextProvider = CLKSimpleTextProvider(text: "类型", shortText: nil)
        
        handler(template)
    }
}
