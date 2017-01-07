# Gourmet Map

# Create a Gourmet Map
```console
$ rails new gourmet_map
```

### Add some gems
```console
gem 'therubyracer'
gem 'devise'
gem 'simple_form', github: 'kesha-antonov/simple_form', branch: 'rails-5-0'
gem 'haml', '~> 4.0.5'
gem 'bootstrap-sass', '~> 3.2.0.2'
gem 'paperclip', '~> 4.2.0'
gem 'acts_as_votable', '~> 0.10.0'
```

```console
Under `Gemfile`, add `gem 'therubyracer'`, save and run `bundle install`.      

Note: 
Because there is no Javascript interpreter for Rails on Ubuntu Operation System, we have to install `Node.js` or `therubyracer` to get the Javascript interpreter.
```

```console
$ bundle install
```

Then run the `rails server` and go to `http://localhost:3000` to make sure everything is correct.


# CRUD of restaurant by using scaffold
```console
$ rails g scaffold restaurant name:string address:string phone1:string phone2:string note:text vegetarian:boolean
$ rake db:migrate
```

# Image Uploading
https://github.com/thoughtbot/paperclip

After add `paperclip` to our Gemfile, the next thing we need to do is add `has_attached_file` and `validates_attachment_content_type` inside of our class of image uploading. So we paste it to
`app/models/post.rb`

```ruby
class Restaurant < ApplicationRecord
	has_attached_file :image, styles: { medium: "700x500#", small: "350x250>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ 
end
```

Next, we need to run the migration for the restaurant model and the image upload.

```console
$ rails generate paperclip restaurant image
$ rake db:migrate
```
Then we need to add file upload to our form.
Under `app/views/restaurant/_form.html.erb`
```html
...

  <div class="field">
    <%= f.label :image %>
    <%= f.text_field :image %>
  </div>
...
```

Next, we need to also permit this `:image` attribute inside of our controller.
In `app/controllers/restaurants_controller.rb`
```ruby
def restaurant_params
  params.require(:restaurant).permit(:image, :name, :address, :phone1, :phone2, :note, :vegetarian)
end
```

Next, we want the image to show up inside of our show page and root page.
So in `app/views/restaurants/show.html.erb`
```html

	<p>
	  <strong>Image:</strong>
	  <%= image_tag @restaurant.image.url(:medium) %>
	</p>
```

In `app/views/restaurants/index.html.erb`, we add `Image` and `<td><%= image_tag restaurant.image.url(:small) %></td>`
```html

	<table>
	  <thead>
	    <tr>
	      <th>Image</th>
	      <th>Name</th>
	      <th>Address</th>
	      <th>Phone1</th>
	      <th>Phone2</th>
	      <th>Note</th>
	      <th>Vegetarian</th>
	      <th colspan="3"></th>
	    </tr>
	  </thead>

	  <tbody>
	    <% @restaurants.each do |restaurant| %>
	      <tr>
	        <td><%= image_tag restaurant.image.url(:small) %></td>
	        <td><%= restaurant.name %></td>
	        <td><%= restaurant.address %></td>
	        <td><%= restaurant.phone1 %></td>
	        <td><%= restaurant.phone2 %></td>
	        <td><%= restaurant.note %></td>
	        <td><%= restaurant.vegetarian %></td>
	        <td><%= link_to 'Show', restaurant %></td>
	        <td><%= link_to 'Edit', edit_restaurant_path(restaurant) %></td>
	        <td><%= link_to 'Destroy', restaurant, method: :delete, data: { confirm: 'Are you sure?' } %></td>
	      </tr>
	    <% end %>
	  </tbody>
	</table>
```
![image](https://github.com/TimingJL/gourmet_map/blob/master/pic/image_uploading.jpeg)

# Categories
The next thing we need to do is add categories to our restaurants.
To do that, I'm going to create a model for our categories.
```console
$ rails g model Category name:string
$ rake db:migrate
```

Then we need to add a category_id to our article's table. That is bacause we wanna associate the categories to the restaurants.
```console
$ rails g migration add_category_id_to_restaurants category_id:integer
$ rake db:migrate
```

In `app/models/restaurant.rb`
```ruby
class Restaurant < ApplicationRecord
	belongs_to :category
	has_attached_file :image, styles: { medium: "700x500#", small: "350x250>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ 
end
```

In `app/models/category.rb`
```ruby
class Category < ApplicationRecord
	has_many :restaurants
end
```

Let's pop into the rails console to create a few categories to work with.
```console
$ rails c

> Category.connection
> Category.create(name: "飲料店")
> Category.create(name: "早餐店")
> Category.create(name: "小吃店")
> Category.create(name: "餐廳/便當/小館")

> Category.all

#if you want to delete the cateory of ID=1.
> Category.delete(1)
```

In `app/controllers/restaurants_controller.rb`, we need to permit the category_id so it can save to the database, otherwise rails will ignore it.
```ruby
def restaurant_params
  params.require(:restaurant).permit(:category_id, :image, :name, :address, :phone1, :phone2, :note, :vegetarian)
end
```

To show the category, we need to add selected field in create/edit page and add column to the show/root page.

In `app/views/_form.html.erb`
```html

  <div class="field">
    <%= f.label :category_id %>
    <%= f.collection_select :category_id, Category.all, :id, :name, { promt: "Choose a category" } %>
  </div>
```

In `app/views/show.html.erb`
```html

	<p>
	  <strong>Category:</strong>
	  <%= @restaurant.category.name %>
	</p>
```

In `app/views/index.html.erb`, we add `<th>Category</th>` and `<td><%= restaurant.category.name %></td>` to the table.

![image](https://github.com/TimingJL/gourmet_map/blob/master/pic/select.jpeg)
![image](https://github.com/TimingJL/gourmet_map/blob/master/pic/category.jpeg)