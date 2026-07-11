import 'package:flutter/material.dart';
import '../game/dino_game.dart';
import '../game/skin_colors.dart';

// معادل بخش SKINS در حلقه اصلی پایتون
class SkinsOverlay extends StatefulWidget {
  final DinoGame game;
  const SkinsOverlay({super.key, required this.game});

  @override
  State<SkinsOverlay> createState() => _SkinsOverlayState();
}

class _SkinsOverlayState extends State<SkinsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text('SELECT SKIN',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C3C3C))),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(kSkinOrder.length, (i) {
                  final skin = kSkinOrder[i];
                  final name = kSkinNames[i];
                  final selected = skin == widget.game.data.currentSkin;
                  final color = kSkins[skin]!.body;
                  return GestureDetector(
                    onTap: () {
                      widget.game.selectSkin(skin);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE6E6E6)
                            : const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF646464)
                              : const Color(0xFFC8C8C8),
                          width: selected ? 3 : 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pets, size: 48, color: color),
                                const SizedBox(height: 8),
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF3C3C3C))),
                              ],
                            ),
                          ),
                          if (selected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.check,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () => widget.game.goToMenu(),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
