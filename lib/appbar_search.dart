/// BSD 3-clause license
/// ("BSD License 2.0", "Revised BSD License", "New BSD License", or "Modified BSD License")
///
/// Copyright (c) 2020, Andrious Solutions Ltd.
/// All rights reserved.
///
/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions are met:
///
/// * Redistributions of source code must retain the above copyright
/// notice, this list of conditions and the following disclaimer.
///
/// * Redistributions in binary form must reproduce the above copyright
/// notice, this list of conditions and the following disclaimer in the
/// documentation and/or other materials provided with the distribution.
///
/// * Neither the name of the organization, Andrious Solutions Ltd., nor the
/// names of its contributors may be used to endorse or promote products
/// derived from this software without specific prior written permission.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
/// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
/// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
/// DISCLAIMED. IN NO EVENT SHALL Andrious Solutions Ltd. BE LIABLE FOR ANY
/// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
/// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
///
///               Created  24 January, 2020
///
import 'package:flutter/material.dart';

class AppBarSearch {
  AppBarSearch({
    @required this.state,
    this.title,
    this.hintText = "search...",
    this.onPressed,
    this.controller,
    this.onSubmitted,
    this.onEditingComplete,
  }) {
    //
    title ??= Text("search...");

    _hintText = hintText;

    _onPressed = onPressed ?? _pressedFunc;

    _appBarTitle = GestureDetector(
      child: title,
      onTap: _onPressed,
    );

    // title is now a GestureDetector widget.
    title = _appBarTitle;

    _onSubmitted = onSubmitted;

    _onEditingComplete = onEditingComplete;

    _icon = Icon(Icons.search);

    _textController = controller ?? TextEditingController();

    // Flag indicating user tapped to initiate search.
    _wasPressed = false;
  }
  final State state;
  Widget title;
  final String hintText;
  final VoidCallback onPressed;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;

  Widget _appBarTitle;
  String _hintText;
  VoidCallback _onPressed;
  TextEditingController _textController;
  ValueChanged<String> _onSubmitted;
  VoidCallback _onEditingComplete;

  Icon _icon;
  bool _wasPressed;

  IconButton get searchIcon => IconButton(
    icon: _icon,
    onPressed: _onPressed,
  );

  Widget onTitle(Widget title) {
    // title already defined.
    if (_wasPressed) return this.title;

    if (title != null && title is! GestureDetector) {
      _appBarTitle = GestureDetector(
        child: title,
        onTap: _onPressed,
      );
    }
    return _appBarTitle;
  }

  IconButton onSearchIcon({
    String hintText,
    TextEditingController controller,
    ValueChanged<String> onSubmitted,
    VoidCallback onEditingComplete,
  }) {
    if (hintText != null) _hintText = hintText;
    if (controller != null) _textController = controller;
    if (onSubmitted != null) _onSubmitted = onSubmitted;
    if (onEditingComplete != null) _onEditingComplete = onEditingComplete;
    return searchIcon;
  }

  void _pressedFunc() {
    _wasPressed = true;
    if (_icon.icon == Icons.search) {
      _icon = Icon(Icons.close);
      title = TextField(
        controller: _textController,
        textInputAction: TextInputAction.search,
        onSubmitted: _submitFunc,
        onEditingComplete: _onEditingComplete,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: _hintText,
        ),
      );
    } else {
      _icon = Icon(Icons.search);
      title = _appBarTitle;
      _textController.clear();
    }
    // Display the change in the app's title
    state.setState(() {});
  }

  void _submitFunc(String value) {
    _pressedFunc();
    if (_onSubmitted != null) {
      _onSubmitted(value);
    } else if (onSubmitted != null) onSubmitted(value);
  }
}