### update_yaml.py ###
#
# An unfortunate utility to update yaml values while preserving comments and order, since python yq doesn't.
# Accepts a .yaml file, key to change, and new value
# USAGE: ./util/update_yaml.py honeydeck_sensor.yml sensor_name host01
#
# Currently doesn't support nested values
# 
###

import sys
import ruamel.yaml

FILE_NAME = sys.argv[1]
YAML_KEY = sys.argv[2]
NEW_VALUE = sys.argv[3]

yaml = ruamel.yaml.YAML()

with open(FILE_NAME, "r+") as fp:
    yaml.indent(mapping=4, sequence=4, offset=4)
    yaml.preserve_quotes = True
    data = yaml.load(fp)
    data[YAML_KEY] = NEW_VALUE
    fp.seek(0)
    yaml.dump(data, fp)
    fp.truncate()
