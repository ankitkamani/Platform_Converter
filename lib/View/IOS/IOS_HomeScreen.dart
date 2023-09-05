import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_converter/Providers/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Providers/ContactProvider.dart';
import '../../Providers/SettingProvider.dart';

class IosHomeScreen extends StatefulWidget {
  const IosHomeScreen({super.key});

  @override
  State<IosHomeScreen> createState() => _IosHomeScreenState();
}

class _IosHomeScreenState extends State<IosHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: const Text('Platform Converter'),
          trailing: CupertinoSwitch(
            value: themeProvider.isIos,
            onChanged: (val) {
              themeProvider.platformConvert();
            },
          )),
      child: SafeArea(
        child: Consumer<ThemeProvider>(
          builder: (context, value, child) => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
                onTap: (val) {
                  value.pageNo(index: val);
                },
                currentIndex: value.defaultPage,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.person_add), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.chat_bubble_2), label: 'CHATS'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.phone), label: 'CALLS'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.settings), label: 'SETTINGS')
                ]),
            tabBuilder: (BuildContext context, int index) {
              var contactProviderO = Provider.of<ContactProvider>(context);
              return Consumer<ThemeProvider>(
                builder: (context, value, child) => CupertinoTabView(
                  builder: (context) {
                    if (index == 0) {
                      return SingleChildScrollView(
                        child: Consumer2<ContactProvider, ThemeProvider>(
                          builder: (context, contactProviderValue, tp, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      contactProviderValue.imagePick();
                                    },
                                    child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            !contactProviderValue.isImageEmpty
                                                ? FileImage(File(
                                                    contactProviderValue
                                                            .image?.path ??
                                                        ''))
                                                : null,
                                        child: contactProviderValue.isImageEmpty
                                            ? const Center(
                                                child: Icon(
                                                    Icons.add_a_photo_outlined,
                                                    size: 50))
                                            : null),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(15)
                                        .copyWith(bottom: 0),
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.person,
                                            color:
                                                Theme.of(context).primaryColor),
                                        Expanded(
                                          child: CupertinoTextField(
                                            placeholder: 'Full Name',
                                            controller: contactProviderValue
                                                .nameController,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.phone,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Expanded(
                                          child: CupertinoTextField(
                                            placeholder: 'Phone Number',
                                            controller: contactProviderValue
                                                .phoneController,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(15.0)
                                      .copyWith(top: 0),
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.chat_bubble_text,
                                          color:
                                              Theme.of(context).primaryColor),
                                      Expanded(
                                        child: CupertinoTextField(
                                          placeholder: 'Chat Conversation',
                                          controller: contactProviderValue
                                              .chatController,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 200,
                                          color: Colors.white,
                                          child: CupertinoDatePicker(
                                            initialDateTime: DateTime.now(),
                                            mode: CupertinoDatePickerMode.date,
                                            onDateTimeChanged: (value) {
                                              if (!value
                                                  .toString()
                                                  .contains('null', 0)) {
                                                contactProviderValue.date =
                                                    '${value.day}/${value.month}/${value.year}';
                                                contactProviderValue
                                                    .notifyListeners();
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.date_range_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: contactProviderValue.date.isEmpty
                                      ? const Text(
                                          'Pick Date',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          contactProviderValue.date,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 200,
                                          color: Colors.white,
                                          child: CupertinoDatePicker(
                                            initialDateTime: DateTime.now(),
                                            mode: CupertinoDatePickerMode.time,
                                            onDateTimeChanged: (value) {
                                              if (!value
                                                  .toString()
                                                  .contains('null', 0)) {
                                                contactProviderValue.time =
                                                    '${value.hour}:${value.minute}';
                                                contactProviderValue
                                                    .notifyListeners();
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.watch_later_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: contactProviderValue.time.isEmpty ||
                                          contactProviderValue.time
                                              .contains('null', 0)
                                      ? const Text(
                                          'Pick Time',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          contactProviderValue.time,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                ),
                                Center(
                                  child: CupertinoButton.filled(
                                      onPressed: () {
                                        contactProviderValue.img =
                                            contactProviderValue.image?.path ??
                                                '';
                                        contactProviderValue.addContact();
                                        contactProviderValue.clear();
                                      },
                                      child: const Text('\t\tSAVE\t\t')),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else if (index == 1) {
                      return contactProviderO.contacts.isNotEmpty
                          ? Consumer<ContactProvider>(
                              builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: value.contacts.length,
                                  itemBuilder: (context, index) {
                                    return CupertinoListTile(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: CircleAvatar(
                                                        radius: 70,
                                                        backgroundImage: value
                                                                .contacts[index]
                                                                .image
                                                                .isNotEmpty
                                                            ? FileImage(File(value
                                                                    .contacts[
                                                                        index]
                                                                    .image ??
                                                                ''))
                                                            : null,
                                                        child: value
                                                                .contacts[index]
                                                                .image
                                                                .isEmpty
                                                            ? Center(
                                                                child: Text(
                                                                value
                                                                    .contacts[
                                                                        index]
                                                                    .name
                                                                    .substring(
                                                                        0, 1)
                                                                    .toUpperCase(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30),
                                                              ))
                                                            : null),
                                                  ),
                                                  Text(
                                                    value.contacts[index].name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(value.contacts[index]
                                                      .chatConversation),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: const Icon(
                                                            Icons.edit),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            value.remove(index);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                              Icons.delete)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CupertinoButton.filled(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const SizedBox(
                                                          width: 70,
                                                          height: 30,
                                                          child: Center(
                                                              child: Text(
                                                                  'Cancel')))),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      title: Text(value.contacts[index].name),
                                      subtitle: Text(value
                                          .contacts[index].chatConversation),
                                      leading: CircleAvatar(
                                          backgroundImage: value.contacts[index]
                                                  .image.isNotEmpty
                                              ? FileImage(File(
                                                  value.contacts[index].image ??
                                                      ''))
                                              : null,
                                          child: value
                                                  .contacts[index].image.isEmpty
                                              ? Center(
                                                  child: Text(value
                                                      .contacts[index].name
                                                      .substring(0, 1)
                                                      .toUpperCase()))
                                              : null),
                                      trailing: Text(
                                          '${value.contacts[index].date}  ${value.contacts[index].time}'),
                                    );
                                  });
                            })
                          : const Center(child: Text("No any chats yet..."));
                    } else if (index == 2) {
                      return contactProviderO.contacts.isNotEmpty
                          ? Consumer<ContactProvider>(
                              builder: (context, value, child) =>
                                  ListView.builder(
                                itemCount: value.contacts.length,
                                itemBuilder: (context, index) {
                                  if (value.contacts.isNotEmpty) {
                                    return CupertinoListTile(
                                        title: Text(value.contacts[index].name),
                                        subtitle: Text(value
                                            .contacts[index].chatConversation),
                                        leading: CircleAvatar(
                                            backgroundImage: value
                                                    .contacts[index]
                                                    .image
                                                    .isNotEmpty
                                                ? FileImage(File(value
                                                        .contacts[index]
                                                        .image ??
                                                    ''))
                                                : null,
                                            child: value.contacts[index].image
                                                    .isEmpty
                                                ? Center(
                                                    child: Text(value
                                                        .contacts[index].name
                                                        .substring(0, 1)
                                                        .toUpperCase()))
                                                : null),
                                        trailing: GestureDetector(
                                            onTap: () async {
                                              Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: value.contacts[index]
                                                    .phoneNumber,
                                              );
                                              await launchUrl(launchUri);
                                            },
                                            child: const Icon(
                                              Icons.call,
                                              color: Colors.green,
                                            )));
                                  }
                                },
                              ),
                            )
                          : const Center(
                              child: Text("No any call yet..."),
                            );
                    } else {
                      return SingleChildScrollView(
                        child: Consumer<SettingProvider>(
                          builder: (context, settingProviderValue, child) {
                            return Column(
                              children: [
                                CupertinoListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Profile'),
                                  subtitle: const Text('Update Profile Data'),
                                  trailing: CupertinoSwitch(
                                    value:
                                        settingProviderValue.updateProfileData,
                                    onChanged: (value) {
                                      settingProviderValue.profileOpen();
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      settingProviderValue.updateProfileData,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          settingProviderValue.imagePick();
                                        },
                                        child: CircleAvatar(
                                            radius: 70,
                                            backgroundImage:
                                                !settingProviderValue
                                                        .isImageEmpty
                                                    ? FileImage(File(
                                                        settingProviderValue
                                                                .image?.path ??
                                                            ''))
                                                    : null,
                                            child: settingProviderValue
                                                    .isImageEmpty
                                                ? const Center(
                                                    child: Icon(
                                                        Icons
                                                            .add_a_photo_outlined,
                                                        size: 50))
                                                : null),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Expanded(
                                            child: CupertinoTextField(
                                                placeholder:
                                                    'Enter your name...',
                                                textAlign: TextAlign.center,
                                                controller: settingProviderValue
                                                    .nameCont,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)))),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Expanded(
                                            child: CupertinoTextField(
                                                placeholder:
                                                    'Enter your bio...',
                                                textAlign: TextAlign.center,
                                                controller: settingProviderValue
                                                    .bioCont,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)))),
                                          )),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CupertinoButton.filled(
                                              onPressed: () {
                                                settingProviderValue.save();
                                              },
                                              child: const Text('SAVE')),
                                          // SizedBox(width: 10,),
                                          CupertinoButton.filled(
                                              onPressed: () {
                                                settingProviderValue.clear();
                                              },
                                              child: const Text('CLEAR')),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                CupertinoListTile(
                                  leading:
                                      const Icon(Icons.light_mode_outlined),
                                  title: const Text('Theme'),
                                  subtitle: const Text('Change Theme'),
                                  trailing: Consumer<ThemeProvider>(
                                    builder:
                                        (context, themeProviderValue, child) {
                                      return CupertinoSwitch(
                                        value: themeProviderValue.isThemeMode,
                                        onChanged: (value) {
                                          themeProviderValue.changeTheme();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
