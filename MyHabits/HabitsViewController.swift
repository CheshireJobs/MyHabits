import UIKit

class HabitsViewController: UIViewController {
    
    private var habitsCollectitonView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var habitsCollectitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        habitsCollectitonView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        habitsCollectitonView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        habitsCollectitonView.translatesAutoresizingMaskIntoConstraints = false
        return habitsCollectitonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitsCollectitonView.backgroundColor = UIColor(named: "LightGray")
        habitsCollectitonView.delegate = self
        habitsCollectitonView.dataSource = self
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
                
        habitsCollectitonView.reloadData()
    }
}

private extension HabitsViewController {
    private func setupConstraints() {
        view.addSubview(habitsCollectitonView)
        
        NSLayoutConstraint.activate([
            habitsCollectitonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), 
            habitsCollectitonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsCollectitonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitsCollectitonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HabitsViewController: HabitCollectionViewCellDelegate {
    func updateData() {
        habitsCollectitonView.reloadData()
    }
}

extension HabitsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let habitDetailsTableViewController = HabitDetailsViewController()
            habitDetailsTableViewController.habit = HabitsStore.shared.habits[indexPath.row]
            habitDetailsTableViewController.title = HabitsStore.shared.habits[indexPath.row].name
            navigationController?.pushViewController(habitDetailsTableViewController, animated: true)
        }
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return HabitsStore.shared.habits.count
        default:
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = habitsCollectitonView.dequeueReusableCell(withReuseIdentifier: String(describing:        ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
            cell.progressLevel = HabitsStore.shared.todayProgress
            cell.resultProgressBarLabel.text = "\(Int((cell.progressLevel ?? 0) * 100))%"
            return cell
        case 1:
            let cell = habitsCollectitonView.dequeueReusableCell(withReuseIdentifier: String(describing:        HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
            cell.habit = HabitsStore.shared.habits[indexPath.row]
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
                                    
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            var size = CGSize()
            size.width = (collectionView.frame.width - 33)
            size.height = 60
            return size
        case 1:
            var size = CGSize()
            size.width = (collectionView.frame.width - 33)
            size.height = 130
            return size
        default:
            return CGSize()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 16, bottom: 0, right: 17)
    }
}
