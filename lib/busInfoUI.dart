
import 'package:flutter/material.dart';

class BusServiceInfo extends StatefulWidget
{

  final String busNo;
  BusServiceInfo({required this.busNo});
  @override
  State<BusServiceInfo> createState() => _BusServiceInfoState();
}

String getBusServiceRoute (String busNum){
  Map <String, String> busServeRoute = {'179': 'BOON LAY INT- BOON LAY INT', '199': 'BOON LAY INT- NANYANG CRES','179A': 'BOON LAY INT- WKW SCH OF C&I'};
  String value;
  if(busServeRoute[busNum]==null)
  {
    value ="Bus Service not found";
  }
  else
  {
    value = busServeRoute[busNum]!;
  }
  return value;
}

class _BusServiceInfoState extends State<BusServiceInfo> {
  //String get busNo => this.busNo;
  @override 
   Widget build(BuildContext context){
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Text('${widget.busNo}',style:TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
        Text(getBusServiceRoute(widget.busNo),style:TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
      ],
    );
   }
}


class BusTimingInfo extends StatelessWidget{
   @override 
   Widget build(BuildContext context){
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
          SizedBox(
              height: 50,
              width: 160,
            child:
            TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                ),
              foregroundColor: Colors.blueGrey[800],
              backgroundColor: Colors.brown[200],
              //fixedSize : Size(),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:(context) =>AlertDialog(
                  title: Text("Bus is 3 stops away"),
                  content: Text("Proceed to select boarding and alighting points? "),
                  actions: [
                    TextButton(child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),),
                    TextButton(child: Text("PROCEED"),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>chooseBusStopPoints() )),),
                  ]
                ) ,
              );
            },
            child: const Text('time'),
            ),
          ),
             SizedBox(
              height: 50,
              width: 160,
            child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                ),
              foregroundColor: Colors.blueGrey[800],
              backgroundColor: Colors.brown[200],
              //fixedSize : Size(),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:(context) =>AlertDialog(
                  title: Text("Bus is 11 stops away"),
                  content: Text("Proceed to select boarding and alighting points? "),
                  actions: [
                    TextButton(child: Text("CANCEL"),
                    onPressed: () => Navigator.pop(context),),
                    TextButton(child: Text("PROCEED"),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>chooseBusStopPoints() )),),
                  ]
                ) ,
              );
            },
            child: const Text('time2'),
          ),
          ),
      ],
    );
}
}
class chooseBusStopPoints extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar( 
      backgroundColor: Colors.cyan[900],
      centerTitle: true,
      title: Text("Bus Route"),
    ),
    );
  }
}

class BusStopPointsInfo extends StatelessWidget
{
  @override 
   Widget build(BuildContext context){
    return Column(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      children:[
               SizedBox(
              height: 30,
              width: 350,
            child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                ),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 0, 51, 54),
              //fixedSize : Size(),
            ),
            onPressed: () {},
            child: Align(
              alignment:Alignment.centerLeft,
              child: const Text('Boarding Point: A',),
              ),
          ),
          ),

          SizedBox(
              height: 30,
              width: 350,
            child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                ),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 0, 51, 54),
              //fixedSize : Size(),
            ),
            onPressed: () {},
            child: Align(
              alignment:Alignment.centerLeft,
              child: const Text('Alighting Point: B',),
              ),
          ),
          ),
      ],
    );
   }
}