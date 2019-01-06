//
//  Keywords.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import Foundation

enum ProgramDescription: String {
    case NoHolidayData = "정보가 없습니다 :("
    case CopyAddress = "주소복사하기 ✏️"
    case AddressCopiedToastMessage = "주소가 클립보드에 복사되었습니다."
    case AddMartRequest = "즐겨찾는 마트를 추가해주세요!"
    case MartHoliday = "마트쉬는날"
    case MailTitle = "[마트쉬는날] 문의"
    case MailBody = "<p>문의사항을 기재해주세요:)</p>"
    case FailureSendingMailTitle = "메일 전송 실패😢"
    case FailureSendingMailBody = "아이폰 기본 '메일'앱에서 계정을 추가해주세요!"
    case SuccessSendingMailTitle = "감사합니다❤️"
    case SuccessSendingMailBody = "소중한 의견 감사합니다 :)"
    case SeachingMart = "마트 검색"
    case TypeBranchName = "지점명을 입력하세요."
    case MartLocation = "위치 보기"
    case NoDateData = "휴무일 정보가 없습니다 :("
    case DefaultVersion = "ⓥ 1.0.0"
    case AppInfo = "앱 정보"
    case networkErrorTitle = "에러!💥"
    case noNetworkErrorMsg = "네트워크를 찾을 수 없습니다.\n앱을 구동하기위해 인터넷 연결을 확인해주세요."
    case sorryErrorTitle = "죄송합니다😰"
    case networkTimeoutMsg = "서버에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."
}
