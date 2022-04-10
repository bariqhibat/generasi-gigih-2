# Overview on Database Associations
Hello students! Now you have succesfully completed a simple CRUD app using MVC(Model View Controller) architecture and making it beautiful by integrating it with bootstrap and javascript. Now it is time to go to the next and last step which is to use our knowledge of database associations that we have learned in module 2 DDL & DML into use.

## Refreshment
Database terms

#### Primary Key
The PRIMARY KEY constraint uniquely identifies each record in a table. Primary keys must contain UNIQUE values, and cannot contain NULL values.

#### Foreign Key
The FOREIGN KEY is a refference to primary key on another table. 


## Database Association Type
Database have 3 types of associations:

### one-to-one
A one-to-one relationship exists when one item has exactly one of another item.

![Screenshot 2022-04-01 at 02](Screenshot%202022-04-01%20at%2002.03.36.png)

For example: a chef has exactly 1 chef license, and a chef license can only be owned by 1 chef.

#### Example table

```
Chef Table
+----+-------------------+
| id | name              |
+----+-------------------+
|  1 | Salim             |
|  2 | Adit              |
|  3 | Fauzi             |
|  4 | Tendy             |
|  5 | Bariq             |
|  6 | Zahra             |
|  7 | Ganesh            |
+----+-------------------+

Chef License Table

+----+-------------------+-------------+
| id | earn_date         | chef_id     |
+----+-------------------+-------------+
|  1 | 01/01/2022        |           1 |
|  2 | 01/02/2022        |           2 |
|  3 | 02/03/2022        |           3 |
|  4 | 03/04/2022        |           4 |
|  5 | 11/12/2022.       |           5 |
|  6 | 12/05/2022        |           6 |
+----+-------------------+-------------+
```

Notice that all chef has gotten their license except for ganesh. And as you have learned in Module 2, you can use the join query and join them by the `chef_id` to combine the tables.


### one-to-many 
A one-to-many relationship exists when a single object can be a member of many other objects. 

![Screenshot 2022-04-01 at 02](Screenshot%202022-04-01%20at%2002.32.01.png)


An example for that is a customer can have multiple orders, however, an order can only have 1 customer name printed.

### Example Table

```
Customer Table
+----+-------------------+
| id | name              |
+----+-------------------+
|  1 | Savira            |
|  2 | Zanya             |
+----+-------------------+

Order Table

+----+-------------------+-------------+
| id | order_date        | customer_id |
+----+-------------------+-------------+
|  1 | 01/01/2022        |      1      |
|  2 | 01/02/2022        |      2      |
|  3 | 02/03/2022        |      1      |
|  4 | 03/04/2022        |      1      |
|  5 | 11/12/2022.       |      2      |
|  6 | 12/05/2022        |      2      |
+----+-------------------+-------------+
```

Notice how Savira and Zanya both can have multiple orders.

One to one relationship and one to many relationship have very strong similarity which is the primary key in a table has a foreign key on the other table. The only difference is that one to one relationship can only have unique foreign key, meanwhile in one to many, there can be multiple same foreign keys. 

### many-to-many 
A many-to-many relationship exists when the first object is related to one or more of a second object, and the second object is related to one or many of the first object.

For example an order can have multiple items and an item can have multiple orders. Normally this kind of relationship will create a new junction table that holds both the primary key from the entity.

For example, in this case, order and items created a new table called order_items

![Screenshot 2022-04-01 at 03](Screenshot%202022-04-01%20at%2003.17.45.png)

#### Example Table

```
Item table
+----+-------------------+-------------+
| id | name              |     price   |
+----+-------------------+-------------+
|  1 | Hamburger         |  50.000     |
|  2 | Pizza             |  80.000     |
|  3 | Coke              |  10.000     | 
|  4 | Fanta             |  10.000     | 
+----+-------------------+-------------+

Order Table

+----+-------------------+-------------+
| id | order_date        | customer_id |
+----+-------------------+-------------+
|  1 | 01/01/2022        |      1      |
|  2 | 01/02/2022        |      2      |
|  3 | 02/03/2022        |      1      |
+----+-------------------+-------------+

OrderItemsTable
+----+----------+-------------+
| id | order_id | item_id     |
+----+----------+-------------+
|  1 | 1        |      1      |
|  2 | 1        |      2      |
|  3 | 1        |      4      |
|  4 | 2        |      2      |
|  5 | 2        |      4      |
|  6 | 3        |      1      |
+----+----------+-------------+
```

