import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mylib_app/features/core/constant/padding_constant.dart';
import 'package:mylib_app/features/core/widgets/home_appbar_widget.dart';
import 'package:mylib_app/features/core/widgets/loading_widget.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/book_local_datasource_impl.dart.dart';
import 'package:mylib_app/features/data/repository/impl/summary_repository_impl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/base/base_stateless.dart';
import '../../core/enums/space_sizedbox.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repository/impl/auth_repository_impl.dart';
import '../../data/repository/impl/book_repository_impl.dart';
import '../../data/repository/impl/bookcase_repository_impl.dart';
import '../../data/repository/impl/user_repository_impl.dart';
import 'cubit/home_cubit.dart';

class HomeView extends BaseBlocStateless<HomeCubit, HomeState> {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeCubit createBloc(BuildContext context) {
    final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
    final BookRepositoryImpl bookRepositoryImpl = BookRepositoryImpl();
    final BookcaseRepositoryImpl bookcaseRepositoryImpl =
        BookcaseRepositoryImpl();
    final UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();
    final BookLocalDatasourceImpl bookLocalDatasourceImpl =
        BookLocalDatasourceImpl();
    final SummaryRepositoryImpl summaryRepositoryImpl = SummaryRepositoryImpl();
    return HomeCubit(
      authRepositoryImpl: authRepositoryImpl,
      bookRepositoryImpl: bookRepositoryImpl,
      bookcaseRepositoryImpl: bookcaseRepositoryImpl,
      userRepositoryImpl: userRepositoryImpl,
      bookLocalDatasourceImpl: bookLocalDatasourceImpl,
      summaryRepositoryImpl: summaryRepositoryImpl,
    );
  }

