import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/movies_controller.dart';

class MoviesPage extends GetResponsiveView<MoviesController> {
  MoviesPage({super.key});

  Widget responsiveBuilder(bool isDesktop) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'List'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DashBoard(screen: screen, controller: controller),
                  // Table of movies with pagination
                  CustomCard(
                    isDesktop: screen.width > 600,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: '2018',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      if (value.isEmpty) return;
                                      if (int.parse(value) < 1900 || int.parse(value) > DateTime.now().year) {
                                        return;
                                      }
                                      controller.pageRequest.value = controller.pageRequest.value.copyWith(
                                        page: 0,
                                      );

                                      controller.selectedYear.value = int.parse(value);
                                      controller.getPaginatedMovies(0);
                                    },
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                const Text("Winner:"),
                                Obx(() {
                                  return Switch(
                                      value: controller.winnerFilter.value,
                                      onChanged: (_) {
                                        controller.pageRequest.value = controller.pageRequest.value.copyWith(
                                          page: 0,
                                        );
                                        controller.winnerFilter.value = !controller.winnerFilter.value;
                                        controller.getPaginatedMovies(0);
                                      });
                                })
                              ],
                            ),
                          ),
                          // Pagination buttons
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: controller.pageRequest.value.page > 0
                                      ? () {
                                          controller.pageRequest.value = controller.pageRequest.value.copyWith(
                                            page: controller.pageRequest.value.page - 1,
                                          );
                                          controller.getPaginatedMovies(controller.pageRequest.value.page - 1);
                                        }
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    '${controller.pageRequest.value.page + 1}/${controller.paginatedMovies.value.totalPages}'),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: controller.paginatedMovies.value.totalPages >
                                          controller.pageRequest.value.page + 1
                                      ? () {
                                          controller.pageRequest.value = controller.pageRequest.value.copyWith(
                                            page: controller.pageRequest.value.page + 1,
                                          );
                                          controller.getPaginatedMovies(controller.pageRequest.value.page + 1);
                                        }
                                      : null,
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 8),
                          Obx(() {
                            return Table(
                              children: [
                                const TableRow(children: [
                                  TableText('Title'),
                                  TableCell(
                                    child: Text('Year'),
                                  ),
                                  TableText('Movie'),
                                  TableText('Studios'),
                                  TableText('Winner'),
                                ]),
                                ...controller.paginatedMovies.value.items.map(
                                  (movie) {
                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color: controller.paginatedMovies.value.items.indexOf(movie).isEven
                                            ? Colors.grey[200]
                                            : Colors.white,
                                      ),
                                      children: [
                                        TableText(movie.title),
                                        TableText('${movie.year}'),
                                        TableText(movie.producers.join(', ')),
                                        TableText(movie.studios.join(', ')),
                                        TableText(movie.winner.toString()),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget responsiveLayout(bool isDesktop, List<Widget> children) {
    return isDesktop
        ? Row(
            children: children,
          )
        : Column(
            children: children,
          );
  }

  @override
  Widget desktop() {
    return responsiveBuilder(true);
  }

  @override
  Widget tablet() {
    return responsiveBuilder(true);
  }

  @override
  Widget phone() {
    return responsiveBuilder(false);
  }
}

class DashBoard extends StatelessWidget {
  const DashBoard({
    super.key,
    required this.screen,
    required this.controller,
  });

  final ResponsiveScreen screen;
  final MoviesController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          CustomCard(
            isDesktop: screen.width > 600,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Title('Years with multiple winners'),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Table(
                      children: [
                        const TableRow(children: [TableText('Year'), TableText('Winner Count')]),
                        ...controller.years.map(
                          (year) {
                            return TableRow(
                              decoration: BoxDecoration(
                                color: controller.years.indexOf(year).isEven ? Colors.grey[200] : Colors.white,
                              ),
                              children: [
                                TableText('${year.year}'),
                                TableText('${year.winnerCount}'),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(() {
            return CustomCard(
              isDesktop: screen.width > 600,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Title(
                      'Top 3 Studios with more winners',
                    ),
                    const SizedBox(height: 16),
                    Table(
                      children: [
                        const TableRow(children: [TableText('Studio'), TableText('Winnings')]),
                        ...controller.studios.take(3).map(
                          (studio) {
                            return TableRow(
                              decoration: BoxDecoration(
                                color: controller.studios.indexOf(studio).isEven ? Colors.grey[200] : Colors.white,
                              ),
                              children: [
                                TableText(studio.name),
                                TableText('${studio.winnerCount}'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          // List Producer with longest and shortest interval between two awards
          Obx(
            () => CustomCard(
              isDesktop: screen.width > 600,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Title(
                      'Producer with longest and shortest interval between awards',
                    ),
                    const SizedBox(height: 16),
                    const TableText(
                      'Maximum',
                    ),
                    const SizedBox(height: 8),
                    controller.maxMinIntervals.value == null
                        ? const Center(child: CircularProgressIndicator())
                        : Table(
                            children: [
                              const TableRow(children: [
                                TableText(
                                  'Producer',
                                ),
                                TableText(
                                  'Interval',
                                ),
                                TableText(
                                  'Previous Win',
                                ),
                                TableText(
                                  'Following Win',
                                ),
                              ]),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  TableText(controller.maxMinIntervals.value?.max.first.producer ?? ''),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.max.first.interval} years',
                                  ),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.max.first.previousWin}',
                                  ),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.max.first.followingWin}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    const TableText(
                      'Minimum',
                    ),
                    const SizedBox(height: 8),
                    controller.maxMinIntervals.value == null
                        ? const Center(child: CircularProgressIndicator())
                        : Table(
                            children: [
                              const TableRow(children: [
                                TableText(
                                  'Producer',
                                ),
                                TableText(
                                  'Interval',
                                ),
                                TableText(
                                  'Previous Win',
                                ),
                                TableText(
                                  'Following Win',
                                ),
                              ]),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  TableText(controller.maxMinIntervals.value?.min.first.producer ?? ''),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.min.first.interval} years',
                                  ),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.min.first.previousWin}',
                                  ),
                                  TableText(
                                    '${controller.maxMinIntervals.value?.min.first.followingWin}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),

          // List movies by year
          Obx(
            () => CustomCard(
              isDesktop: screen.width > 600,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Title(
                      'Movies by year',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: '2018',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (int.parse(value) < 1900 || int.parse(value) > DateTime.now().year) {
                          return;
                        }
                        controller.getMoviesByYear(int.parse(value));
                      },
                    ),
                    LimitedBox(
                      maxHeight: 300,
                      child: SingleChildScrollView(
                        child: Table(
                          children: [
                            const TableRow(children: [TableText('Title'), TableText('Year')]),
                            ...controller.movies.map(
                              (movie) {
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: controller.movies.indexOf(movie).isEven ? Colors.grey[200] : Colors.white,
                                  ),
                                  children: [
                                    TableText(movie.title),
                                    TableText('${movie.year}'),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    required this.isDesktop,
  });

  final Widget child;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? Get.width / 2 : Get.width,
      ),
      child: Card(
        child: child,
      ),
    );
  }
}

class TableText extends StatelessWidget {
  const TableText(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}

class Title extends StatelessWidget {
  const Title(
    this.text, {
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      textAlign: TextAlign.start,
    );
  }
}
