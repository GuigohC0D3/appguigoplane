import 'package:flutter/material.dart';
import 'package:book_my_seat/book_my_seat.dart';

class SeatSelectionWidget extends StatefulWidget {
  final Function(List<String>) onSelectedSeatsChanged;

  const SeatSelectionWidget({Key? key, required this.onSelectedSeatsChanged}) : super(key: key);

  @override
  _SeatSelectionWidgetState createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  late List<List<SeatState>> seatStates;

  @override
  void initState() {
    super.initState();
    seatStates = List.generate(
      10,
      (_) => List.generate(6, (_) => SeatState.unselected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SeatLayoutWidget(
      onSeatStateChanged: (rowIndex, colIndex, updatedSeatState) {
        setState(() {
          seatStates[rowIndex][colIndex] = updatedSeatState;
        });

        List<String> selectedSeats = [];
        for (int i = 0; i < seatStates.length; i++) {
          for (int j = 0; j < seatStates[i].length; j++) {
            if (seatStates[i][j] == SeatState.selected) {
              selectedSeats.add('${String.fromCharCode(65 + i)}${j + 1}');
            }
          }
        }

        widget.onSelectedSeatsChanged(selectedSeats);
      },
      stateModel: SeatLayoutStateModel(
        rows: 10,
        cols: 6,
        seatSvgSize: 40,
        pathUnSelectedSeat: 'assets/svg/seat_available.svg',
        pathSelectedSeat: 'assets/svg/seat_selected.svg',
        pathSoldSeat: 'assets/svg/seat_occupied.svg',
        pathDisabledSeat: 'assets/svg/seat_reserved.svg',
        currentSeatsState: seatStates,
      ),
    );
  }
}
