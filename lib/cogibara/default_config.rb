require 'yaml'
Cogibara.setup_dispatcher do |dispatcher|
  yml = YAML.load("---\nname: cucumber\nspeak: false\nhard_parse: true\nsoft_parse: true\nmodules:\n- module_name: chat\n  keywords:\n  - talk\n  - chat\n- module_name: translate\n  keywords: translate\n- module_name: Wolfram Alpha\n  keywords: ask\n  file_name: wolfram_alpha\n  API_KEY: \n- module_name: Wiki\n  keywords: wiki\n- module_name: Maluuba\n  keywords:\n  - maluuba\n  - parse\n  file_name: soft_parser\n  API_KEY: \n- module_name: Reminder Setter\n  keywords: REMINDER\n- module_name: Calendar\n  keywords: CALENDAR\n  username: \n  password: \n- module_name: Knowledge\n  keywords: KNOWLEDGE\n  WOLFRAM_KEY: \n- module_name: Weather\n  keywords: WEATHER\n  API_KEY: \n- module_name: Help\n  keywords: HELP\n")
  dispatcher.config_from_yaml(yml)
  # dispatcher.register_operator(["REMINDER"],{name: "Reminder Setter"})
end