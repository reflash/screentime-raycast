import ExpoModulesCore
import UIKit
import CoreMotion
import SwiftUI
import FamilyControls
import Combine

@available(iOS 15, *)
struct ScreenTimeSelectAppsContentView: View {
    @State private var pickerIsPresented = false
    @ObservedObject var model: ScreenTimeSelectAppsModel

    var body: some View {
        Button {
            pickerIsPresented = true
        } label: {
            Text("Select Apps")
        }
        .familyActivityPicker(
            isPresented: $pickerIsPresented, 
            selection: $model.activitySelection
        )
    }
}

class ScreenTimeView: UIView {
  var onSelectEvent: EventDispatcher? = nil
  private var cancellables = Set<AnyCancellable>()
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let userDefaultsKey = "ScreenTimeSelection"
  
  lazy var yPositionTextView = UILabel()
  
  func setText(_ text: String?) {
    self.yPositionTextView.text = text ?? "Start"
  }
  
  func setEventDispatcher(_ eventDispatcher: EventDispatcher) {
    self.onSelectEvent = eventDispatcher
  }

  @available(iOS 15, *)
  func saveSelection(selection: FamilyActivitySelection) {
    
        let defaults = UserDefaults.standard

        defaults.set(
            try? encoder.encode(selection), 
            forKey: userDefaultsKey
        )
    }
    
    @available(iOS 15, *)
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard

        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }

        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    if #available(iOS 15.0, *) {
      let model = ScreenTimeSelectAppsModel()
      let host = UIHostingController(rootView: ScreenTimeSelectAppsContentView(model: model))
      let hostView = host.view!
      self.addSubview(hostView)

      hostView.translatesAutoresizingMaskIntoConstraints = false
      hostView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      hostView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

      model.activitySelection = savedSelection() ?? FamilyActivitySelection()
        
      model.$activitySelection.sink { selection in
          self.saveSelection(selection: selection)
      }
      .store(in: &cancellables)
    } else {
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}