MYBlurIntroductionView
======================

![Panel1](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/Small/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%203.09.52%20PM.png)
![Panel2](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/Small/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%203.09.56%20PM.png)
![Panel3](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/Small/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%203.10.00%20PM.png)
![Panel4](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/Small/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%204.42.36%20PM.png)

## A Controller Built With You In Mind

It's time for one introduction/tutorial view to end them all! MYBlurIntroductionView is a powerful platform to build introductions for your iPhone apps. Built on the [MYIntroductionView](https://github.com/MatthewYork/iPhone-IntroductionTutorial) core, MYBlurIntroductionView takes the first time user experience to the next level by providing a host of new features for building introductions.

**Features Include**
* Brand new stock panels built for iOS 7
* Optional blurred backgrounds for iOS 7 (Much love to [ArcticMinds](https://github.com/ArcticMinds/iOS-blur))
* Add **custom panels** straight from .xib files
* Subclass MYIntroductionPanel (the stock panel) for **custom panels** with access to new methods like
  * panelDidAppear 
  * panelDidDisappear
  * enable/disable
* iOS 6 and 7 compatible for iPhone (iPad coming soon)
* Localized Skip Button
* Right-to-Left Language Support


## Creating Panels

**Stock Panels**

One goal for MYBlurIntroductionView was to make the creation of stock (or "non-custom") panels just as easy as with MYIntroductionView. That's why the basic interface hasn't changed one bit. All content is optional and rearranges nicely for you. 

The main panel class is <code>MYIntroductionPanel.{h,m}</code>. It has many different custom init methods for rapid creation of stock panels. Here are a few samples, the first with a header, and the second without.

```objc
//Create stock panel with header
UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];

MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Welcome to MYBlurIntroductionView" description:@"MYBlurIntroductionView is a powerful platform for building app introductions and tutorials. Built on the MYIntroductionView core, this revamped version has been reengineered for beauty and greater developer control." image:[UIImage imageNamed:@"HeaderImage.png"] header:headerView];
    
//Create stock panel with image
MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Automated Stock Panels" description:@"Need a quick-and-dirty solution for your app introduction? MYBlurIntroductionView comes with customizable stock panels that make writing an introduction a walk in the park. Stock panels come with optional blurring (iOS 7) and background image. A full panel is just one method away!" image:[UIImage imageNamed:@"ForkImage.png"]];
```

And here are the end results

![Panel1](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%203.09.52%20PM.png)
![Panel2](https://raw.github.com/MatthewYork/MYBlurIntroductionView/master/Resources/Images/iOS%20Simulator%20Screen%20shot%20Oct%2017,%202013%203.09.56%20PM.png)
