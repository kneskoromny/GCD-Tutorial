//
//  SecondViewController.swift
//  GCD
//
//  Created by Ivan Akulov on 04/10/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        // выполняется, когда хотим получить значение image
        get {
            return imageView.image
        }
        // выполняется при установке нового значения image
        set {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
    // обозначаем задержку delay и completion (внутри него модем добавлять все, что угодно)
    private func delay(_ delay: Int, completion: @escaping() -> Void) {
        // говорим что completion будет выполняться в главном потоке с указанной ранее задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            completion()
        }
    }
    
    private func loginAlert() {
        let alert = UIAlertController(title: "Зарегистрированы?", message: "Введите логин и пароль", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ОК", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        alert.addTextField { userNameTF in
            userNameTF.placeholder = "Введите логин"
        }
        alert.addTextField { userPasswordTF in
            userPasswordTF.placeholder = "Введите пароль"
            userPasswordTF.isSecureTextEntry = true
        }
        self.present(alert, animated: true)
    }
    
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        // создаем очередь
        let queue = DispatchQueue.global(qos: .utility)
        // добавляем процесс загрузки картинки в очередь асинхронно, тк не хотим ждать выполнения процесса
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            // возвращаемся в main thread, чтобы обновить UI, тк все действия с интерфейсом ТОЛЬКО в main thread
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
}



















