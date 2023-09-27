import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nyimpang_cooperative/generated/assets.dart';
import 'package:nyimpang_cooperative/json/menu_list.dart';
import 'package:nyimpang_cooperative/models/auth.dart';
import 'package:nyimpang_cooperative/utils/iconly/iconly_bold.dart';
import 'package:nyimpang_cooperative/utils/layouts.dart';
import 'package:nyimpang_cooperative/utils/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fromKeyForUpdate = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _nominalController;
  late String username = "";
  late num nominal = 0;
  late String role = "";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUsername();
    loadUserRole();
    getTotalNominalByUserId();
    _titleController = TextEditingController();
    _nominalController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  Future<void> loadUsername() async {
    String? uName = await UserAuth().getUsername();
    if (uName != null) {
      setState(() {
        username = uName;
      });
    }
  }

  Future<void> loadUserRole() async {
    String? uRole = await UserAuth().getUserRole();
    if (uRole != null) {
      setState(() {
        role = uRole;
      });
    }
  }

  Future<void> getTotalNominalByUserId() async {
    num totalNominal = 0;
    String? userId = await UserAuth().getUserId();

    if (userId != null && userId.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot;
        CollectionReference collection =
            FirebaseFirestore.instance.collection('moneys');

        if (role == 'admin') {
          querySnapshot =
              await collection.where('isVerified', isEqualTo: true).get();
        } else {
          querySnapshot = await collection
              .where('userId',
                  isEqualTo: fireStore.collection('users').doc(userId))
              .where('isVerified', isEqualTo: true)
              .get();
        }

        for (var doc in querySnapshot.docs) {
          totalNominal += doc['nominal'] ?? 0;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching data: $e');
        }
      }
    }

    setState(() {
      nominal = totalNominal;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                delegate: CustomSliverAppBarDelegate(
                    username: username,
                    nominal: nominal,
                    expandedHeight: 200,
                    addNewSavingCallback: addNewSavingShowModalBottomSheet),
                pinned: true),
            SliverPadding(
              padding: const EdgeInsets.only(top: 72.0, left: 16, right: 16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Styles.greyColor, //Repository.accentColor(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: menuList.map<Widget>((item) {
                      return InkWell(
                        onTap: () => item['route'] == null
                            ? null
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => item['route'])),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item['color'].withOpacity(0.15),
                              ),
                              child: Icon(item['icon'], color: item['color']),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'],
                              style: TextStyle(
                                  fontSize: 12, color: Styles.primaryColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            buildContent()
          ],
        ),
      );

  Future<String> getUserDisplayName(DocumentReference userRef) async {
    String displayName = "";
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      displayName = userSnapshot['displayName'];
    }
    return displayName;
  }

  Widget buildContent() {
    Stream<QuerySnapshot<Map<String, dynamic>>> moneyStream;

    if (role == "admin") {
      moneyStream = fireStore
          .collection('moneys')
          .orderBy('created_at', descending: true)
          .snapshots();
    } else {
      moneyStream = fireStore
          .collection('moneys')
          .where('userId',
              isEqualTo: fireStore
                  .collection('users')
                  .doc(firebaseAuth.currentUser!.uid))
          .orderBy('created_at', descending: true)
          .snapshots();
    }

    return StreamBuilder(
      stream: moneyStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator.adaptive()));
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
              child: Center(child: Text(snapshot.error.toString())));
        } else if (snapshot.hasData == true &&
            snapshot.data!.docs.isEmpty == true) {
          return const SliverFillRemaining(
              child: Center(child: Text('Dasar Miskin!')));
        } else if (snapshot.data != null) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: FutureBuilder<String>(
                      future: getUserDisplayName(
                          snapshot.data!.docs[index].get('userId')),
                      builder: (ctx, snap) {
                        String? displayName = snap.data;
                        final title = snapshot.data!.docs[index].get('title');
                        return Text(
                          role == "admin" ? "$title - $displayName" : title,
                        );
                      },
                    ),
                    subtitle: Text(
                      NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
                          .format(
                              snapshot.data!.docs[index].get('nominal') ?? 0),
                    ),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      if (role == "admin")
                        IconButton(
                          onPressed: () async {
                            await updateMoneyShowModalBottomSheet(
                              snapshot.data!.docs[index].get('title'),
                              snapshot.data!.docs[index].get('nominal'),
                              snapshot.data!.docs[index].id,
                              snapshot.data!.docs[index].get('isVerified'),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                      Icon(
                        snapshot.data!.docs[index].get('isVerified') == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            snapshot.data!.docs[index].get('isVerified') == true
                                ? Colors.green
                                : Colors.red,
                      )
                    ]),
                  ),
                ));
          }, childCount: snapshot.data!.docs.length));
        } else {
          return const SliverFillRemaining(
              child: Center(child: Text('------')));
        }
      },
    );
  }

  Future<void> addNewSavingShowModalBottomSheet() async {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter the title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter the nominal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_fromKey.currentState!.validate() == true) {
                      saveMoney();
                    }
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        );
      },
    ).then((value) {
      _titleController.clear();
      _nominalController.clear();
    });
  }

  Future<void> saveMoney() async {
    String userId = firebaseAuth.currentUser!.uid;
    Map<String, dynamic> money = {
      'userId': fireStore.collection('users').doc(userId),
      'title': _titleController.text.trim(),
      'nominal': int.parse(_nominalController.text.trim()),
      'isVerified': false,
      'created_at': FieldValue.serverTimestamp()
    };
    fireStore.collection('moneys').doc().set(money).then((_) {
      _fromKey.currentState!.reset();
      _titleController.clear();
      _nominalController.clear();
      Navigator.pop(context);
      getTotalNominalByUserId();
    }).catchError((onError) {
      showToastMessage(onError.toString());
    });
  }

  Future<void> updateMoneyShowModalBottomSheet(
      String title, num nominal, String documentId, bool isVerified) async {
    bool selectedIsVerified = isVerified;

    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _fromKeyForUpdate,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Update Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('Title: $title'),
                const SizedBox(height: 10),
                Text(NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Nominal: Rp. ',
                        decimalDigits: 0)
                    .format(nominal)),
                const SizedBox(height: 10),
                DropdownButtonFormField<bool>(
                  value: selectedIsVerified,
                  onChanged: (value) {
                    // Update the selected value when the dropdown changes.
                    setState(() {
                      selectedIsVerified = value ?? false;
                    });
                  },
                  items: const <DropdownMenuItem<bool>>[
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Verified'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Not Verified'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_fromKeyForUpdate.currentState!.validate() == true) {
                      updateMoney(selectedIsVerified, documentId);
                    }
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateMoney(bool isVerified, String documentId) async {
    String userId = firebaseAuth.currentUser!.uid;
    Map<String, dynamic> money = {
      'updated_by': fireStore.collection('users').doc(userId),
      'updated_at': FieldValue.serverTimestamp(),
      'isVerified': isVerified
    };

    fireStore.collection('moneys').doc(documentId).update(money).then((_) {
      Navigator.pop(context);
      getTotalNominalByUserId();
    }).catchError((error) {
      showToastMessage(error.toString());
    });
  }

  void showToastMessage(String content, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(content),
          behavior: SnackBarBehavior.floating),
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final VoidCallback addNewSavingCallback;
  final String username;
  final num nominal;

  CustomSliverAppBarDelegate(
      {required this.expandedHeight,
      required this.addNewSavingCallback,
      required this.username,
      required this.nominal});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final sizeLayout = Layouts.getSize(context);
    final top = expandedHeight - shrinkOffset - (sizeLayout.height * 0.2) / 2;

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        buildBackground(shrinkOffset),
        buildAppBar(shrinkOffset),
        Positioned(
          top: top,
          left: 20,
          right: 20,
          child: buildFloating(shrinkOffset, sizeLayout, addNewSavingCallback),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(double shrinkOffset) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
          elevation: 0,
          backgroundColor: Styles.primaryColor,
          title: Row(
            children: <Widget>[
              Image.asset(Assets.nyimpangLogo,
                  width: 80, height: 30, color: Styles.whiteColor),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Text('Halo, $username'),
              ),
            ],
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(IconlyBold.Setting),
                  color: Styles.accentColor,
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      );

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Image.network(
          'https://nyimpang.com/wp-content/uploads/2023/08/UBCJ2289.jpg',
          fit: BoxFit.cover,
        ),
      );

  Widget buildFloating(
          double shrinkOffset, Size size, VoidCallback showModal) =>
      Opacity(
        opacity: disappear(shrinkOffset),
        child: FittedBox(
          child: SizedBox(
            height: size.height * 0.2,
            child: Row(
              children: [
                Container(
                  width: size.width * 0.67,
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(15)),
                    color:
                        Styles.secondaryColor, //Repository.cardColor(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(IconlyBold.Wallet, color: Styles.primaryColor),
                          const Gap(5),
                          Text('Saldo Tabungan'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18)),
                        ],
                      ),
                      const Gap(5),
                      Text(
                          NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp. ',
                                  decimalDigits: 0)
                              .format(nominal),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 42)),
                      const Gap(5),
                      Text('Cek Riwayat Transaksi',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 18,
                              decoration: TextDecoration.underline))
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.27,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(15)),
                    color: Styles.yellowColor,
                  ),
                  child: ElevatedButton(
                    onPressed: showModal,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.savings,
                          color: Colors.white,
                          size: 25,
                        ),
                        Gap(5),
                        Text('Tabung', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildButton({
    required String text,
    required IconData icon,
  }) =>
      TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 20)),
          ],
        ),
        onPressed: () {},
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
