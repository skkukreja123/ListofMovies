// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:state_managment/viewmodel/movie_view.dart';

// class GenreScreen extends StatefulWidget {
//   final int genre;
//   const GenreScreen({required this.genre, super.key});

//   @override
//   State<GenreScreen> createState() => _GenreScreenState();
// }

// class _GenreScreenState extends State<GenreScreen> {
//   void initState() {
//     super.initState();
//     Future.microtask(() => Provider.of<MovieViewModel>(context, listen: false)
//         .getMovieThroughGenre(widget.genre as String));
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Table for Genre Movies'),
//       ),
//       // body: Column(
//         children: [
//           Table(
//             border: TableBorder.all(),
//             columnWidths: const {
//               0: FlexColumnWidth(3),
//               1: FlexColumnWidth(2),
//               2: FlexColumnWidth(2),
//               3: FlexColumnWidth(2),
//             },
//             children: [
//               // Header row
//               const TableRow(
//                 decoration: BoxDecoration(color: Colors.grey),
//                 children: [
//                   Padding(padding: EdgeInsets.all(8), child: Text('Genre')),
//                   Padding(padding: EdgeInsets.all(8), child: Text('Movie Id')),
//                   Padding(
//                       padding: EdgeInsets.all(8), child: Text('Movie Name')),
//                   Padding(padding: EdgeInsets.all(8), child: Text('Count')),
//                 ],
//               ),
//               // Data rows
//               ...List.generate(cart.products.length, (index) {
//                 final product = cart.products[index];
//                 return TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text(product.name),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: TextField(
//                         keyboardType: TextInputType.number,
//                         controller: TextEditingController(
//                             text: product.quantity.toString()),
//                         onSubmitted: (value) {
//                           final qty = int.tryParse(value) ?? 1;
//                           cart.updateQuantity(index, qty);
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text('\$${product.price.toStringAsFixed(2)}'),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text('\$${product.total.toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 );
//               }),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Total Cost: \$${cart.totalCost.toStringAsFixed(2)}',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     // );


//   }
// }
