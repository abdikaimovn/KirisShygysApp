//
//  HomeViewController.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 28.01.2024.
//

import UIKit

class HomeViewController: UIViewController {
    private let greetingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green

        //TODO: Исправить (пока только тест)
        view.addSubview(greetingLabel)
        greetingLabel.text = "Welcome!"
        greetingLabel.font = UIFont.systemFont(ofSize: 25)
        greetingLabel.textColor = .blue
        greetingLabel.center = view.center
    }
}
