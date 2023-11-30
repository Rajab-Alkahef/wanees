import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class FaceWidget extends StatelessWidget {
  const FaceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Image(
            image: AssetImage(
              "assets/eye_open-01.png",
            ),
            width: 250,
            height: 250,
          ),
        ),
        Positioned(
          top: 100,
          child: Image(
            image: AssetImage("assets/mouth-01.png"),
            width: 250,
            height: 280,
          ),
        ),
      ],
    );
  }
}

class StateMachineMuscot extends StatefulWidget {
  const StateMachineMuscot({Key? key, required this.emotion}) : super(key: key);
  final String emotion;
  @override
  _StateMachineMuscotState createState() => _StateMachineMuscotState();
}

class _StateMachineMuscotState extends State<StateMachineMuscot> {
  // final String emotion;

  Artboard? riveArtboard;
  //SMIBool? isDance;
  SMITrigger? on;
  SMITrigger? off;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/flutter_animation_1.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller =
              StateMachineController.fromArtboard(artboard, 'tileBird');
          if (controller != null) {
            artboard.addController(controller);
            //isDance = controller.findSMI('on');
            on = controller.findSMI('start');
            off = controller.findSMI('off');
          }
          setState(() {
            riveArtboard = artboard;
          });
        } catch (e) {
          print(e);
        }
      },
    );

    // setState(() {
    //   if (widget.emotion == 'Happy' || widget.emotion == 'Neutral') {
    //     on?.value = true;
    //   } else {
    //     off?.value = true;
    //   }
    //   // print(widget.emotion);
    // });
  }

  // void toggleDance(bool newValue) {
  //   setState(() => isDance!.value = newValue);
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.emotion == 'Happy' || widget.emotion == 'Neutral') {
        print("rive  emotion is: ${widget.emotion}");
        on?.value = true;
      } else {
        print("rive emotion is: ${widget.emotion}");
        off?.value = true;
      }
    });
    print(" emotion is: ${widget.emotion}");

    return riveArtboard == null
        ? const SizedBox()
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Rive(
                      artboard: riveArtboard!,
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     // Text('Dance'),
                  //     // Switch(
                  //     //   value: isDance!.value,
                  //     //   onChanged: (value) => toggleDance(value),
                  //     // ),
                  //   ],
                  // ),

                  // ElevatedButton(
                  //     child: const Text('on'),
                  //     onPressed: () {
                  //       on?.value = true;
                  //     }
                  //     //  isLookUp?.value = true,P
                  //     ),

                  // ElevatedButton(
                  //   child: const Text('off'),
                  //   onPressed: () {
                  //     off?.value = true;
                  //   },
                  // ),
                ],
              ),
              Positioned(
                top: 355,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 130,
                  color: const Color(0xfffffbff),
                ),
              )
            ],
          );
  }
}

// @override
// void initState() {
//   super.initState();
//   rootBundle.load('assets/flutter_animation_1.riv').then(
//     (data) async {
//       try {
//         final file = RiveFile.import(data);
//         final artboard = file.mainArtboard;
//         var controller =
//             StateMachineController.fromArtboard(artboard, 'tileBird');
//         if (controller != null) {
//           artboard.addController(controller);
//           on = controller.findSMI('start');
//           off = controller.findSMI('off');
          
//           // Add the logic for controlling animation based on emotion
//           setState(() {
//             if (widget.emotion == 'Happy' || widget.emotion == 'Neutral') {
//               on?.value = true;
//             } else {
//               off?.value = true;
//             }
//           });
//         }
//         setState(() => riveArtboard = artboard);
//       } catch (e) {
//         print(e);
//       }
//     },
//   );
// }