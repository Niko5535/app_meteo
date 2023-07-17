import 'package:flutter/material.dart';
import 'package:app_meteo/l10n/l10n.dart';
import 'package:app_meteo/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 72,
        child: Text(
          flag,
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  final Function() aggiornaStato;
  const LanguagePickerWidget({super.key, required this.aggiornaStato});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? const Locale('it');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
                aggiornaStato();
              },
              child: Center(
                child: Image(
                  image: AssetImage(flag),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
