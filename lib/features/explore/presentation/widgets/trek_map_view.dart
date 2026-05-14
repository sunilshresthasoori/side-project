import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/explore_bloc.dart';
import '../../domain/model/explore_model.dart';

class TrekMapView extends StatefulWidget {
  final List<ExploreTrek> treks;
  final String? selectedTrekId;

  const TrekMapView({super.key, required this.treks, this.selectedTrekId});

  @override
  State<TrekMapView> createState() => _TrekMapViewState();
}

class _TrekMapViewState extends State<TrekMapView>
    with TickerProviderStateMixin {
  late final List<AnimationController> _pingCtrls;
  late final List<Animation<double>> _pingAnims;

  // Hardcoded relative positions for 3 key peaks on the placeholder map
  static const _pins = [
    _MapPin(
        id: 'everest-base',
        label: 'Everest',
        x: 0.62,
        y: 0.32,
        color: AppColors.coral),
    _MapPin(
        id: 'annapurna-circuit',
        label: 'Annapurna',
        x: 0.28,
        y: 0.48,
        color: AppColors.saffron),
    _MapPin(
        id: 'upper-mustang',
        label: 'Mustang',
        x: 0.18,
        y: 0.28,
        color: AppColors.electricTeal),
  ];

  @override
  void initState() {
    super.initState();
    _pingCtrls = List.generate(
        3,
        (i) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 1400),
            )..repeat(reverse: false));

    _pingAnims = _pingCtrls.asMap().entries.map((e) {
      Future.delayed(Duration(milliseconds: e.key * 450));
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: e.value, curve: Curves.easeOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _pingCtrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //  Map canvas
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1117), Color(0xFF1A3A5C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: AppShadows.soft,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    return Stack(
                      children: [
                        // Topo pattern
                        CustomPaint(
                          size: Size(w, h),
                          painter: _TopoPainter(),
                        ),

                        // Grid lines
                        CustomPaint(
                          size: Size(w, h),
                          painter: _GridPainter(),
                        ),

                        // Center label
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.2)),
                                ),
                                child: const Icon(Icons.map_outlined,
                                    color: Colors.white54, size: 24),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Interactive Map',
                                style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70),
                              ),
                              /*Text(
                                'Add google_maps_flutter to enable',
                                style: GoogleFonts.dmSans(
                                    fontSize: 10, color: Colors.white38),
                              ),*/
                            ],
                          ),
                        ),

                        // Ping dots
                        ..._pins.asMap().entries.map((e) {
                          final pin = e.value;
                          final isSelected = widget.selectedTrekId == pin.id;
                          return Positioned(
                            left: w * pin.x - 10,
                            top: h * pin.y - 10,
                            child: GestureDetector(
                              onTap: () => context
                                  .read<ExploreBloc>()
                                  .add(ExploreMapTrekSelectedEvent(pin.id)),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: AnimatedBuilder(
                                  animation: _pingAnims[e.key],
                                  builder: (_, __) {
                                    final val = _pingAnims[e.key].value;
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Ping ring
                                        Transform.scale(
                                          scale: 0.5 + val * 1.5,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: pin.color
                                                    .withOpacity(1 - val),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Center dot
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? pin.color
                                                : pin.color.withOpacity(0.85),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: pin.color
                                                      .withOpacity(0.6),
                                                  blurRadius: 8)
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }),

                        // Pin labels
                        ..._pins.map((pin) => Positioned(
                              left: w * pin.x - 24,
                              top: h * pin.y + 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  pin.label,
                                  style: GoogleFonts.dmSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        //  Mini card strip
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.treks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _MiniMapCard(
              trek: widget.treks[i],
              isSelected: widget.selectedTrekId == widget.treks[i].id,
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _MapPin {
  final String id;
  final String label;
  final double x, y;
  final Color color;

  const _MapPin(
      {required this.id,
      required this.label,
      required this.x,
      required this.y,
      required this.color});
}

//  MINI MAP CARD

class _MiniMapCard extends StatelessWidget {
  final ExploreTrek trek;
  final bool isSelected;

  const _MiniMapCard({required this.trek, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ExploreBloc>().add(ExploreMapTrekSelectedEvent(trek.id));
        AppRoutes.pushTrekDetail(context, trekId: trek.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.saffron : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? AppShadows.soft : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TrekAssetImage(assetPath: trek.imagePath, fit: BoxFit.cover),
                  Positioned(
                      top: 6,
                      left: 6,
                      child: DifficultyBadge(level: trek.difficulty)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trek.title,
                      style: GoogleFonts.syne(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        size: 10, color: AppColors.coral),
                    const SizedBox(width: 2),
                    Text(trek.region,
                        style: GoogleFonts.dmSans(
                            fontSize: 10, color: AppColors.textSub)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  PAINTERS

class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 8; i++) {
      final offset = i * 10.0;
      final path = Path()
        ..moveTo(0, size.height * 0.4 + offset)
        ..quadraticBezierTo(size.width * 0.3, size.height * 0.1 + offset,
            size.width * 0.55, size.height * 0.3 + offset)
        ..quadraticBezierTo(size.width * 0.75, size.height * 0.5 + offset,
            size.width, size.height * 0.25 + offset);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += size.width / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += size.height / 6) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
