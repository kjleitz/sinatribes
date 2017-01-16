# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app (Yup)
- [x] Use ActiveRecord for storing information in a database (Yup, all models inherit from ActiveRecord::Base and tables are set up by migration)
- [x] Include more than one model class (list of model class names e.g. User, Post, Category) (See them in app/models/)
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Posts) (User has many tribes, tribe has many resources, has many buildings, etc.)
- [x] Include user accounts (Yup)
- [x] Ensure that users can't modify content created by other users (Yup, sensitive routes are condition-blocked by logged_in and current_user_tribe)
- [x] Include user input validations (Happens in user signup, tribe management, etc.)
- [x] Display validation failures to user with error message (example form URL e.g. /posts/new) (Errors are flashed to the top of the screen)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code (Yup)

Confirm
- [x] You have a large number of small Git commits (Yup)
- [x] Your commit messages are meaningful (Yup)
- [x] You made the changes in a commit that relate to the commit message (Yup)
- [x] You don't include changes in a commit that aren't related to the commit message (Yup)
