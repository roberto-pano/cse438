Roberto Panora - 490453 - CSE438


YOU NEED TO SELECT A COLOR BEFORE DRAWING!!!!! Just in case haha



REGRADE: Added two lines into Info.plst that ask for permission (they were left out by mistake)

Added the security method to the top of ViewController and then called it from the @IBAction saveImage function to prompt the first time then it will work. The reason I didn't include it was because I tested on two devices where it worked and it must have gotten lost in translation, but it was fully functional on my end for two devices





Creative Portion:

I have a save button which then leads to my two creative portions:

1) It saves the current drawing view as an image then uploads it to iPhotos album. To do this I needed to add a method to UIView that allows you to convert the view into an image then I needed to use a process to then save the image to the photo album. Then you can import an image from the photo album as your new background and it perfectly scales the old drawingViews to fit (other images it will also work but will look distorted because they were not on scale with the drawing view but they still work and looks good!). Users can then edit on the current background and save it again!. To check to see if images are saved to the photo album feel free to check it in Photos!! The import background button will open a window that allows users to view all their photos in the photo album and select one to be the new background. Another thing I had to do was edit my Info file to allow my app to get access to Photo Album (a different one for both adding and selecting photos) which was super interesting as well to delve into. 


2) With the save function I also allow users to access old drawing views that are stored in a dictionary. Once the save button is pressed an alert prompting text input will appear and once you click "SAVE" the alert disappears, the drawing view clears and there will be an entry in the UITableView on the bottom right of the screen. If you click the "Blank" cell it will clear the drawing view to allow users to start fresh (an alternative to the clear button). This allows people to start fresh while still being able to access old projects. The UITableView was the best choice as it is scrollable so it is easy to maneuver through old drawing views. The string will be used to parse a dictionary which has Shape arrays as the values.


3) Not sure if it counts but for the extra credit I implemented a switch that informs the users whether the shapes are being made outlined or solid.

