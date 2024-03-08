//
//  PersonalInfoPresenter.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 09.03.2024.
//

protocol PersonalInfoViewProtocol: AnyObject {
    
}

final class PersonalInfoPresenter {
    weak var view: PersonalInfoViewProtocol?
    private let personalInfoService: PersonalInfoService
    
    init(personalInfoService: PersonalInfoService) {
        self.personalInfoService = personalInfoService
    }
    
    func viewDidLoad() {
        
    }
}
