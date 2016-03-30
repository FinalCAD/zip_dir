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
#
# Zip
#
zipper = ZipDir::Zipper.new("optional_filename")

zip_file = zipper.generate("some/path/to/directory")
zip_file # => #<Tempfile:/var/folders/6c/s4snqy051jqdpbjw7f7tsn940000gn/T/zipper-20151127-19694-1baaqoi.zip>
zip_file == zipper.file # => true

# to zip multiple directories
zip_file = zipper.generate do |z|
  z.add_path "some/path/to/directory"
  z.add_path "another/path/to/directory" # does a shell "cp -r" operation
end

# to zip __just the paths inside the directory___
zip_file = zipper.generate("some/path/to/directory", root_directory: true)
# for multiple directories again
zip_file = zipper.generate do |z|
  z.add_path "some/path/to/directory", root_directory: true
end

# cleanup temporary directory
zipper.cleanup

#
# Unzip
#
ZipDir::Unzipper.new(zip_file.path).unzip_path # => "/var/folders/6c/s4snqy051jqdpbjw7f7tsn940000gn/T/d20151127-22683-a9vrnv"
```

## Dir Interface
`ZipDir::Zipper` subclasses `ZipDir::Dir`, which copies paths into a temporary directory to zip. There are several options for copying files and directories:

```ruby
ZipDir::Zipper.superclass # => ZipDir::Dir

dir = ZipDir::Dir.new
dir.generate("some/path" options_described_below)
dir.generate do |d|
  d.add_path "some/path", options_described_below
end

dir.cleanup
```

```ruby
# Directories
{ root_directory: true } # copies each file and directory path within the given directory path
{ flatten_directories: true } # copies all file paths with no directory structure copied (may override files)
{ extension: :gif || ["gif", "txt"] || "*" } # filters file extensions of paths, used with options listed above
{ glob: "custom_glob" } # copies the paths resulting from the custom glob

# Files and Directories
{ rename: "new_name_with_smart_extension_handling" }
```

## dir_model
Use [`dir_model`](https://github.com/FinalCAD/dir_model) to create complex directories to zip.