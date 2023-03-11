import UIKit

class TestViewController: UIViewController {
    
    // Define the array of product categories
    let productCategories = ["Category 1", "Category 2", "Category 3", "Category 4"]
    
    // Define the current category index
    var currentCategoryIndex = 0
    
    // Define the swipe view controller
    lazy var swipeViewController: UIPageViewController = {
        let swipeVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        swipeVC.dataSource = self
        swipeVC.delegate = self
        swipeVC.view.backgroundColor = .white
        swipeVC.setViewControllers([createCategoryViewController(categoryIndex: currentCategoryIndex)], direction: .forward, animated: false, completion: nil)
        return swipeVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the swipe view controller to the main view
        addChild(swipeViewController)
        view.addSubview(swipeViewController.view)
        swipeViewController.view.frame = view.bounds
        swipeViewController.didMove(toParent: self)
    }
    
    // Create a new view controller for a given category index
    func createCategoryViewController(categoryIndex: Int) -> UIViewController {
        let categoryVC = UIViewController()
        categoryVC.view.backgroundColor = .white
        let label = UILabel()
        label.text = productCategories[categoryIndex]
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        categoryVC.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: categoryVC.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: categoryVC.view.centerYAnchor).isActive = true
        return categoryVC
    }
}

extension TestViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentCategoryIndex == 0 {
            return nil
        }
        currentCategoryIndex -= 1
        return createCategoryViewController(categoryIndex: currentCategoryIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentCategoryIndex == productCategories.count - 1 {
            return nil
        }
        currentCategoryIndex += 1
        return createCategoryViewController(categoryIndex: currentCategoryIndex)
    }
}

extension TestViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first {
            if let categoryIndex = productCategories.firstIndex(of: (currentVC.children.first as? UILabel)?.text ?? "") {
                currentCategoryIndex = categoryIndex
            }
        }
    }
}
