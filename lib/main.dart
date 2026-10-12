import 'package:flutter/material.dart';

import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/library_item.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'ADMD - Lab 2'),
    );
  }
}


// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Task I: Users'),
              Tab(icon: Icon(Icons.account_balance), text: 'Task II: Banks'),
              Tab(icon: Icon(Icons.library_books), text: 'Task III: Library'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskOneView(),
            TaskTwoView(),
            TaskThreeView(),
          ],
        ),
      ),
    );
  }
}


class TaskOneView extends StatelessWidget {
  const TaskOneView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> users = [
      User(name: "Ana Popescu", age: 25, email: "ana@email.com"),
      User(name: "Mihai Ionescu", age: 30),
      User(name: "Elena Radu"),
    ];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) {
        final user = users[i];
        return ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(user.name),
          subtitle: Text(user.email ?? 'Not provided'),
          trailing: Text(user.getDisplayAge()),
        );
      },
    );
  }
}


class TaskTwoView extends StatelessWidget {
  const TaskTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    final acc1 = BankAccount(holderName: "Ana Popescu", bankBranch: "București Centru");
    acc1.initializeAccount("RO123456789");

    final acc2 = BankAccount(holderName: "Mihai Ionescu", balance: 150.0);
    acc2.initializeAccount("RO987654321"); 

    final acc3 = BankAccount(holderName: "Elena Radu", balance: 50.0);

    final List<BankAccount> accounts = [acc1, acc2, acc3];

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, i) {
        final a = accounts[i];
        String accNumberText = a.isAccountNumberSet() 
            ? a.accountNumber 
            : "Cont neinițializat!";

        return ListTile(
          leading: const Icon(Icons.account_balance_wallet_outlined),
          title: Text(a.holderName),
          subtitle: Text('Sucursala: ${a.bankBranch ?? "N/A"}\nIBAN: $accNumberText'),
          trailing: Text('${a.balance} RON'),
          isThreeLine: true,
        );
      },
    );
  }
}


class TaskThreeView extends StatelessWidget {
  const TaskThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    final library = Library();
    final student = User(name: "Petrescu Alexandra-Maria", age: 21);
    final altUser = User(name: "Mihai");

    final rustBook = Book(title: "Embedded Rust", author: "C.B.", pageCount: 300);
    final techMag = Magazine(title: "Tech Today", issueNumber: 42);
    
    library.addItem(rustBook);
    library.addItem(techMag);

    library.borrowItem(rustBook, student, DateTime.now().add(const Duration(days: 14)));
    library.borrowItem(rustBook, altUser, DateTime.now());

    final items = library.allItems;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final isBorrowed = item.borrower != null;
        
        return ListTile(
          leading: Icon(item is Book ? Icons.book : Icons.menu_book_outlined),
          title: Text(item.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.author ?? 'Autor necunoscut'),
              const SizedBox(height: 4), 
              isBorrowed 
                ? Text('Împrumutat de ${item.borrower!.name}', style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold))
                : const Text('Disponibil', style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}