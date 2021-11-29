import UIKit

class InfoViewController: UIViewController {
    
    var contentScrollView: UIScrollView = {
        var contentScrollView = UIScrollView()
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        return contentScrollView
    }()
    var containerView: UIView = {
        var containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    var headerLabel: UILabel = {
        var headerLabel = UILabel()
        headerLabel.text = "Привычка за 21 день"
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.backgroundColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return headerLabel
    }()
    var infoDescriptionLabel: UILabel = {
        var infoDescriptionLabel = UILabel()
        infoDescriptionLabel.text = #"""
            Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\#n
            1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\#n
            2. Выдержать 2 дня в прежнем состоянии самоконтроля.\#n
            3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче,
            с чем еще предстоит серьезно бороться.\#n
            4. Поздравить себя с прохождением первого серьезного порога в 21 день.
            За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\#n
             5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\#n
            6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\#n
            Источник: psychbook.ru
            """#
        infoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        infoDescriptionLabel.numberOfLines = 0
        infoDescriptionLabel.backgroundColor = .white
        infoDescriptionLabel.font = UIFont.systemFont(ofSize: 17)
        return infoDescriptionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Информация"
        navigationController?.navigationBar.topItem?.title = self.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
}

extension InfoViewController {
    private func setupConstraints() {
        view.addSubview(contentScrollView)
        
        containerView.addSubview(headerLabel)
        containerView.addSubview(infoDescriptionLabel)
        
        contentScrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentScrollView.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 22),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            infoDescriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            infoDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            infoDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}
