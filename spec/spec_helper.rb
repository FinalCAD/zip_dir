Bundler.require(:default, :test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zip_dir'

module SpecHelper
  def glob(path)
    Dir["#{path}/**/*"].sort
  end

  def clean_glob(path)
    glob(path).map { |subpath| subpath.gsub(path,'') }
  end

  def test_images(path)
    file_contents = File.read("spec/fixtures/single/single_image.png")
    image_paths = glob(path).keep_if {|path| path.match /\.png\z/}
    expect(image_paths.map { |path| File.new(path).read == file_contents }.all?).to eql true
  end
end
RSpec.configure do |config|
  config.include SpecHelper
end