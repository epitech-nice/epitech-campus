class HomePageController
	constructor: () ->
		if (twttr?) then twttr.widgets.load()
