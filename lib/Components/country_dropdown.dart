import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryDropdown extends StatefulWidget {
  @override
  _CountryDropdown createState() => _CountryDropdown();
}

class _CountryDropdown extends State<CountryDropdown> {
  String selectedCountry = 'USA';
  bool isDropdownOpened = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                if (isDropdownOpened) {
                  _closeDropdown();
                } else {
                  _openDropdown();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(

                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedCountry),
                    Icon(
                      isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height + 8.h,
        child: Material(
          elevation: 2.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <String>['USA', 'Nepal', 'Vietnam']
                .map(
                  (String country) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCountry = country;
                    _closeDropdown();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(country),
                ),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
    setState(() {
      isDropdownOpened = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isDropdownOpened = false;
    });
  }
}


