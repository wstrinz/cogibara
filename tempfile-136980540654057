require 'yaml'
Cogibara.setup_dispatcher do |dispatcher|
  yml = YAML.load_file('/home/wstrinz/Documents/Projects/speechrecog/config.yml')
  dispatcher.config_from_yaml(yml)
  # dispatcher.register_operator(["REMINDER"],{name: "Reminder Setter"})
end