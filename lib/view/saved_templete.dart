// import 'package:flutter/material.dart';
// import 'package:poster_app/constants/constants.dart';

// class ScreenSavedTemplete extends StatelessWidget {
//   const ScreenSavedTemplete({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
                  
//                 )),
//             title: Text(
//               'Saved Templete',
//               style: headingBlackStyle,
//             ),
//             centerTitle: true,
            
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GridView.count(
//               childAspectRatio: 0.8,
//               crossAxisCount: 2,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               children: List.generate(
//                   3,
//                   (index) => Stack(
//                     children: [
//                       Positioned.fill(
//                         child: Container(
//                               height: 250,
//                               width: 150,
//                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),image: const DecorationImage(image: AssetImage('assets/image/onam_poster.png'),fit: BoxFit.cover)),
//                             ),
//                       ),
//                       Positioned(
//                         right: 10,
//                         top: 5,
//                         child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.redAccent[700],)))
//                     ],
//                   )),
//             ),
//           )),
//     );
//   }
// }
