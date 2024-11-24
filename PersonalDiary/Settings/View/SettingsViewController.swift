//
//  SettingsViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        notificationSwitch.isOn = NotificationManager.shared.isNotificationEnabled()
        if let date = UserDefaults.standard.value(forKey: "notificationTime") as? Date {
            timeButton.setTitle(date.toString(format: "HH:mm"), for: .normal)
        }
    }
    
    func setupUI() {
        darkModeSwitch.layer.cornerRadius = darkModeSwitch.frame.height / 2
        notificationSwitch.layer.cornerRadius = notificationSwitch.frame.height / 2
        titleLabels.forEach({ $0.font = .semibold(size: 22) })
        timeButton.titleLabel?.font = .semibold(size: 22)
        textField.isHidden = true
        self.view.addSubview(textField)
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        textField.inputView = datePicker
    }
    
    @objc func timeChanged() {
        timeButton.setTitle(datePicker.date.toString(format: "HH:mm"), for: .normal)
        NotificationManager.shared.scheduleDailyNotification(at: datePicker.date, title: "Daily Reminder", body: "Don't forget to record your thoughts today!")
        UserDefaults.standard.set(datePicker.date, forKey: "notificationTime")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedDarkMode(_ sender: UISwitch) {
        sender.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }
    
    @IBAction func clickedNotification(_ sender: UISwitch) {
        if sender.isOn {
            NotificationManager.shared.requestNotificationPermission(completion: { [weak self] granted in
                guard let self = self else { return }
                sender.isOn = granted
                sender.setOn(granted, animated: true)
                UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
                if granted, let date = UserDefaults.standard.value(forKey: "notificationTime") as? Date {
                    NotificationManager.shared.scheduleDailyNotification(at: date, title: "Daily Reminder", body: "Don't forget to record your thoughts today!")
                }
            })
        } else {
            print("Notifications disabled")
            sender.isOn = false
            UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
        }
    }
    
    @IBAction func chooseNotifyTime(_ sender: UIButton) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
