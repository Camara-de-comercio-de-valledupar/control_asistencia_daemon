import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserTagMenu extends StatelessWidget {
  final Member member;
  const UserTagMenu({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondary;
    final Color textColor = Theme.of(context).colorScheme.onSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textColor,
            ),
            child: Center(
              child: Obx(() {
                final isLoading = Get.find<CurriculumController>().loading;
                final hasCurriculum =
                    Get.find<CurriculumController>().hasCurriculum(member);
                if (isLoading) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                    ),
                    child: const Center(
                      child: LoadingIndicator(
                        count: 1,
                        label: null,
                        size: 20,
                      ),
                    ),
                  );
                }
                if (!hasCurriculum) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                    ),
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.solidUser,
                        color: textColor,
                      ),
                    ),
                  );
                }
                return CachingImage(
                  url: Get.find<CurriculumController>().getMemberImage(member),
                  width: 60,
                  height: 60,
                  borderRadius: 30,
                  fit: BoxFit.cover,
                  errorWidget: Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.solidUser,
                          color: backgroundColor,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${member.firstName} ${member.lastName}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: textColor, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  member.jonRole,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor),
                )
              ],
            ),
          ),
          PopupMenuButton(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textColor,
                ),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: backgroundColor,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(FontAwesomeIcons.rightFromBracket),
                      title: const Text('Cerrar sesión'),
                      onTap: () {
                        Get.find<AuthController>().logout();
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(FontAwesomeIcons.arrowRotateRight),
                      title: const Text('Refrescar datos'),
                      onTap: () {
                        Get.find<CurriculumController>().refreshCurriculums();
                      },
                    ),
                  ),
                ];
              }),
        ],
      ),
    );
  }
}
