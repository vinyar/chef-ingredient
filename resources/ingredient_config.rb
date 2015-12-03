#
# Author:: Joshua Timberman <joshua@chef.io
# Copyright (c) 2015, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative '../libraries/helpers'
include ChefIngredientCookbook::Helpers

resource_name :ingredient_config

actions :render, :add
default_action :render

property :product_name, String, name_property: true
property :sensitive, [TrueClass, FalseClass], default: false
property :config, String, default: nil

action :render do
  target_config = product_matrix[product_name]['config-file']
  return if target_config.nil?

  directory ::File.dirname(target_config) do
    recursive true
    action :create
  end

  file target_config do
    action :create
    sensitive new_resource.sensitive
    content get_config(product_name)
  end
end

action :add do
  add_config(product_name, config)
end
