# Yamlet

  Yamlet is a tiny library (< 100 lines of code) which injects CRUD
functionalities to your Plain Old Ruby Objects and store data on a YAML file using
[YAML::Store].

  Perfect for creating small applications **(for demo/prototyping purposes)**
where you only need a single YAML file to store everything and removes the
constraint of setting up a database.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'yamlet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yamlet

Usage
--------

### Configuration

First, create a YAML file somewhere then tell Yamlet where to find that file which we'll be using for storing data.

```ruby
Yamlet.repository_file = "/path/to/repository.yml"
```

**NOTE: A `RepositoryNotFound` error will be raised when Yamlet can't locate the YAML file.**

### Using Yamlet with Classes

```ruby
class User
  include Yamlet.model

  #...
end
```

After including `Yamlet.model` in your class, notice that the YAML file will
automatically be updated.

```yaml
# /path/to/repository.yml

---
user: []
```

### Methods


#### `.all`


```ruby
  User.all   #=> []
  User.create(name: "Grumpy Kid")

  User.all #=> [{"id"=>1, "name"=>"Grumpy Kid"}]
```

#### `.find`

```ruby
  User.find(1) #=> {"id"=>1, "name"=>"Grumpy Kid"}
```

#### `.create`

```ruby
  User.create(name: "Grumpy Kid")
  #=> {"id"=>1, "name"=>"Grumpy Kid"}
```

#### `.update`

```ruby
  User.update(1, name: "Grumpy Dad")
  #=> {"id"=>1, "name"=>"Grumpy Dad"}
```

#### `.destroy`

```ruby
  User.destroy(1)

  User.all #=> []
```

#### `.destroy_all`

```ruby
  5.times { |i| User.create(name: "Grumpy #{i}") }

  User.destroy_all #=> []
```

## Run the tests

```terminal
$ rspec spec
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/yamlet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[YAML::Store]: http://ruby-doc.org/stdlib-2.1.0/libdoc/yaml/rdoc/YAML/Store.html
