#
# Postfacto, a free, open-source and self-hosted retro tool aimed at helping
# remote teams.
#
# Copyright (C) 2016 - Present Pivotal Software, Inc.
#
# This program is free software: you can redistribute it and/or modify
#
# it under the terms of the GNU Affero General Public License as
#
# published by the Free Software Foundation, either version 3 of the
#
# License, or (at your option) any later version.
#
#
#
# This program is distributed in the hope that it will be useful,
#
# but WITHOUT ANY WARRANTY; without even the implied warranty of
#
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#
# GNU Affero General Public License for more details.
#
#
#
# You should have received a copy of the GNU Affero General Public License
#
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe 'Alex', type: :feature, js: true do
  describe 'on the users page' do
    context 'when a user has retros' do
      before(:all) do
        register('user-with-retros')
        create_public_retro
        logout
      end

      specify 'can not delete that user' do
        visit_active_admin_page

        fill_in 'admin_user_email', with: 'admin@example.com'
        fill_in 'admin_user_password', with: 'secret'
        click_on 'Login'

        click_on 'Users'
        fill_in 'q_email', with: 'user-with-retros'
        click_on 'Filter'
        click_on 'Delete'

        expect(page).to have_content 'user-with-retros'
      end
    end

    context 'when a user does not have retros' do
      before(:all) do
        register('user-without-retros')
        logout
      end

      specify 'can delete that user' do
        visit_active_admin_page

        fill_in 'admin_user_email', with: 'admin@example.com'
        fill_in 'admin_user_password', with: 'secret'
        click_on 'Login'

        click_on 'Users'
        fill_in 'q_email', with: 'user-without-retros'
        click_on 'Filter'
        click_on 'Delete'

        expect(page).to_not have_content 'user-without-retros'
      end
    end
  end

  describe 'on the retros page' do
    specify 'can create a new retro' do
      visit_active_admin_page

      fill_in 'admin_user_email', with: 'admin@example.com'
      fill_in 'admin_user_password', with: 'secret'
      click_on 'Login'

      click_on 'Retros'
      click_on 'New Retro'

      fill_in 'retro_name', with: 'My awesome new retro'
      fill_in 'retro_slug', with: 'my-awesome-new-retro'
      fill_in 'retro_password', with: 'secret'

      click_on 'Create Retro'

      expect(page).to have_content 'My awesome new retro'
    end

    specify 'can change the owner to another user' do
      register('old-retro-owner')
      create_public_retro('Retro needs new owner')
      register('new-retro-owner')
      logout

      visit_active_admin_page

      fill_in 'admin_user_email', with: 'admin@example.com'
      fill_in 'admin_user_password', with: 'secret'
      click_on 'Login'

      click_on 'Retros'
      fill_in 'q_name', with: 'Retro needs new owner'
      click_on 'Filter'

      click_on 'Edit'

      expect(page).to have_content 'Owner Email'
      expect(find_field('retro_owner_email').value).to eq 'old-retro-owner@example.com'

      fill_in 'retro_owner_email', with: 'new-retro-owner@example.com'

      click_on 'Update Retro'

      first(:link, 'Retros').click
      fill_in 'q_name', with: 'Retro needs new owner'
      click_on 'Filter'

      click_on 'Edit'

      expect(find_field('retro_owner_email').value).to eq 'new-retro-owner@example.com'
    end

    specify 'the new owner email does not match any user' do
      register('unwanting-retro-owner')
      create_public_retro('Not wanted retro')
      logout

      visit_active_admin_page

      fill_in 'admin_user_email', with: 'admin@example.com'
      fill_in 'admin_user_password', with: 'secret'
      click_on 'Login'

      click_on 'Retros'
      fill_in 'q_name', with: 'Not wanted retro'
      click_on 'Filter'

      click_on 'Edit'

      fill_in 'retro_owner_email', with: 'wrong@example.com'

      click_on 'Update Retro'
      expect(page).to have_content 'Could not change owners. User not found by email.'
    end
  end
end
