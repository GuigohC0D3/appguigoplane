import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SeatStatus { available, selected, reserved, occupied }

class SeatMapWidget extends StatefulWidget {
  final int rows;
  final int columns;
  final void Function(List<String>) onSelectedSeatsChanged;

  const SeatMapWidget({
    super.key,
    required this.rows,
    required this.columns,
    required this.onSelectedSeatsChanged,
  });

  @override
  State<SeatMapWidget> createState() => _SeatMapWidgetState();
}

class _SeatMapWidgetState extends State<SeatMapWidget> {
  late List<List<SeatStatus>> seatStatuses;

  @override
  void initState() {
    super.initState();
    seatStatuses = List.generate(
      widget.rows,
          (_) => List.generate(widget.columns, (_) => SeatStatus.available),
    );

    // Exemplo de inicialização segura
    if (widget.rows > 0 && widget.columns > 1) {
      seatStatuses[0][0] = SeatStatus.occupied;
      seatStatuses[0][1] = SeatStatus.reserved;
    }
  }

  void _onSeatTapped(int row, int col) {
    setState(() {
      final currentStatus = seatStatuses[row][col];
      if (currentStatus == SeatStatus.available) {
        seatStatuses[row][col] = SeatStatus.selected;
      } else if (currentStatus == SeatStatus.selected) {
        seatStatuses[row][col] = SeatStatus.available;
      }
    });

    final selectedSeats = <String>[];
    for (int i = 0; i < widget.rows; i++) {
      for (int j = 0; j < widget.columns; j++) {
        if (seatStatuses[i][j] == SeatStatus.selected) {
          selectedSeats.add('${String.fromCharCode(65 + i)}${j + 1}');
        }
      }
    }
    widget.onSelectedSeatsChanged(selectedSeats);
  }

  String _getAssetForStatus(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return 'assets/svg/seat_available.svg';
      case SeatStatus.selected:
        return 'assets/svg/seat_selected.svg';
      case SeatStatus.reserved:
        return 'assets/svg/seat_reserved.svg';
      case SeatStatus.occupied:
        return 'assets/svg/seat_occupied.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.rows * widget.columns,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final row = index ~/ widget.columns;
        final col = index % widget.columns;
        final status = seatStatuses[row][col];
        final assetPath = _getAssetForStatus(status);

        return GestureDetector(
          onTap: () {
            if (status == SeatStatus.available || status == SeatStatus.selected) {
              _onSeatTapped(row, col);
            }
          },
          child: SvgPicture.asset(
            assetPath,
            width: 40,
            height: 40,
          ),
        );
      },
    );
  }
}
