const mainUserImage =
    "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/102961878_261268128624182_7495919051351016811_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=102&_nc_ohc=guXVxhmpNwAAX99UoVb&tp=1&oh=fa49d2ba06d4607807963b90f693449c&oe=5FF5F2E8";

const mainUserName = "Aleksandra Romanowska";
//   PostModel(
//       hasTraining: false,
//       hasImage: true,
//       comments: [],
//       description: "Cześć i czołem, Oto zdjęcie w 4k!",
//       id: '2',
//       likes: 169,
//       userImg:
//           "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
//       userName: "Aleksandra",
//       timeTaken: "36m",
//       loadedImg: Image.network(
//         "https://external-preview.redd.it/GOkP8onbuyjGmN9Rc8Que5mw21CdSw6OuXpAKUuE6-4.jpg?auto=webp&s=2bc0e522d1f2fa887333286d557466b2be00fa5e",
//       )),
//   PostModel(
//       hasTraining: false,
//       hasImage: true,
//       comments: [],
//       description: "O M G  ale super fotka",
//       id: '3',
//       likes: 11,
//       userImg:
//           "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71234841_2546282945431303_4647513029292851200_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=BysYn0HX6UsAX8r23I8&_nc_ht=scontent-waw1-1.xx&oh=a9e74690edc8800402b331d5d1954c98&oe=5FF2575B",
//       userName: "Paweł",
//       timeTaken: "1h15m",
//       loadedImg: Image.network(
//         "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/67877813_382156209038925_8513675155840603087_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=109&_nc_ohc=u-LKXxK-arsAX9rJagO&tp=1&oh=1a5c2d444061b2bf8a3ca1b037167de1&oe=5FFA1A58",
//       )),
//   PostModel(
//     hasTraining: false,
//     hasImage: false,
//     likes: 420,
//     comments: [],
//     description:
//         """To szukanie tej pracy teraz mając jedynie 1,5 roku w starej utrzymaniowce jest ciężkie. Już dwa razy miałem, że bardzo dobrze mi poszła część techniczna, ale dostałem informację, że wzięli po prostu kogoś kto ma więcej lat i tyle. C++ here i najgorsze to, że nie mogę zmienić miasta bo inaczej byłoby easy.
//               Czuje że już się tak wypaliłem po toksycznym poprzednim korpo, że nawet jakbym coś znalazł to bym się szczególnie nie cieszył.
//               """,
//     id: '4',
//     userImg:
//         "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/54278936_1457227757741854_4938517215583404032_o.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=Gat38S_SZI8AX_STTfS&_nc_ht=scontent-waw1-1.xx&oh=3720e00c74643f09217613cc417060e5&oe=5FF2AC08",
//     userName: "Michał ",
//     timeTaken: "1d",
//   ),
//   PostModel(
//     hasTraining: true,
//     loadedTraining: Workout(
//         name: "Trening u super długiej nazwie byczq",
//         workoutLength: 60,
//         exercises: [
//           Exercise(
//               id: "1",
//               name: "klatka płaska",
//               series: 4,
//               reps: 8,
//               breakTime: 0),
//           Exercise(
//               id: "2",
//               name: "klatka skośna",
//               series: 4,
//               reps: 15,
//               breakTime: 0),
//           Exercise(
//               id: "3",
//               name: "I TAKI POWINIEN BYĆ DUMMY DATA BYCZQ",
//               series: 4,
//               reps: 8,
//               breakTime: 15),
//           Exercise(
//               id: "4", name: "Rozpiętki", series: 4, reps: 8, breakTime: 15),
//         ]),
//     hasImage: false,
//     likes: 15,
//     comments: [],
//     description: "Jem lody długo, etc. etc. etc\n" * 2,
//     id: '5',
//     userImg:
//         "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/74979486_2361985904061878_4597763555519889408_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=ZywGcq9zZmYAX_EhKGz&_nc_ht=scontent-waw1-1.xx&oh=47c0a3982df12e4f26904651ec665a1c&oe=5FF21720",
//     userName: "Piotr",
//     timeTaken: "36m",
//   ),
//   PostModel(
//     hasTraining: false,
//     hasImage: false,
//     likes: 10,
//     comments: [],
//     description: "Mój tato to fanatyk wędkarstwa, etc. etc. etc\n" * 2,
//     id: '5',
//     userImg:
//         "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
//     userName: "Aleksandra",
//     timeTaken: "36m",
//   ),
// ];