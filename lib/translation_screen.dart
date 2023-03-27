import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:translator_provider_demo/extenstion.dart';
import 'package:translator_provider_demo/model/available_language.dart';

import 'custom_widget/speaking_icon.dart';
import 'providers/app_theme_provider.dart';
import 'providers/fetch_all_language.dart';
import 'providers/listining_provider.dart';
import 'utils/custom_snackbar.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FetchAllLanguageProvider()..getAllLanguages(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Translation"),
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<AppThemeProvider>().isDarkMode =
                        !context.read<AppThemeProvider>().isDarkMode;
                  },
                  icon: Icon(context.watch<AppThemeProvider>().isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode))
            ],
          ),
          body: SingleChildScrollView(
            child: Consumer<FetchAllLanguageProvider>(
                builder: (context, fetchAllLanguageProvider, child) {
              return fetchAllLanguageProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : fetchAllLanguageProvider.errorMessage != null
                      ? Center(
                          child:
                              Text(fetchAllLanguageProvider.errorMessage ?? ""),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Selector<FetchAllLanguageProvider,
                                              Languages?>(
                                          selector: (context, provider) =>
                                              provider.translateFrom,
                                          shouldRebuild: (prev, next) {
                                            return prev?.name != next?.name;
                                          },
                                          builder: (context, value, child) {
                                            print("FromDropDownRebuild");
                                            return DropdownButtonFormField<
                                                    Languages>(
                                                isExpanded: true,
                                                isDense: true,
                                                value: value,
                                                hint: const Text(
                                                    'Select Language'),
                                                items: List.generate(
                                                    fetchAllLanguageProvider
                                                            .language
                                                            ?.data
                                                            ?.languages
                                                            ?.length ??
                                                        0, (index) {
                                                  final language =
                                                      fetchAllLanguageProvider
                                                          .language
                                                          ?.data
                                                          ?.languages?[index];
                                                  return DropdownMenuItem(
                                                    value: language,
                                                    child: Text(
                                                        language?.name ??
                                                            'not_available'),
                                                  );
                                                }),
                                                onChanged: (value) {
                                                  fetchAllLanguageProvider
                                                      .translateFrom = value;
                                                }).paddingOnly(
                                              left: 10,
                                            );
                                          }),
                                      if (fetchAllLanguageProvider
                                          .isErrorFromTranslationText)
                                        const Text(
                                          "Please select language",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final temp =
                                        fetchAllLanguageProvider.translateFrom;
                                    fetchAllLanguageProvider.translateFrom =
                                        fetchAllLanguageProvider.translateTo;
                                    fetchAllLanguageProvider.translateTo = temp;

                                    final tempText = fetchAllLanguageProvider
                                        .translateFromText;
                                    fetchAllLanguageProvider.translateFromText =
                                        fetchAllLanguageProvider
                                            .translateToText;
                                    fetchAllLanguageProvider.translateToText =
                                        tempText;
                                    fetchAllLanguageProvider
                                            .translateFromController.text =
                                        fetchAllLanguageProvider
                                            .translateFromText;
                                  },
                                  icon: const Icon(
                                      CupertinoIcons.arrow_right_arrow_left),
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Selector<FetchAllLanguageProvider,
                                              Languages?>(
                                          selector: (context, provider) =>
                                              provider.translateTo,
                                          shouldRebuild: (prev, next) {
                                            return prev?.name != next?.name;
                                          },
                                          builder: (context, value, child) {
                                            print("TODropDownRebuild");
                                            return DropdownButtonFormField<
                                                    Languages>(
                                                isExpanded: true,
                                                isDense: true,
                                                value: value,
                                                hint: const Text(
                                                    'Select Language'),
                                                items: List.generate(
                                                    fetchAllLanguageProvider
                                                            .language
                                                            ?.data
                                                            ?.languages
                                                            ?.length ??
                                                        0, (index) {
                                                  final language =
                                                      fetchAllLanguageProvider
                                                          .language
                                                          ?.data
                                                          ?.languages?[index];
                                                  return DropdownMenuItem(
                                                    value: language,
                                                    child: Text(
                                                        language?.name ??
                                                            'not_available'),
                                                  );
                                                }),
                                                onChanged: (value) {
                                                  fetchAllLanguageProvider
                                                      .translateTo = value;
                                                }).paddingOnly(right: 10);
                                          }),
                                      if (fetchAllLanguageProvider
                                          .isErrorToTranslationText)
                                        Text('Select language to translate to',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.red))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Selector<FetchAllLanguageProvider, Languages?>(
                                selector: (context, provider) =>
                                    provider.translateFrom,
                                builder: (context, value, child) {
                                  return RichText(
                                    text: TextSpan(
                                        text: 'Translation From ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          TextSpan(
                                              text: value?.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ]),
                                  ).paddingOnly(
                                      top: 20, bottom: 5, left: 20, right: 20);
                                }),
                            Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Selector<FetchAllLanguageProvider,
                                                TextEditingController>(
                                            selector: (context, provider) =>
                                                provider
                                                    .translateFromController,
                                            shouldRebuild: (prev, next) {
                                              return prev.text != next.text;
                                            },
                                            builder: (context, value, child) {
                                              return TextField(
                                                controller:
                                                    fetchAllLanguageProvider
                                                        .translateFromController,
                                                maxLines: 5,
                                                maxLength: 1000,
                                                buildCounter: (context,
                                                        {required currentLength,
                                                        required isFocused,
                                                        maxLength}) =>
                                                    null,
                                              );
                                            }),
                                        if (fetchAllLanguageProvider
                                            .isErrorFromTextField)
                                          Text('Please enter text to translate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.red)),
                                        const Divider(
                                          thickness: 1,
                                          indent: 20,
                                          endIndent: 20,
                                        ),
                                        Consumer<FetchAllLanguageProvider>(
                                            builder: (context,
                                                fetchAllLanguageProvider, _) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${fetchAllLanguageProvider.translateFromText.length}/1000'),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      fetchAllLanguageProvider
                                                          .resetError();

                                                      if (fetchAllLanguageProvider
                                                          .translateFromController
                                                          .text
                                                          .isEmpty) {
                                                        fetchAllLanguageProvider
                                                                .isErrorFromTextField =
                                                            true;

                                                        return;
                                                      }

                                                      if (fetchAllLanguageProvider
                                                              .translateFrom ==
                                                          null) {
                                                        fetchAllLanguageProvider
                                                                .isErrorFromTranslationText =
                                                            true;

                                                        return;
                                                      }

                                                      if (fetchAllLanguageProvider
                                                              .translateTo ==
                                                          null) {
                                                        fetchAllLanguageProvider
                                                                .isErrorToTranslationText =
                                                            true;

                                                        return;
                                                      }
                                                      if (fetchAllLanguageProvider
                                                              .translateFrom
                                                              ?.code ==
                                                          fetchAllLanguageProvider
                                                              .translateTo
                                                              ?.code) {
                                                        CustomSnackBar.show(
                                                            context,
                                                            'Select different language to translate to',
                                                            SnackBarType
                                                                .warning);
                                                        return;
                                                      }

                                                      fetchAllLanguageProvider
                                                          .translateText();
                                                    },
                                                    child:
                                                        const Text('Translate'),
                                                  ).paddingOnly(right: 10),
                                                  TextButton(
                                                      onPressed: () {
                                                        fetchAllLanguageProvider
                                                            .translateFromController
                                                            .clear();
                                                        fetchAllLanguageProvider
                                                            .translateFromText = '';
                                                      },
                                                      child:
                                                          const Text('Clear')),
                                                  InkWell(
                                                      onTap: () async {
                                                        if (fetchAllLanguageProvider
                                                            .translateFromText
                                                            .isEmpty) {
                                                          return;
                                                        }
                                                        if (Platform
                                                            .isAndroid) {
                                                          await fetchAllLanguageProvider
                                                              .speakFromLanguageText();
                                                        }
                                                      },
                                                      child: SpeakingIndicator(
                                                        isSpeaking:
                                                            fetchAllLanguageProvider
                                                                .isSpeakingFromLanguage,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ).paddingSymmetric(horizontal: 10);
                                        }),
                                      ],
                                    ))
                                .paddingSymmetric(vertical: 20, horizontal: 10),
                            Selector<FetchAllLanguageProvider, Languages?>(
                                selector: (context, provider) =>
                                    provider.translateTo,
                                builder: (context, value, child) {
                                  return RichText(
                                    text: TextSpan(
                                        text: 'Translation to ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          TextSpan(
                                              text: value?.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ]),
                                  ).paddingOnly(
                                      top: 20, bottom: 5, left: 20, right: 20);
                                }),
                            fetchAllLanguageProvider.isTranslating
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        )),
                                  ).paddingOnly(
                                    top: 20, bottom: 5, left: 10, right: 10)
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            fetchAllLanguageProvider
                                                    .translateToText ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          indent: 00,
                                          endIndent: 00,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  if (fetchAllLanguageProvider
                                                      .translateToText
                                                      .isEmpty) {
                                                    return;
                                                  }

                                                  if (Platform.isAndroid) {
                                                    await fetchAllLanguageProvider
                                                        .speakToLanguageText();
                                                  }
                                                },
                                                child: SpeakingIndicator(
                                                  isSpeaking:
                                                      fetchAllLanguageProvider
                                                          .isSpeakingToLanguage,
                                                )),
                                          ],
                                        ).paddingSymmetric(horizontal: 00),
                                      ],
                                    ).paddingSymmetric(
                                        vertical: 10, horizontal: 20),
                                  ).paddingOnly(
                                    top: 20, bottom: 5, left: 10, right: 10),
                          ],
                        );
            }),
          ),
          floatingActionButton: ChangeNotifierProvider(
            create: (context) => ListingSpeechProvider(),
            child: Consumer2<ListingSpeechProvider, FetchAllLanguageProvider>(
                builder:
                    (context, speechProvider, fetchAllLanguageProvider, child) {
              return GestureDetector(
                onTapDown: (details) async {
                  print('Long Press Started');
                  speechProvider.startListening();
                  speechProvider.showDialog(context);
                },
                onLongPressEnd: (details) {
                  print('Long Press Ended');
                  speechProvider.hideDialog();
                  fetchAllLanguageProvider.translateFromText =
                      speechProvider.recordedText;
                  fetchAllLanguageProvider.translateFromController.text =
                      speechProvider.recordedText;
                  fetchAllLanguageProvider.translateText();
                  speechProvider.stopListening();
                },
                onTapUp: (details) {
                  print('Long Press Ended');
                  speechProvider.hideDialog();
                  fetchAllLanguageProvider.translateFromText =
                      speechProvider.recordedText;
                  fetchAllLanguageProvider.translateFromController.text =
                      speechProvider.recordedText;
                  speechProvider.stopListening();
                },
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(Icons.mic)),
              );
            }),
          )),
    );
  }
}
