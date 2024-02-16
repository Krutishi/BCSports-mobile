import 'package:bcsports_mobile/features/market/bloc/cansel_lot/cansel_lot_cubit.dart';
import 'package:bcsports_mobile/features/market/bloc/lots/lots_cubit.dart';
import 'package:bcsports_mobile/features/market/data/market_repository.dart';
import 'package:bcsports_mobile/features/market/ui/widgets/nft_user_ar.dart';
import 'package:bcsports_mobile/features/profile/bloc/user_nft/user_nft_cubit.dart';
import 'package:bcsports_mobile/features/profile/data/profile_repository.dart';
import 'package:bcsports_mobile/models/market/market_item_model.dart';
import 'package:bcsports_mobile/models/market/nft_model.dart';
import 'package:bcsports_mobile/utils/animations.dart';
import 'package:bcsports_mobile/utils/colors.dart';
import 'package:bcsports_mobile/utils/fonts.dart';
import 'package:bcsports_mobile/widgets/buttons/button_back.dart';
import 'package:bcsports_mobile/widgets/popups/cansel_lot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ArPlayersScreen extends StatefulWidget {
  const ArPlayersScreen({super.key});

  @override
  State<ArPlayersScreen> createState() => _MarketLotsScreenState();
}

class _MarketLotsScreenState extends State<ArPlayersScreen> {
  String text = "My players";
  late final ProfileRepository profileRepository;

  @override
  void initState() {
    profileRepository = RepositoryProvider.of<ProfileRepository>(context);
    profileRepository.loadUserNftList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent, body: buildMainInfoWidget()),
      ),
    );
  }

  Widget buildMainInfoWidget() {
    return BlocBuilder<UserNftCubit, UserNftState>(
      builder: (context, state) {
        if (state is UserNftLoading) {
          return Center(
            child: AppAnimations.circleIndicator,
          );
        } else if (state is UserNftSuccess) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                  backgroundColor: AppColors.black,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  floating: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ButtonBack(
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  )),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    text,
                    style: AppFonts.font18w600,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  sliver: BlocBuilder<UserNftCubit, UserNftState>(
                    builder: (context, state) {
                      if (state is UserNftCubit) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: AppAnimations.circleIndicator,
                          ),
                        );
                      } else if (state is UserNftSuccess) {
                        List<NftModel> nftList = profileRepository.userNftList;

                        if (nftList.isEmpty) {
                          return SliverToBoxAdapter(
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height - 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset("assets/icons/poop.svg"),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  SizedBox(
                                      width: 181,
                                      child: Text(
                                        "Looks like you\nhave no NFT",
                                        style: AppFonts.font20w400.copyWith(
                                            color: AppColors.white,
                                            height: 1.2),
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 29,
                                  crossAxisSpacing: 8,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.58),
                          delegate: SliverChildBuilderDelegate(
                              (context, index) => NftUserAr(
                                    nft: nftList[index],
                                    onTap: () {},
                                  ),
                              childCount: nftList.length),
                        );
                      }

                      return SliverToBoxAdapter(child: Container());
                    },
                  ))
            ],
          );
        }

        return Container();
      },
    );
  }
}