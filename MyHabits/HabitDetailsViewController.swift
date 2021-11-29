import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit?
    
    private let habitEditViewController: HabitViewController = {
        let  habitEditViewController = HabitViewController()
        return habitEditViewController
    }()
   
    private var detailsTable: UITableView = {
        var detailsTable = UITableView()
        detailsTable.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: String.init(describing: HabitDetailsTableViewCell.self))
        detailsTable.translatesAutoresizingMaskIntoConstraints = false
        detailsTable.backgroundColor = UIColor(named: "LightGray")
        return detailsTable
    }()
    private let relativeDateFormatter: DateFormatter = {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .long
        relativeDateFormatter.locale = Locale(identifier: "ru_RU")
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Править", style: .plain, target: self, action: #selector(editAction))
        
        detailsTable.delegate = self
        detailsTable.dataSource = self
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let habit = habitEditViewController.habit {
            self.habit = habit
            if !HabitsStore.shared.habits.contains(habit) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        title = habit?.name
        navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
    }
}

private extension HabitDetailsViewController {
    
    @objc func editAction() {
        habitEditViewController.habit = habit
        habitEditViewController.state = .edit
        let editNavigationController = UINavigationController(rootViewController: habitEditViewController)
        editNavigationController.modalPresentationStyle = .fullScreen
        present(editNavigationController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        view.addSubview(detailsTable)
        
        NSLayoutConstraint.activate([
            detailsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    
}

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: HabitDetailsTableViewCell.self), for: indexPath) as! HabitDetailsTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
       
        cell.dateLabel.text = relativeDateFormatter.string(from: HabitsStore.shared.dates[HabitsStore.shared.dates.count - indexPath.row - 1])
        if let isHabit = habit {
            if HabitsStore.shared.habit(isHabit, isTrackedIn: HabitsStore.shared.dates[HabitsStore.shared.dates.count - indexPath.row - 1]) {
                cell.accessoryType = .checkmark
                cell.tintColor = UIColor(named: "Purple")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
}
