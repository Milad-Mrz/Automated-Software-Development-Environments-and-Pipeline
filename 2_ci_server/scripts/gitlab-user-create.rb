#!/usr/bin/env ruby

user = User.new()
user.email = "vagrant@vagrant.com"
user.name = "vagrant"
user.username = "vagrant"
user.password = "12345678"
user.password_confirmation = "12345678"
user.skip_confirmation!
user.save!

token = PersonalAccessToken.new
token.user_id = User.find_by(username: 'vagrant').id
token.name = 'default'
token.scopes = ["api"]
token.set_token('ypCa3Dzb2365nvsixwPP')
token.save!
