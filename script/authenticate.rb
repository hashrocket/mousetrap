settings = YAML.load_file(File.expand_path('../cheddar_getter.yml', __FILE__))
Mousetrap.authenticate settings['user'], settings['password']
Mousetrap.product_code = settings['product_code']
