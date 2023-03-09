import 'package:admob_flutter/admob_flutter.dart';
import 'package:bus_client/src/models/linea.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeBus extends StatefulWidget {
  const HomeBus({Key? key}) : super(key: key);

  @override
  State<HomeBus> createState() => _HomeBusState();
}

class _HomeBusState extends State<HomeBus> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('lineas')
      .withConverter(
        fromFirestore: Linea.fromFirestore,
        toFirestore: (Linea linea, _) => linea.toFirestore(),
      )
      .snapshots();

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Micro');
  String searchValue = "";



  setSearch(String value) {
    setState(() {
      searchValue = value;
    });
  }

  search() {
    setState(() {
      if (customIcon.icon == Icons.search) {
        customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          title: TextField(
            onChanged: setSearch,
            decoration: InputDecoration(
              hintText: 'Busca una linea',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      } else {
        searchValue = "";
        customIcon = const Icon(Icons.search);
        customSearchBar = const Text('Micro');
      }
    });
  }

  List<Widget> filtrarLineas(List<QueryDocumentSnapshot<dynamic>> data) {
    List<Widget> lineas = [];
    data.forEach((element) {
      Linea linea = element.data() as Linea;
      String name = linea.name ?? "";
      if (name.contains(searchValue) || searchValue.isEmpty) {
        lineas.add(Container(
          margin: const EdgeInsets.all(5),
          child: Material(
            elevation: 20,
            shadowColor: Colors.black.withAlpha(70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              onTap: () => {
                Navigator.pushNamed(
                  context,
                  'tour_map',
                  arguments: linea,
                )
              },
              tileColor: Theme.of(context).cardColor,
              leading: Container(
                  width: 80,
                  height: 100,
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Image.network(linea.image ?? "")),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(linea.name ?? "Linea"),
            ),
          ),
        ));
      }
    });
    return lineas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customSearchBar,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => {search()},
              icon: customIcon,
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(children: filtrarLineas(snapshot.data!.docs));
          },
        ));
  }
}








class HomePublicidad extends StatefulWidget {
  const HomePublicidad({Key? key}) : super(key: key);

  @override
  _HomePublicidadState createState() => _HomePublicidadState();
  
}

class _HomePublicidadState extends State<HomePublicidad> {
  late AdmobInterstitial interstitialAd;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    interstitialAd = AdmobInterstitial(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        listener: (AdmobAdEvent event, Map<String, dynamic>? args){
          if(event == AdmobAdEvent.closed){
            interstitialAd.load();
          }
        });
    
    interstitialAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child:Text("Sali de mi Cuenta"),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            final isLoaded = await interstitialAd.isLoaded;
            if(isLoaded ?? false){
              interstitialAd.show();
            }else{
              //algun codigo
            }
          },
        ),
      ),
      bottomNavigationBar:Container(
        height: 60,
        child: Center(
          child: AdmobBanner(
            adUnitId: "ca-app-pub-3940256099942544/6300978111",
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String,dynamic>? args){},
          ),
          ),
        ),
      );
  }
}
