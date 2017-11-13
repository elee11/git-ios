//
//  File.swift
//  SwiftStructure
//
//  Created by mohamed-shaat on 2/6/17.
//  Copyright © 2017 shaat. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Language {
        static let ARABIC="ar"
        static let ENGLISH="en"
        static let ARABICINT = 1
        static let ENGLISHINT = 2
    }
    
    struct pushNotificationKeys {
        static let DEVICE_TOKEN = "DEVICE_TOKEN"
        static let FCM_TOKEN = "FCM_TOKEN"
    }
    
    struct keys {
        static let flurry = "HBVRP3Y6QCT2CZMFTTQ5"
    }
    
    struct WebService {
        //    live: http://api.saudieng.sa
        //    test: http://5.42.229.77
        static let URL_BASE = "http://5.42.229.77/api"
        // About //used in constants as this string will be removed from nextPageUrl to get pagingInfo and used it as a parameter in MOYA
        static let URL_NEWS_get = URL_BASE + "/About/News?pageSize=20&pagingInfo="
        static let mobileType = "100010000"
    }
    
    struct shareApp {
        static let url = "https://land.ly/sce"
    }
    
    struct Loader {
        static let option = 13
    }
    
    struct Segues {
        static let SEG_FROM_HOME_TO_ABOUT_COUNCIL = "SEG_FROM_HOME_TO_ABOUT_COUNCIL"
        static let SEG_FROM_HOME_TO_QUERIES = "SEG_FROM_HOME_TO_QUERIES"
        static let SEG_FROM_HOME_TO_COURSES = "SEG_FROM_HOME_TO_COURSES"
        static let SEG_FROM_HOME_TO_ESERVICES = "SEG_FROM_HOME_TO_ESERVICES"
        static let SEG_FROM_ABOUTCOUNCIL_TO_ABOUTCOUNCIL_WEBVIEW = "SEG_FROM_ABOUTCOUNCIL_TO_ABOUTCOUNCIL_WEBVIEW"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_NEWS = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_NEWS"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_ADMINISTRATIONS = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_ADMINISTRATIONS"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_STATISTICS = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_STATISTICS"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_BRANCHES = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_BRANCHES"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_MEMBERSHIP_BENEFITS = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_MEMBERSHIP_BENEFITS"
        static let SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_SOCIAL_ACCOUNTS = "SEG_FROM_ABOUTCOUNCIL_TO_COUNCIL_SOCIAL_ACCOUNTS"
        static let SEG_FROM_NEWS_TO_NEWS_DETAILS = "SEG_FROM_NEWS_TO_NEWS_DETAILS"
        //profile
        static let S_PROFILE = "S_PROFILE"
        static let S_PROFILE_ESERVICES_PAGES = "S_PROFILE_ESERVICES_PAGES"
        //ACCREDITATION
        static let S_FROM_ESERVICES_TO_ACCREDITATION = "S_FROM_ESERVICES_TO_ACCREDITATION"
        static let S_FROM_ESERVICES_TO_OFFICES = "S_FROM_ESERVICES_TO_OFFICES"
        static let S_FROM_ESERVICES_TO_ARBITRATION = "S_FROM_ESERVICES_TO_ARBITRATION"
        static let S_FROM_ESERVICES_TO_TRAINING = "S_FROM_ESERVICES_TO_TRAINING"
        static let S_FROM_ESERVICES_TO_BRANCHES = "S_FROM_ESERVICES_TO_BRANCHES"
        static let S_LOGIN = "S_LOGIN"
        static let S_ACCREDITATION_PREV_REQUESTS = "S_ACCREDITATION_PREV_REQUESTS"
        static let S_RESULTS_OFFICES = "S_RESULTS_OFFICES"
        static let S_RATE_COURSE = "S_RATE_COURSE"
        static let S_COURSES_SEARCH_RESULTS = "S_COURSES_SEARCH_RESULTS"
        static let S_COURSE_DETAILS = "S_COURSE_DETAILS"
        static let S_RESULT_ENGINEER = "S_RESULT_ENGINEER"
        static let S_COMMITTEEINFO = "S_COMMITTEEINFO"
        static let S_BRANCHES = "S_BRANCHES"
        static let S_STOP_OR_CANCEL_OFFICE = "S_STOP_OR_CANCEL_OFFICE"
        static let S_RENEW_OFFICE = "S_RENEW_OFFICE"
        static let S_NEXT_RENEW = "S_NEXT_RENEW"
    }
    
    struct plist {
        static let aboutCouncilTable = "aboutCouncilTable"
        static let eServicesListTable = "EServicesList"
        static let InquiriesList = "InquiriesList"
    }
    
    struct FONTS {
        static let FONT_PARALLAX_AR = "DinNextMedium"
        static let FONT_AR = "DinNextRegular"
    }
    
    enum TabBarTabs: Int {
        case Home = 0
        case Notifications
        case Profile
        case More
    }
    
}