  @override
  Widget buildBloc(BuildContext context, HomeState state) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var userModel = state.userModel;
    var cubit = context.read<HomeCubit>();
    switch (state.status) {
      case HomeStatus.LOADED:
        var now = DateTime.now();
        DateTime starterDate = state.books.isEmpty
            ? DateTime.now()
            : state.books.first.starterDate;
        DateTime endDate =
            state.books.isEmpty ? DateTime.now() : state.books.first.endDate;
        int totalDays = endDate.difference(starterDate).inDays;
        int middle = now.difference(starterDate).inDays;
        double ratio = middle / totalDays;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeAppBarWidget(photoUrl: userModel.photoUrl),
          floatingActionButton: FAB(state: state),
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              await cubit.init();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: PaddingConstant.appPaddingHor,
                    child: Text(
                      "Merhaba,",
                      style: textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: PaddingConstant.appPaddingHor,
                    child: Text(
                      userModel.fullName,
                      style: textTheme.headlineMedium!,
                    ),
                  ),
                  SpaceVerticalSizedBox.l.value,
                  state.books.isEmpty
                      ? Padding(
                          padding: PaddingConstant.appPaddingHor,
                          child: Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/addbook');
                                },
                                text: "Şimdi okumaya başla",
                              )),
                        )
                      : Animate()
                          .custom(
                            duration: 2.seconds,
                            begin: 0,
                            end: 10,
                            builder: (_, value, __) => ReadingBookWidget(
                              size: size,
                              textTheme: textTheme,
                              ratio: ratio,
                              starterDate: starterDate,
                              endDate: endDate,
                              state: state,
                            ),
                          )
                          .moveX(
                            begin: -size.width,
                            end: 0,
                            duration: const Duration(milliseconds: 100),
                            delay: const Duration(milliseconds: 100),
                            curve: Curves.easeInCirc,
                          ),
                  SpaceVerticalSizedBox.l.value,
                  Padding(
                    padding: PaddingConstant.appPaddingHor,
                    child: Text(
                      "Kitaplıklarım",
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SpaceVerticalSizedBox.s.value,
                  state.bookcases.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: CustomButton(
                            text: "Şimdi kitap ekle",
                            onPressed: () {},
                          ))
                      : Animate()
                          .custom(
                            builder: (_, value, __) => BookcaseWidget(
                              size: size,
                              textTheme: textTheme,
                              state: state,
                              cubit: cubit,
                            ),
                          )
                          .blur(
                            begin: const Offset(30, 30),
                            end: const Offset(0, 0),
                            duration: const Duration(milliseconds: 100),
                            delay: const Duration(milliseconds: 100),
                            curve: Curves.easeInCirc,
                          ),
                  SpaceVerticalSizedBox.s.value,
                  state.summaries.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: PaddingConstant.appPaddingHor,
                          child: Text(
                            "Kitap özetleri",
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                  state.summaries.isEmpty
                      ? const SizedBox.shrink()
                      : SummaryWidget(
                          textTheme: textTheme,
                          size: size,
                          state: state,
                        ),
                  SpaceVerticalSizedBox.s.value,
                  state.books.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: PaddingConstant.appPaddingHor,
                          child: Text(
                            "İstatistik",
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                  state.books.isEmpty
                      ? const SizedBox.shrink()
                      : StatisticWidget(size: size),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        );
      case HomeStatus.LOADING:
        return const Scaffold(
          body: LoadingWidget(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({
    super.key,
    required this.textTheme,
    required this.size,
    required this.state,
  });

  final TextTheme textTheme;
  final Size size;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstant.appPaddingHor,
      child: SizedBox(
        height: 300,
        child: PageView.builder(
            physics: const PageScrollPhysics(),
            // padding: const EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            itemCount: state.summaries.length,
            itemBuilder: (context, index) {
              var summary = state.summaries[index];
              var bookName = state.books
                  .firstWhere((e) => e.id == summary.bookId)
                  .bookName;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookName,
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SpaceVerticalSizedBox.xs.value,
                  Expanded(
                    child: Text(
                      summary.summary,
                      // maxLines: 10,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  SpaceVerticalSizedBox.xs.value,
                  CustomButton(
                    text: "Özeti gör",
                    onPressed: () {},
                  )
                ],
              );
            }),
      ),
    );
  }
}

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/statistic'),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xff273043).withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        height: 300,
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SizedBox(
              width: size.width * .7,
              height: size.width * .7,
              child: SfCircularChart(
                series: <RadialBarSeries<ChartData, int>>[
                  RadialBarSeries<ChartData, int>(
                    useSeriesColor: true,
                    trackOpacity: 0.3,
                    cornerStyle: CornerStyle.bothCurve,
                    dataSource: cubit.getDateData(),
                    pointRadiusMapper: (ChartData data, _) =>
                        DateFormat.MMMM('tr_TR').format(data.category),
                    pointColorMapper: (ChartData data, _) =>
                        const Color(0xff273043),
                    xValueMapper: (ChartData data, _) => data.value.toInt(),
                    yValueMapper: (ChartData date, _) => date.value.toInt(),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                    ),
                    dataLabelMapper: (ChartData data, _) =>
                        '${DateFormat.MMMM('tr_TR').format(data.category)} - ${data.value.toInt()}',
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_right,
              color: Color(0xff273043),
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}

class BookcaseWidget extends StatelessWidget {
  const BookcaseWidget({
    super.key,
    required this.size,
    required this.textTheme,
    required this.state,
    required this.cubit,
  });

  final Size size;
  final TextTheme textTheme;
  final HomeState state;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemBuilder: (context, index, realIndex) {
        final bookcase = state.bookcases[index];
        return GestureDetector(
          onLongPress: () async {
            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(bookcase.title),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            "Bu kitaplık silinecek ve içindeki kitaplar başka bir kitaplığa kaydedilecek."),
                        Text("Emin misin?"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Sil'),
                      onPressed: () async {
                        if (state.bookcases.length == 1) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('En az bir kitaplık olmalı'),
                            duration: Duration(seconds: 1),
                          ));
                          return;
                        }
                        await cubit.deleteBookcase(bookcase);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('İptal'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          onTap: () {
            Navigator.of(context)
                .pushNamed('/bookcasedetails', arguments: bookcase);
          },
          child: Container(
            height: 100,
            width: size.width,
            padding: PaddingConstant.homeBookcasePadding,
            decoration: BoxDecoration(
              color: const Color(0xff273043),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bookcase.title,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${bookcase.bookIds.length} kitap",
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 100,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: state.bookcases.length,
    );
  }
}

class ReadingBookWidget extends StatelessWidget {
  const ReadingBookWidget({
    super.key,
    required this.size,
    required this.textTheme,
    required this.ratio,
    required this.starterDate,
    required this.endDate,
    required this.state,
  });

  final Size size;
  final TextTheme textTheme;
  final double ratio;
  final DateTime starterDate;
  final DateTime endDate;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstant.appPaddingHor,
      child: Column(
        children: [
          Container(
            height: 90,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xffFF9900),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.books.first.bookName,
                  style: textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  state.books.first.author,
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SpaceVerticalSizedBox.s.value,
          Padding(
            padding: PaddingConstant.appPaddingHor,
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.85,
              animation: true,
              lineHeight: 24.0,
              animationDuration: 1000,
              percent: ratio > 1 ? 1 : ratio,
              center: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.MMMMd('tr_TR').format(starterDate),
                      style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat.MMMMd('tr_TR').format(endDate),
                      style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              barRadius: const Radius.circular(30),
              progressColor: const Color(0xffFF9900),
              alignment: MainAxisAlignment.center,
              animateFromLastPercent: true,
              backgroundColor: const Color(0xffFFD699),
            ),
          ),
        ],
      ),
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    super.key,
    required this.state,
  });
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pushNamed('/addbookcase');
                },
                child: const Text("Kitaplık ekle"),
              ),
              state.bookcases.isEmpty
                  ? CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                          "Kitap eklemek için önce kitaplık eklemelisin"),
                    )
                  : CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/addbook');
                      },
                      child: const Text("Kitap ekle"),
                    ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pushNamed('/summary');
                },
                child: const Text("Özet ekle"),
              ),
              CupertinoActionSheetAction(
                /// This parameter indicates the action would perform
                /// a destructive action such as delete or exit and turns
                /// the action's text color to red.
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("İptal"),
              ),
            ],
          ),
        );
        // Navigator.of(context).pushNamed('/addbook');
      },
      backgroundColor: const Color(0xffFF9900),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
