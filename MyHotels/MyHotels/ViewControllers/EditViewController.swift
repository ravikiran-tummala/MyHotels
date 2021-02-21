//
//  EditViewController.swift
//  MyHotels
//
//  Created by Ravi Kiran Tummala on 19/02/21.
//

import UIKit

class EditViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    weak var delegate: HotelInfoUpdate?
    var isAdd = false
    var hotel:HotelModel!
    var orientation:UIDeviceOrientation = UIDeviceOrientation.unknown
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var parentStack: UIStackView!
    @IBOutlet weak var dateOfStayTextField: UITextField!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelAddressTextView: UITextView!
    @IBOutlet weak var hotelRatingTextField: UITextField!
    @IBOutlet weak var hotelRateTextField: UITextField!
    @IBOutlet weak var hotelNameTextField: UITextField!
    var dateOfStay:Date!
    var photo:UIImage!
    
    let dateFormat = "dd/MM/yyyy"
    let editTitle = "Edit"
    let addTitle = "Add"
    let photoPickerTitle = "Photo Source"
    let chooseSourceMessage = "Choose A Source"
    let cameraTitle = "Camera"
    let photoLibraryTitle = "Photo Library"
    let cancelActionTitle = "Cancel"
    let doneTitle = "Done"
    let alertTitle = "Alert"
    let alertMessage = "Fill in everything"
    let okMesage = "ok"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if ((currentOrientation?.isLandscape) != nil) {
            orientation = UIDeviceOrientation.landscapeLeft
        }else{
            orientation = UIDeviceOrientation.portrait
        }
        imagePicker.delegate = self
        changeStackLayout()
        showDatePicker()
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAwayFunction))
        self.view.addGestureRecognizer(myGesture)
        if hotel != nil{
            hotelImageView.image = hotel.photo
            hotelNameTextField.text = hotel.name
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            dateOfStayTextField.text = formatter.string(from: hotel.dateOfStay)
            hotelAddressTextView.text = hotel.address
            hotelRateTextField.text = String(hotel.roomRate)
            hotelRatingTextField.text = hotel.rating
            self.title = editTitle
            isAdd = false
            
        }else{
            hotel = HotelModel()
            isAdd = true
            self.title = addTitle
        }
        
    }
    
    @objc func tappedAwayFunction() {
        view.endEditing(true)
    }

    @IBAction func onEditAddImage(_ sender: Any) {
        let actionsheet = UIAlertController(title: photoPickerTitle, message: chooseSourceMessage, preferredStyle: .actionSheet)
        if ( UIDevice.current.userInterfaceIdiom == .pad ){
            let popover:UIPopoverPresentationController = actionsheet.popoverPresentationController!
            popover.sourceView = sender as? UIView
            popover.sourceRect = (sender as AnyObject).bounds
            popover.permittedArrowDirections = .up
        }

        actionsheet.addAction(UIAlertAction(title: cameraTitle, style: .default, handler: { (action:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }else{
                // Camera not available
            }
        }))
        actionsheet.addAction(UIAlertAction(title: photoLibraryTitle, style: .default, handler: { (action:UIAlertAction)in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil))
        self.present(actionsheet,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // use the picker image here
            self.hotelImageView.image = pickedImage
            photo = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: doneTitle, style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelActionTitle, style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dateOfStayTextField.inputAccessoryView = toolbar
        dateOfStayTextField.inputView = datePicker

     }

    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        dateOfStayTextField.text = formatter.string(from: datePicker.date)
        dateOfStay = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    

    @IBAction func onSave(_ sender: Any) {
        // validate on save
        if validateTextFields(){
            hotel.address = hotelAddressTextView.text!
            hotel.name = hotelNameTextField.text!
            hotel.rating = hotelRatingTextField.text!
            hotel.roomRate = Float(hotelRateTextField.text!)!
            if photo != nil{
                hotel.photo = photo
            }
            if dateOfStay != nil{
                hotel.dateOfStay = dateOfStay
            }
            if isAdd{
                delegate?.onHotelAddition(hotel: hotel)
            }else{
                delegate?.onHotelInfoUpdate(hotel: hotel)
            }
            self.navigationController!.popViewController(animated: true)
        }else{
            showAlert()
        }
    }
        
    func showAlert(){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okMesage, style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


              @unknown default: break
                
              }}))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func validateTextFields() -> Bool{
        if !hotelNameTextField.text!.isEmpty && ((hotelAddressTextView.text?.isEmpty) != nil) && ((hotelRateTextField.text?.isEmpty) != nil) && ((hotelRatingTextField.text?.isEmpty) != nil){
                return true
            } else {
                return false
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.orientation != orientation && UIDevice.current.orientation != UIDeviceOrientation.unknown && UIDevice.current.orientation !=  UIDeviceOrientation.faceUp && UIDevice.current.orientation != UIDeviceOrientation.faceDown {
            orientation = UIDevice.current.orientation
            changeStackLayout()
        }
    }
    
    func changeStackLayout(){
        if orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight {
            parentStack.axis = .horizontal
        }else if orientation == UIDeviceOrientation.portrait || orientation == UIDeviceOrientation.portraitUpsideDown {
            parentStack.axis = .vertical
        }
    }

}
