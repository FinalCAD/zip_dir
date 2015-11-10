# ZipDir

Zip and unzip directories.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zip_dir'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zip_dir

## Usage

```ruby
# Zip
zipper = ZipDir::Zipper.new(__optional_filename__)

zip_file = zipper.generate(__some_path_to_directory__)

# alternative generate call below (don't call both!)
zip_file = zipper.generate do |z|
  z.add_path __some_path_to_directory__
  z.add_path __another_path_to_directory__ # does a shell "cp -r" operation
end

zip_file == zipper.file # => true


# Unzip
unzip_path = ZipDir::Unzipper.new(zip_file.path).unzip_path
```

## dir_model
Use [`dir_model`](https://github.com/FinalCAD/dir_model) to create complex directories to zip.