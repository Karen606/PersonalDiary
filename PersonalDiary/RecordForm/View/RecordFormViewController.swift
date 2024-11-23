//
//  RecordFormViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import UIKit
import Combine
import PhotosUI

class RecordFormViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var emojiButtons: [UIButton]!
    @IBOutlet weak var descriptionTextView: BaseTextView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var createButton: BaseButton!
    private let viewModel = RecordFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let datePicker = UIDatePicker()
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .medium(size: 22) })
        dateButton.titleLabel?.font = .medium(size: 18)
        descriptionTextView.placeholder = "Enter your thoughts"
        descriptionTextView.font = .regular(size: 18)
        photoButton.layer.borderWidth = 1.5
        photoButton.layer.borderColor = UIColor.border.cgColor
        photoButton.layer.masksToBounds = true
        createButton.titleLabel?.font = .medium(size: 22)
        descriptionTextView.baseDelegate = self
        self.view.addSubview(textField)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.maximumDate = Date()
        textField.isHidden = true
        textField.inputView = datePicker
    }
    
    @objc func dateChanged() {
        viewModel.record.date = datePicker.date
    }
    
    func subscribe() {
        viewModel.$record
            .receive(on: DispatchQueue.main)
            .sink { [weak self] record in
                guard let self = self else { return }
                self.createButton.isEnabled = (record.emoji != nil && record.info.checkValidation() && record.photo != nil)
                self.dateButton.setTitle(record.date?.toString(), for: .normal)
                self.descriptionTextView.text = record.info
                if let data = record.photo {
                    self.photoButton.setImage(UIImage(data: data), for: .normal)
                } else {
                    self.photoButton.setImage(.imagePlaceholder, for: .normal)
                }
                self.emojiButtons.forEach({ $0.isSelected = false })
                if let emoji = record.emoji {
                    self.emojiButtons[emoji].isSelected = true
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func chooseEmoji(_ sender: UIButton) {
        viewModel.record.emoji = sender.tag
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension RecordFormViewController: BaseTextViewDelegate {
    func didChancheSelection(_ textView: UITextView) {
        viewModel.record.info = textView.text
    }
}

extension RecordFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .authorized:
                openCamera()
            case .denied, .restricted:
                showSettingsAlert()
            @unknown default:
                break
            }
        }
        
        private func requestPhotoLibraryAccess() {
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            switch photoStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .authorized:
                openPhotoLibrary()
            case .denied, .restricted:
                showSettingsAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        private func openCamera() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func openPhotoLibrary() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func showSettingsAlert() {
            let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                photoButton.setImage(editedImage, for: .normal)
            } else if let originalImage = info[.originalImage] as? UIImage {
                photoButton.setImage(originalImage, for: .normal)
            }
            if let imageData = photoButton.imageView?.image?.jpegData(compressionQuality: 1.0) {
                let data = imageData
                viewModel.record.photo = data
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
