# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'livereload' do
  extensions = {
    css: :css,
    scss: :scss,
    sass: :sass,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg
    # less: :less, # uncomment if you want LESS stylesheets done in browser
  }

  rails_view_exts = %w[erb haml slim]

  # file types LiveReload may optimize refresh for
  compiled_exts = extensions.values.uniq
  watch(%r{public/.+\.(#{compiled_exts * '|'})})

  extensions.each do |ext, type|
    watch(%r{
          (?:app|vendor)
          (?:/assets/\w+/(?<path>[^.]+) # path+base without extension
           (?<ext>\.#{ext})) # matching extension (must be first encountered)
          (?:\.\w+|$) # other extensions
          }x) do |m|
      path = m[1]
      "/assets/#{path}.#{type}"
    end
  end

  # file needing a full reload of the page anyway
  watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})
end

guard :shell, all_on_start: true do
  @modified_times ||= {}
  def check_time(file)
    mtime = File.mtime(file)
    return if @modified_times[file] == mtime
    @modified_times[file] = mtime
    yield file
  end

  if File.exist?('.rubocop.yml')
    @rubocop_exclude ||= YAML.safe_load(File.read('.rubocop.yml')).dig('AllCops', 'Exclude').map { |x| Dir[x] }.flatten
  end

  # rubocop
  watch %r{^(app|config|db)/.*\.rb$|^(config.ru|Gemfile|Guardfile|Rakefile)$} do |match|
    check_time(match[0]) do |file|
      system %(bundle exec rubocop --format quiet -a '#{file}') unless @rubocop_exclude&.include?(file)
    end
  end

  # eslint
  watch %r{^app/assets/javascripts/.*\.js$|^config/webpack/.*\.js$|^[\w\-.]*\.js$} do |match|
    check_time(match[0]) do |file|
      system %(./node_modules/eslint/bin/eslint.js --fix #{file})
    end
  end

  # sass-lint
  watch %r{^app/assets/stylesheets/.*\.scss$} do |match|
    check_time(match[0]) do |file|
      system %(sass-lint --cache --config .sass-lint.yml '#{file}' --verbose --no-exit)
    end
  end
end
