import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:my_widgets/real_state/models/message.dart';


class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.element,
  });

  final Message element;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlurryContainer(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
          decoration: BoxDecoration(
              color: (categorieColors[element.categorie.toLowerCase()] ??
                      Colors.black)
                  .withOpacity(.1),
              borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(12), left: Radius.circular(6)),
              border: Border(
                  left: BorderSide(
                color: (categorieColors[element.categorie.toLowerCase()] ??
                        Colors.black)
                    .withOpacity(.6),
                width: 3,
              ))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            color: categorieColors[
                                element.categorie.toLowerCase()],
                            borderRadius: BorderRadius.circular(0)),
                        child: EText(
                          element.categorie,
                          color: Colors.white,
                          weight: FontWeight.w600,
                        )),
                    element.siege == null
                        ? 0.h
                        : EText(
                            element.siege,
                            weight: FontWeight.bold,
                            color: Colors.teal,
                          )
                  ],
                ),
                6.h,
                EText(
                  element.message.replaceAll("\n", ""),
                  maxLines: 3,
                  weight: FontWeight.w500,
                ),
                3.h,
              
                EText(
                  element.date,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
                6.h,
                  element.contact.isNul
                    ? 0.h
                    : Row(
                        children: [
                         Icon(Icons.circle, size: 12, color: Colors.grey,),
                          3.w,
                          EText(
                            element.contact,
                            weight: FontWeight.w400,
                            color: Colors.teal,
                            
                          ),
                        ],
                      ),
                3.h,
              ],
            ),
          )),
    );
  }
}