As we can see the orders table and items table can be seen connected via the order items table, we called it a conjuction table which signify many to manny relationship.

# Lets gets hands on!

## One to One Relationship
Lets create the rails one to one relationship using the Chef table and Chef License table above.

### Step 1. Create the Chef database
First of all, we need to create the chef database thats looks like this

```
Chef Table
+----+-------------------+
| id | name              |
+----+-------------------+
|  1 | Salim             |
|  2 | Adit              |
|  3 | Fauzi             |
|  4 | Tendy             |
|  5 | Bariq             |
|  6 | Zahra             |
|  7 | Ganesh            |
+----+-------------------+
```


we can use the same simple command to generate the chef table by running:

```
$ rails generate model Chef
```

As usual, you should see the migration and active record models created.

go to the database migration at `db/migrate/[timestamp]_create_chef.rb`

You will see it is still empty
![Screenshot 2022-04-01 at 04](Screenshot%202022-04-01%20at%2004.28.04.png)

As per the Chef Table, we will have 2 column `id` and `name`. In rails, the `id` or primary key don't need to be defined, as it is already automatically defined. Therefore, we just need to add the `name` with type `string`.

It should looks like:
 ![Screenshot 2022-04-01 at 04](Screenshot%202022-04-01%20at%2004.30.33.png)

### Step 2.Create the Chef License Database

We wanted to create something like this

```
Chef License Table

+----+-------------------+-------------+
| id | earn_date         | chef_id     |
+----+-------------------+-------------+
|  1 | 01/01/2022        |           1 |
|  2 | 01/02/2022        |           2 |
|  3 | 02/03/2022        |           3 |
|  4 | 03/04/2022        |           4 |
|  5 | 11/12/2022.       |           5 |
|  6 | 12/05/2022        |           6 |
+----+-------------------+-------------+
```

```
$ rails generate model ChefLicense
```

go to the database migration at `db/migrate/[timestamp]_create_chef_license.rb`

And you will see it is still empty as well. 
Therefore, fill it with the `earn date` and `chef_id` with type string.

It should looks like:
![Screenshot 2022-04-01 at 04](Screenshot%202022-04-01%20at%2004.41.35.png)

### Step 3. Create Model Relationship

Since it is one-one relationship

Under the `app/models/chef.rb` add the rails `has_one` method. It should looks like:

```
class Chef < ApplicationRecord
  has_one :chef_license
end
```

Under the `app/models/chef_license.rb` add the rails `belongs_to` method. It should looks like:

```
class ChefLicense < ApplicationRecord
  belongs_to :chef
end
```

### Step 4. Run the migration and testing

Like usual, we need to run the db migration by running
```
rake db:create
rake db:migrate
```

![Screenshot 2022-04-01 at 04](Screenshot%202022-04-01%20at%2004.44.58.png)

After the migration succesfful, we can run the `rails console`

Now we can get the chef_license from check object easily, for example

Lets create a new chef
```
Chef.create(name: "your name")
Chef.first.chef_license
```
this will reutrn `null` since we have not create the chef license.

But when we create the chef license
```
ChefLicense.create(earn_date: "01/01/2022", chef_id: 1)
```

when we run 
```
Chef.first.chef_license
```

it will return us all the details.

Congratulations, that is how simple database association is


### Homework
- Create the one to many relationship between customer table and order table.

#### Test Cases
1. I opened rails console
2. I created 2 customer
3. I created 6 orders randomly
4. When I run the customer.orders it should return correct order for the customer

For example, given this table
```
Customer Table
+----+-------------------+
| id | name              |
+----+-------------------+
|  1 | Savira            |
|  2 | Zanya             |
+----+-------------------+

Order Table

+----+-------------------+-------------+
| id | order_date        | customer_id |
+----+-------------------+-------------+
|  1 | 01/01/2022        |      1      |
|  2 | 01/02/2022        |      2      |
|  3 | 02/03/2022        |      1      |
|  4 | 03/04/2022        |      1      |
|  5 | 11/12/2022.       |      2      |
|  6 | 12/05/2022        |      2      |
+----+-------------------+-------------+
```

#### When I run

```ruby
@customer=Customer.find(1) # Get Savira as customer
@customer.orders.order_date #it should return all savira order date which are ["01/01/2022", "02/03/2022", "03/04/2022"]
```

Hint: 

1. Take a look at this page: https://guides.rubyonrails.org/association_basics.html
2. Change the `has_one` to `has_many`

