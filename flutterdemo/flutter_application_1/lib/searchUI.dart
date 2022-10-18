import 'package:flutter/material.dart';
import 'package:flutter_application_1/busInfoUI.dart';

class MySearchDelegate extends SearchDelegate {
  @override 
  Widget? buildLeading(BuildContext context)=>IconButton(
    onPressed: ()=>close(context,null),
     icon: const Icon(Icons.arrow_back)
     );
  @override 
  List<Widget>? buildActions(BuildContext context)=>[
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed:(){
        if(query.isEmpty)
        {
          close(context,null);

        }
        else{
        query = '';
        }
      },
      )
  ];
  @override 
  Widget buildResults(BuildContext context)
  {
    String busNoStr = query;
    print(busNoStr);
    return Scaffold(
     body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.cyan[900],
          ),
          margin: EdgeInsets.fromLTRB(5, 320, 5, 0),
          //padding: EdgeInsets.symmetric(horizontal: 156.0, vertical: 110.0),
          //color: Color.fromARGB(255, 3, 120, 116),
            //alignment: Alignment.centerLeft,
            //text button for time

            child:Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
            BusServiceInfo(busNo: busNoStr),
            BusTimingInfo(),
            Align(alignment: Alignment.center,
            child: BusStopPointsInfo(),
            ),
            
            ],
            ),
        ),
        ),
    );
  }
  @override 
  Widget buildSuggestions(BuildContext context){
    List<String> suggestions =[
      '179',
      '199',
      '179A'
    ];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context,index){
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;
            showResults(context);
          },

        );
      },
    );
  } 
}
