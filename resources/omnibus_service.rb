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

resource_name :omnibus_service

actions %i(start stop restart hup int kill gracefull_kill once)

default_action :nothing

property :ctl_command, String
property :service_name, String, regex: %r{[\w-]+\/[\w-]+}, name_property: true

%w(start stop restart hup int kill graceful-kill once).each do |sv_command|
  action sv_command.tr('-', '_').to_sym do
    execute "#{omnibus_ctl_command} #{sv_command} #{omnibus_service_name.last}"
  end
end

def omnibus_ctl_command
  ctl_command || product_lookup(omnibus_service_name.first)['ctl-command']
end

def omnibus_service_name
  service_name.split('/')
end