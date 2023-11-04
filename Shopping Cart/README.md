# cse438
Projects From CSE 438 Mobile App Development
Creative Portion

1. I implemented a slider for the discount percentage, a warning text that is prompted when a user adds too many decimals to either sales tax or original price. I also changed the keyboard type for original price and sales tax to decimal pad to limit the input. My main creative portion is once clicking the add to cart button the item and final price will be added to a UITableView.

    Some basic usage functions is:
    - that the item field must have at least one character
    - when there are too many decimals in sales tax or original price the final price will go to zero and an error message will appear saying you have too many decimals
    - discount is limited to number between 0-100 (rounded to hundreths place for aesthetics)

2. I created a UITableView following the instructions from the apple website and then created a method for when a button was pushed that first checked to see if there is any text in the item field and if the decimal places were correct for sales tax and original price before adding it to a dictionary that would be used to update the carts cells. I also implemented a clear all button that will reset all the text fields to default text, the slider all the way to the left, and also clear the cart and dictionary in which I stored the carts contents.

3. I thought it would be fun to actually use the final price for something and creating a cart seemed like a very interactive way to store calculations. I also added the buttons for more ease of use and if people wanted to reset to what the app opens to they have the option via the clear button.
