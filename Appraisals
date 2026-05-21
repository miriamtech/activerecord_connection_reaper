ruby_version = Gem::Version.new(RUBY_VERSION)

appraise 'rails-5.1' do
  gem 'activerecord', '~> 5.1.0'
  gem 'railties', '~> 5.1.0'
  gem 'base64', '~> 0.3'
  gem 'bigdecimal', '~> 4.0'
  gem 'mutex_m', '~> 0.3'
  gem 'sqlite3', '~> 1.3'
end

appraise 'rails-5.2' do
  gem 'activerecord', '~> 5.2.0'
  gem 'railties', '~> 5.2.0'
  gem 'base64', '~> 0.3'
  gem 'bigdecimal', '~> 4.0'
  gem 'mutex_m', '~> 0.3'
  gem 'sqlite3', '~> 1.3'
end

appraise 'rails-6.0' do
  gem 'activerecord', '~> 6.0.0'
  gem 'railties', '~> 6.0.0'
  gem 'concurrent-ruby', '<= 1.3.4'
  gem 'base64', '~> 0.3'
  gem 'bigdecimal', '~> 4.0'
  gem 'mutex_m', '~> 0.3'
  gem 'sqlite3', '~> 1.3'
end

appraise 'rails-6.1' do
  gem 'activerecord', '~> 6.1.0'
  gem 'railties', '~> 6.1.0'
  gem 'concurrent-ruby', '<= 1.3.4'
  gem 'base64', '~> 0.3'
  gem 'bigdecimal', '~> 4.0'
  gem 'mutex_m', '~> 0.3'
  gem 'sqlite3', '~> 1.3'
end

if ruby_version >= Gem::Version.new('2.7.0')
  appraise 'rails-7.0' do
    gem 'activerecord', '~> 7.0.0'
    gem 'railties', '~> 7.0.0'
    gem 'sqlite3', '~> 1.4'
  end

  appraise 'rails-7.1' do
    gem 'activerecord', '~> 7.1.0'
    gem 'railties', '~> 7.1.0'
  end
end

if ruby_version >= Gem::Version.new('3.1.0')
  appraise 'rails-7.2' do
    gem 'activerecord', '~> 7.2.0'
    gem 'railties', '~> 7.2.0'
  end
end

if ruby_version >= Gem::Version.new('3.2.0')
  appraise 'rails-8.0' do
    gem 'activerecord', '~> 8.0.0'
    gem 'railties', '~> 8.0.0'
  end
end
