import UIKit


///КЛАВИАИТУРА

class HabitViewController: UIViewController {
    
    var habit: Habit? {
        didSet {
            nameHabitTextField.text = habit?.name
            nameHabitTextField.textColor = habit?.color
            colorHabitView.backgroundColor = habit?.color
            timeHabitDatePicker.date = habit?.date ?? Date()
        }
    }
    enum State {
        case save
        case edit
    }
    var state: State = State.save
    
    private let nameHabitLabel: UILabel = {
        var nameHabitLabel = UILabel()
        nameHabitLabel.text = "НАЗВАНИЕ"
        nameHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        nameHabitLabel.backgroundColor = .white
        nameHabitLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return nameHabitLabel
    }()
    private let nameHabitTextField: UITextField = {
        let nameHabitTextField = UITextField()
        nameHabitTextField.backgroundColor = .white
        nameHabitTextField.translatesAutoresizingMaskIntoConstraints = false
        nameHabitTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        nameHabitTextField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameHabitTextField.textColor = UIColor(named: "Orange")
        return nameHabitTextField
    }()
    private let colorHabitLabel: UILabel = {
        var nameHabitLabel = UILabel()
        nameHabitLabel.text = "ЦВЕТ"
        nameHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        nameHabitLabel.backgroundColor = .white
        nameHabitLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return nameHabitLabel
    }()
    var colorHabitView: UIView = {
        var colorHabitView = UIView()
        colorHabitView.translatesAutoresizingMaskIntoConstraints = false
        colorHabitView.backgroundColor = UIColor(named: "Orange")
        colorHabitView.layer.cornerRadius = 15
        return colorHabitView
    }()
    private let timeHabitLabel: UILabel = {
        var nameHabitLabel = UILabel()
        nameHabitLabel.text = "ВРЕМЯ"
        nameHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        nameHabitLabel.backgroundColor = .white
        nameHabitLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return nameHabitLabel
    }()
    private let timeHabitDescriptipnLabel: UILabel = {
        var timeHabitDescriptipnLabel = UILabel()
        timeHabitDescriptipnLabel.text = "Каждый день в "
        timeHabitDescriptipnLabel.translatesAutoresizingMaskIntoConstraints = false
        timeHabitDescriptipnLabel.backgroundColor = .white
        timeHabitDescriptipnLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return timeHabitDescriptipnLabel
    }()
    private var timeHabitDatePicker: UIDatePicker = {
        var timeHabitDatePicker = UIDatePicker()
        timeHabitDatePicker.translatesAutoresizingMaskIntoConstraints = false
        timeHabitDatePicker.tintColor = UIColor(named: "Purple")
        timeHabitDatePicker.datePickerMode = .time
        timeHabitDatePicker.backgroundColor = .white

        return timeHabitDatePicker
    }()
    private let removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.tintColor = .red
        removeButton.setTitle("Удалить привычку", for: .normal)
        removeButton.setTitleColor(.red, for: .normal)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return removeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(createHabit))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelCreatingHabit))
        navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        setupConstraints()
        
        let tapColorGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapColorGesture)
        )
        colorHabitView.addGestureRecognizer(tapColorGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = (state == .save ? "Создать" : "Править")
        setupConstraints()
    }

}

extension HabitViewController {
    @objc func cancelCreatingHabit() {
        dismiss(animated: true, completion: nil)
    }

    @objc func createHabit() {
        let store = HabitsStore.shared
        let newHabit = Habit(name: nameHabitTextField.text!, date: timeHabitDatePicker.date, color: colorHabitView.backgroundColor!)
        
        if state == .save {
           store.habits.append(newHabit)
        } else {
            for (index, storageHabit) in store.habits.enumerated() {
                if storageHabit.name == habit?.name {
                    newHabit.trackDates = storageHabit.trackDates
                    store.habits[index] = newHabit
                    habit? = newHabit
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteHabit() {
        let store = HabitsStore.shared
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit?.name ?? " ") ?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {
              _ in for (index, storageHabit) in store.habits.enumerated() {
                    if storageHabit.name == self.habit?.name {
                        store.habits.remove(at: index)
                        self.navigationController?.dismiss(animated: false, completion: nil)
                        break
                    }
                }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        view.addSubview(nameHabitLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(colorHabitLabel)
        view.addSubview(colorHabitView)
        view.addSubview(timeHabitLabel)
        view.addSubview(timeHabitDescriptipnLabel)
        view.addSubview(timeHabitDatePicker)
        if state == .edit {
            view.addSubview(removeButton)
            NSLayoutConstraint.activate([
                removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -18)
            ])
        }
        
        NSLayoutConstraint.activate([
            nameHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameHabitLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            
            nameHabitTextField.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: 7),
            nameHabitTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),

            colorHabitLabel.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 15),
            colorHabitLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

            colorHabitLabel.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 15),
            colorHabitLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

            colorHabitView.topAnchor.constraint(equalTo: colorHabitLabel.bottomAnchor, constant: 7),
            colorHabitView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            colorHabitView.heightAnchor.constraint(equalToConstant: 30),
            colorHabitView.widthAnchor.constraint(equalTo: colorHabitView.heightAnchor),

            timeHabitLabel.topAnchor.constraint(equalTo: colorHabitView.bottomAnchor, constant: 15),
            timeHabitLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

            timeHabitDescriptipnLabel.topAnchor.constraint(equalTo: timeHabitLabel.bottomAnchor, constant: 7),
            timeHabitDescriptipnLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

            timeHabitDatePicker.centerYAnchor.constraint(equalTo: timeHabitDescriptipnLabel.centerYAnchor),
            timeHabitDatePicker.leftAnchor.constraint(equalTo: timeHabitDescriptipnLabel.rightAnchor)
        ])
    }
    
    @objc
    private func handleTapColorGesture(gesture: UITapGestureRecognizer) {
        presentColorPicker(colorHabitView.backgroundColor!)
    }
    
    private func presentColorPicker(_ color: UIColor) {
        let pickerViewController = UIColorPickerViewController()
        pickerViewController.delegate = self
        pickerViewController.selectedColor = color
        pickerViewController.title = "Выберите цвет"
        present(pickerViewController, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorHabitView.backgroundColor = viewController.selectedColor
        nameHabitTextField.textColor = colorHabitView.backgroundColor
    }
}
