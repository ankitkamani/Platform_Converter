import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platform_converter/Providers/ContactProvider.dart';
import 'package:platform_converter/Providers/SettingProvider.dart';
import 'package:platform_converter/Providers/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var contactProviderO = Provider.of<ContactProvider>(context);
    var themeProviderO = Provider.of<ThemeProvider>(context, listen: false);
    return DefaultTabController(
      initialIndex: themeProviderO.defaultPage,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Converter'),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, value, child) => Switch(
                value: value.isIos,
                onChanged: (val) {
                  value.pageNo(index: DefaultTabController.of(context).index);
                  value.platformConvert();
                },
              ),
            )
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person_add_alt),
              ),
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'CALLS',
              ),
              Tab(
                text: 'SETTINGS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: Consumer<ContactProvider>(
                builder: (context, contactProviderValue, child) => Column(
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
                            backgroundImage: !contactProviderValue.isImageEmpty
                                ? FileImage(File(
                                    contactProviderValue.image?.path ?? ''))
                                : null,
                            child: contactProviderValue.isImageEmpty
                                ? const Center(
                                    child: Icon(Icons.add_a_photo_outlined,
                                        size: 50))
                                : null),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: TextField(
                          controller: contactProviderValue.nameController,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                              enabledBorder: OutlineInputBorder())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                          controller: contactProviderValue.phoneController,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.call),
                              enabledBorder: OutlineInputBorder())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0).copyWith(top: 0),
                      child: TextField(
                          controller: contactProviderValue.chatController,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              hintText: 'Chat Conversation',
                              prefixIcon: Icon(Icons.message),
                              enabledBorder: OutlineInputBorder())),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        var a = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(3000));
                        if (!a.toString().contains('null', 0)) {
                          contactProviderValue.date =
                              '${a?.day}/${a?.month}/${a?.year}';
                          contactProviderValue.notifyListeners();
                        }
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                      label: contactProviderValue.date.isEmpty ||
                              contactProviderValue.date.contains('null', 0)
                          ? Text(
                              'Pick Date',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            )
                          : Text(
                              contactProviderValue.date,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        var a = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());

                        if (!a.toString().contains('null', 0)) {
                          contactProviderValue.time = '${a?.hour}:${a?.minute}';
                          contactProviderValue.notifyListeners();
                        }
                      },
                      icon: Icon(
                        Icons.watch_later_outlined,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                      label: contactProviderValue.time.isEmpty ||
                              contactProviderValue.time.contains('null', 0)
                          ? Text(
                              'Pick Time',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            )
                          : Text(
                              contactProviderValue.time,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            ),
                    ),
                    Center(
                      child: IconButton.outlined(
                          onPressed: () {
                            contactProviderValue.img =
                                contactProviderValue.image?.path ?? '';
                            contactProviderValue.addContact();
                            contactProviderValue.clear();
                          },
                          icon: const Text('\t\tSAVE\t\t')),
                    ),
                  ],
                ),
              ),
            ),
            contactProviderO.contacts.isNotEmpty
                ? Consumer<ContactProvider>(
                    builder: (context, value, child) => ListView.builder(
                      itemCount: value.contacts.length,
                      itemBuilder: (context, index) {
                        if (value.contacts.isNotEmpty) {
                          return ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: CircleAvatar(
                                              radius: 70,
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
                                                      child: Text(
                                                      value.contacts[index].name
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 30),
                                                    ))
                                                  : null),
                                        ),
                                        Text(
                                          value.contacts[index].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(value
                                            .contacts[index].chatConversation),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () {
                                                  value.remove(index);
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.delete)),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        IconButton.outlined(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const SizedBox(
                                                width: 70,
                                                height: 30,
                                                child: Center(
                                                    child: Text('Cancel')))),
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
                            subtitle:
                                Text(value.contacts[index].chatConversation),
                            leading: CircleAvatar(
                                backgroundImage: value
                                        .contacts[index].image.isNotEmpty
                                    ? FileImage(
                                        File(value.contacts[index].image ?? ''))
                                    : null,
                                child: value.contacts[index].image.isEmpty
                                    ? Center(
                                        child: Text(value.contacts[index].name
                                            .substring(0, 1)
                                            .toUpperCase()))
                                    : null),
                            trailing: Text(
                                '${value.contacts[index].date}  ${value.contacts[index].time}'),
                          );
                        }
                      },
                    ),
                  )
                : const Center(
                    child: Text("No any chats yet..."),
                  ),
            contactProviderO.contacts.isNotEmpty
                ? Consumer<ContactProvider>(
                    builder: (context, value, child) => ListView.builder(
                      itemCount: value.contacts.length,
                      itemBuilder: (context, index) {
                        if (value.contacts.isNotEmpty) {
                          return ListTile(
                              title: Text(value.contacts[index].name),
                              subtitle:
                                  Text(value.contacts[index].chatConversation),
                              leading: CircleAvatar(
                                  backgroundImage: value
                                          .contacts[index].image.isNotEmpty
                                      ? FileImage(File(
                                          value.contacts[index].image ?? ''))
                                      : null,
                                  child: value.contacts[index].image.isEmpty
                                      ? Center(
                                          child: Text(value.contacts[index].name
                                              .substring(0, 1)
                                              .toUpperCase()))
                                      : null),
                              trailing: IconButton(
                                  onPressed: () async {
                                    Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: value.contacts[index].phoneNumber,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  )));
                        }
                      },
                    ),
                  )
                : const Center(
                    child: Text("No any call yet..."),
                  ),
            SingleChildScrollView(
              child: Consumer<SettingProvider>(
                builder: (context, settingProviderValue, child) => Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      subtitle: const Text('Update Profile Data'),
                      trailing: Switch(
                        value: settingProviderValue.updateProfileData,
                        onChanged: (value) {
                          settingProviderValue.profileOpen();
                        },
                      ),
                    ),
                    Visibility(
                      visible: settingProviderValue.updateProfileData,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              settingProviderValue.imagePick();
                            },
                            child: CircleAvatar(
                                radius: 70,
                                backgroundImage: !settingProviderValue
                                        .isImageEmpty
                                    ? FileImage(File(
                                        settingProviderValue.image?.path ?? ''))
                                    : null,
                                child: settingProviderValue.isImageEmpty
                                    ? const Center(
                                        child: Icon(Icons.add_a_photo_outlined,
                                            size: 50))
                                    : null),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                                controller: settingProviderValue.nameCont,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintText: 'Enter your name...',
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                                controller: settingProviderValue.bioCont,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    hintText: 'Enter your Bio...',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)))),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    settingProviderValue.save();
                                  },
                                  child: const Text('SAVE')),
                              TextButton(
                                  onPressed: () {
                                    settingProviderValue.clear();
                                  },
                                  child: const Text('CLEAR'))
                            ],
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.light_mode_outlined),
                      title: const Text('Theme'),
                      subtitle: const Text('Change Theme'),
                      trailing: Consumer<ThemeProvider>(
                        builder: (context, themeProviderValue, child) {
                          return Switch(
                            value: themeProviderValue.isThemeMode,
                            onChanged: (value) {
                              themeProviderValue.changeTheme();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
