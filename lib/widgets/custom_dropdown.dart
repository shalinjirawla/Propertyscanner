/**
 * Created by Jaimin on 28/02/25.
 */

import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/config.dart';


class CommonDropdown extends StatefulWidget {
  final List<String>? items;
  final String? hint;
  final Color? dropColor;
  final ValueChanged<String>? onChanged;

  const CommonDropdown({
    super.key,
    this.items,
    this.hint,
    this.onChanged,
    this.dropColor,
  });

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;
  String? selectedItem;

  final LayerLink _layerLink = LayerLink();

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isDropdownOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeDropdown,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                width: size.width,
                left: offset.dx,
                top: offset.dy + size.height + 5,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height + 5),
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.items!.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => selectedItem = item);
                                widget.onChanged!(item);
                                _closeDropdown();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5),
                                  ),
                                ),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleDropdown,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              color: widget.dropColor ?? white,
              borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedItem ?? widget.hint!,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                  isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
