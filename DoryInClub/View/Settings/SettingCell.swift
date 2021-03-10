//
//  SettingCell.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/25.
//

import UIKit

protocol SettingsCellDelegate: class {
    func settingsCell(_ cell: SettingCell, wantsToUpdateUserWith value: String,
                      for section: SettingsSections)
    
//    func settingsCell(_ cell: SettingCell, wantsToUpdateAgeRangeWith sender: UISlider)
}

class SettingCell: UITableViewCell {
    
    // MARK: - Prooaties
    
    var delegate: SettingsCellDelegate?
    
    var viewModel: SettingsViewModel! {
        didSet{ configure() }
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        return tf
    }()
    
    lazy var genderTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        return tf
    }()
    
    lazy var clubTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        return tf
    }()
    
    
    var genderPickerView: UIPickerView = UIPickerView()
    let genderList: [String] = ["", "男", "女"]
    
    var clubPickerView: UIPickerView = UIPickerView()
    let clubList: [String] = ["", "V2 TOKYO", "1OAK TOKYO", "SEL OCTAGON TOKYO", "MEZZO TOKYO(BAR)",
                              "VISEL","WOMB","CAMELOT", "TK SHIBUYA", "ATOM TOKYO", "LAUREL TOKYO",
                              "WARP SHINJYUKU",
                              "PLUS TOKYO"]
    
    
    var  sliderStack = UIStackView()
    
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()
    
//    lazy var minAgeSlider = createAgeRangeSlider()
//    lazy var maxAgeSlider = createAgeRangeSlider()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(inputTextField)
        inputTextField.fillSuperview()
        
        createPicker()
        contentView.addSubview(genderTextField)
        genderTextField.fillSuperview()
        contentView.addSubview(clubTextField)
        clubTextField.fillSuperview()
        
//        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
//        minStack.spacing = 24
//
//        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
//        maxStack.spacing = 24
//
//        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
//        sliderStack.axis = .vertical
//        sliderStack.spacing = 16
        
//        contentView.addSubview(sliderStack)
//        sliderStack.centerY(inView: self)
//        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleUpdateUserInfo(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.sections)
    }
    
//    @objc func handleAgeRangeChange(sender: UISlider) {
//        if sender == minAgeSlider {
//            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
//        } else {
//            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
//        }
//
//        delegate?.settingsCell(self, wantsToUpdateAgeRangeWith: sender)
//    }
    
    @objc func genderDone() {
        genderTextField.endEditing(true)
        genderTextField.text = "\(genderList[genderPickerView.selectedRow(inComponent: 0)])"
    }
    
    @objc func clubDone() {
        clubTextField.endEditing(true)
        clubTextField.text = "\(clubList[clubPickerView.selectedRow(inComponent: 0)])"
    }
    
    // MARK: - Helpers
    
    func configure() {
        inputTextField.isHidden = viewModel.shouldHideInputTextField
//        sliderStack.isHidden = viewModel.shouldHideSlider
        genderTextField.isHidden = viewModel.shouldHideGenderPicker
        clubTextField.isHidden = viewModel.shouldHideClubPicker
        
        inputTextField.placeholder = viewModel.placeholderText
        inputTextField.text = viewModel.value
        
        genderTextField.placeholder = viewModel.placeholderText
        genderTextField.text = viewModel.value
        
        clubTextField.placeholder = viewModel.placeholderText
        clubTextField.text = viewModel.value
        
//        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
//        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
//
//        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
//        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)

    }
    
//    func createAgeRangeSlider() -> UISlider {
//        let slider = UISlider()
//        slider.minimumValue = 18
//        slider.maximumValue = 60
//        slider.addTarget(self, action: #selector(handleAgeRangeChange), for: .valueChanged)
//        return slider
//    }
    
    func createPicker() {
        // ピッカー設定
        genderPickerView.tag = 1
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        // 決定バーの生成
        let genderToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let genderSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let genderDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(genderDone))
        genderToolbar.setItems([genderSpacelItem, genderDoneItem], animated: true)
        // インプットビュー設定
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = genderToolbar
        
        clubPickerView.tag = 2
        clubPickerView.delegate = self
        clubPickerView.dataSource = self
        // 決定バーの生成
        let clubToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let clubSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let clubDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clubDone))
        clubToolbar.setItems([clubSpacelItem, clubDoneItem], animated: true)
        // インプットビュー設定
        clubTextField.inputView = clubPickerView
        clubTextField.inputAccessoryView = clubToolbar
        
    }
    
    
}

extension SettingCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? genderList.count : clubList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            genderTextField.text = genderList[row]
        } else {
            clubTextField.text = clubList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? genderList[row] : clubList[row]
    }


}
