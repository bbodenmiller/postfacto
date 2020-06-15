/*
 * Postfacto, a free, open-source and self-hosted retro tool aimed at helping
 * remote teams.
 *
 * Copyright (C) 2016 - Present Pivotal Software, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 *
 * it under the terms of the GNU Affero General Public License as
 *
 * published by the Free Software Foundation, either version 3 of the
 *
 * License, or (at your option) any later version.
 *
 *
 *
 * This program is distributed in the hope that it will be useful,
 *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *
 * GNU Affero General Public License for more details.
 *
 *
 *
 * You should have received a copy of the GNU Affero General Public License
 *
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import React from 'react';
import '../../spec_helper';
import {mount} from 'enzyme';
import MuiThemeProvider from "material-ui/styles/MuiThemeProvider";
import ShareRetroDialog from "./share_retro_dialog";

describe('ShareRetroDialog', () => {

  it('copies the retro url in the clipboard when the copy button is clicked', async () => {
    document.execCommand = jest.fn();
    mountShareRetroDialog();
    getDialogElement().querySelector('.share-retro-url-copy').click();
    expect(document.execCommand).toHaveBeenCalledWith('copy');
  })

  it('invokes onClose when the close button is clicked', () => {
    const onClose = jest.fn();
    mountShareRetroDialog({
      onClose: onClose,
    });

    const popupDialog = getDialogElement();
    popupDialog.querySelector('.share-dialog__actions--close').click();
    expect(onClose).toHaveBeenCalled();
  })

  it('displays the current retro url', () => {
    mountShareRetroDialog();

    const retroUrl = window.location.href;

    const popupDialog = getDialogElement();
    expect(popupDialog.querySelector('p').innerHTML).toContain(retroUrl);
  })

});

function createRetro(isPrivate = false) {
  return {};
}

function mountShareRetroDialog(props) {
  return mount((
    <MuiThemeProvider>
      <ShareRetroDialog
        retro={createRetro()}
        onClose={jest.fn()}
        {...props}
      />
    </MuiThemeProvider>
  ));
}

function getDialogElement() {
  // Dialog renders outside usual flow, so must use hacks:
  return document.getElementsByClassName('share-dialog')[0];
}
