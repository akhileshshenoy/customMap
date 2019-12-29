
import AVFoundation
import UIKit
import Alamofire

class QRViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    var memId: String?
    var eventId: Int?
    
    lazy var addUserButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.setTitle("Connect with Team Mate", for: .normal)
        button.addTarget(self, action: #selector(markPresent), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    lazy var memIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Scan Team Mate's ID"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    
    lazy var previewView: QRCodeReaderView = {
        let view = QRCodeReaderView()
        view.backgroundColor = .black
        view.setupComponents(with: QRCodeReaderViewControllerBuilder{
            $0.reader                 = reader
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
        $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        $0.showTorchButton         = true
        $0.preferredStatusBarStyle = .lightContent
        $0.showOverlayView        = true
        $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
      
        $0.reader.stopScanningWhenCodeIsFound = false
    }
        return QRCodeReaderViewController(builder: builder)
    }()

  // MARK: - Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(previewView)
        view.addSubview(dismissButton)
        view.addSubview(memIdLabel)
        view.addSubview(addUserButton)
        
        previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        previewView.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        previewView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        _ = memIdLabel.anchor(previewView.bottomAnchor, left: view.leftAnchor, bottom: dismissButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        _ = addUserButton.anchor(nil, left: view.leftAnchor, bottom: dismissButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 50)
        
        _ = dismissButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 50)
        
        scanInPreviewAction()
        
    }
    
    @objc private func markPresent(){
        if let eventId = eventId{
            if let memId = memId{
                let parameters : Dictionary = ["eventid" : eventId, "delid" : memId] as [String : Any]
                print(parameters)
                Alamofire.request("https://register.mitrevels.in/addmember", method: .post, parameters: parameters).responseJSON{ response in
                    switch response.result {
                    case .success:
                        guard let items = response.result.value as? [String:AnyObject] else {
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "Unable to Fetch Data", message: "Please try again later.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                            return
                        }
                        print(items)
                        if items["success"] as? Int == 1{
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "Successfully added user to the team.", message: nil, preferredStyle: .alert)
                                let yesAction = UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
                                    self.dismissVC()
                                    self.scanInPreviewAction()
                                    self.memIdLabel.text = "Scan Team Mates's ID"
                                })
                                alertController.addAction(yesAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                        }else{
                            if let msg = items["msg"]{
                                DispatchQueue.main.async(execute: {
                                    let alertController = UIAlertController(title: msg as? String, message: nil, preferredStyle: .alert)
                                    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (_) in
                                        self.scanInPreviewAction()
                                        self.memIdLabel.text = "Scan Team Mate's ID"
                                    })
                                    alertController.addAction(tryAgainAction)
                                    self.present(alertController, animated: true, completion: nil)
                                })
                            }
                        }
                        break
                    case .failure(let error):
                        AudioServicesPlaySystemSound(1521)
                        print(error)
                    }
                }
            }else{
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Please Scan Team Mate's ID", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }
        }else{
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Error in reading event.", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return
        }
    }
    
    @objc private func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    

  private func checkScanPermissions() -> Bool {
    do {
      return try QRCodeReader.supportsMetadataObjectTypes()
    } catch let error as NSError {
      let alert: UIAlertController

      switch error.code {
      case -11852:
        alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
          DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
          }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      default:
        alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      }

      present(alert, animated: true, completion: nil)

      return false
    }
  }

    func scanInPreviewAction() {
    guard checkScanPermissions(), !reader.isRunning else { return }

    reader.didFindCode = { result in
        self.memIdLabel.text = "ID Scanned Successfully"
        self.memId = "\(result.value)"
//      print("Completion with result: \(result.value) of type \(result.metadataType)")
    }

    reader.startScanning()
  }

  // MARK: - QRCodeReader Delegate Methods

  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()

    dismiss(animated: true) { [weak self] in
      let alert = UIAlertController(
        title: "QRCodeReader",
        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

      self?.present(alert, animated: true, completion: nil)
    }
  }

  func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    print("Switching capture to: \(newCaptureDevice.device.localizedName)")
  }

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    reader.stopScanning()

    dismiss(animated: true, completion: nil)
  }
}
