import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nyimpang_cooperative/generated/assets.dart';
import 'package:nyimpang_cooperative/json/menu_list.dart';
import 'package:nyimpang_cooperative/json/transactions.dart';
import 'package:nyimpang_cooperative/utils/iconly/iconly_bold.dart';
import 'package:nyimpang_cooperative/utils/layouts.dart';
import 'package:nyimpang_cooperative/utils/size_config.dart';
import 'package:nyimpang_cooperative/utils/styles.dart';
import 'package:nyimpang_cooperative/widgets/news_card.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final size = Layouts.getSize(context);
    return Material(
      color: Styles.whiteColor, //Repository.bgColor(context),
      elevation: 0,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height*0.44,
            color: Styles.primaryColor, //Repository.headerColor(context),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Gap(getProportionateScreenHeight(50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(Assets.nyimpangLogo,
                      width: 120, height: 50, color: Styles.whiteColor),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(IconlyBold.Logout, color: Styles.accentColor),
                    ),
                  )
                ],
              ),
              const Gap(25),
              FittedBox(
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
                          color: Styles.secondaryColor, //Repository.cardColor(context),
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
                            const Text('Rp. 700.000',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 42)),
                            const Gap(5),
                            Text('Cek Riwayat Transaksi',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 18))
                          ],
                        ),
                      ),
                      Container(
                        width: size.width * 0.27,
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(15)),
                          color: Styles.yellowColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 37, 15, 37),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Styles.greenColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.savings,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  Gap(5),
                                  Text('Tabung',
                                      style: TextStyle(
                                          color: Colors.white)),
                                ],
                              )
                            ),
                            const Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          : Navigator.push(context,
                          MaterialPageRoute(builder: (c) => item['route'])),
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
                          const SizedBox(height: 8), // Jarak antara ikon dan teks
                          Text(
                            item['title'],
                            style: TextStyle(fontSize: 12, color: Styles.primaryColor),
                          ),
                        ],
                      ),

                    );
                  }).toList(),
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edukasi & Informasi',
                      style: TextStyle(
                          color: Styles.primaryColor, //Repository.textColor(context),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('Terbaru',
                          style: TextStyle(
                              color: Styles.primaryColor.withOpacity(0.7),/*Repository.subTextColor(context),*/ fontSize: 16)),
                      const Gap(3),
                      Icon(CupertinoIcons.chevron_down,
                          color: Styles.primaryColor.withOpacity(0.7),/*Repository.subTextColor(context),*/ size: 17)
                    ],
                  )
                ],
              ),
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (c, i) {
                    final trs = transactions[i];
                    return const NewsCard(imageUrl: "https://nyimpang.com/wp-content/uploads/2023/06/FEED-REVIEW-TEMPLATE-1-5-750x536.png",
                        title: "Gak Ada yang Benar-Benar Mulai dari Nol!",
                        description: "SPBU pun tidak benar-benar dimulai dari nol. Karena masih ada sisa-sisa dari kendaraan yang mengisi sebelumnya.");
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
