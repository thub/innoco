I18n.load_path += Dir[ File.join(RAILS_ROOT, 'config', 'locales', '*.{rb,yml}') ]
I18n.backend.send(:init_translations)
I18n.default_locale = "no-NB" 
Locale.default = "no-NB"