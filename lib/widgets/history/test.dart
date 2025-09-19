// Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _getIconColor().withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Icon(_getIcon(), color: _getIconColor(), size: 24),
//             ),


// Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _getContentPreview(),
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   // Show final URL for QR URLs if different from original
//                   if (_shouldShowFinalUrl()) ...[
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.open_in_new,
//                           size: 12,
//                           color: Colors.grey[600],
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             'Final: ${_getFinalUrlDisplay()}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontStyle: FontStyle.italic,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         size: 14,
//                         color: Colors.grey[500],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         scan.timeAgo,
//                         style: TextStyle(fontSize: 13, color: Colors.grey[500]),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor().withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           scan.isSafe ? 'Safe' : 'Threat',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: _getStatusColor(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),



//  Text(
//                   '${scan.score.toStringAsFixed(0)}%',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: _getScoreColor(),
//                   ),
//                 ),