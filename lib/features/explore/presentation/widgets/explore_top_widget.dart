import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/explore_bloc.dart';
import '../../domain/model/explore_model.dart';


//  EXPLORE SEARCH BAR 

class ExploreSearchBar extends StatelessWidget {
  final int activeFilterCount;

  const ExploreSearchBar({super.key, required this.activeFilterCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: AppShadows.card,
              ),
              child: TextField(
                onChanged: (q) => context
                    .read<ExploreBloc>()
                    .add(ExploreSearchChangedEvent(q)),
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search treks, regions…',
                  hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textLight),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.glacierBlue),
                  suffixIcon: const Icon(Icons.mic_rounded, size: 18, color: AppColors.textLight),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Filters pill button
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: activeFilterCount > 0 ? AppColors.saffron : AppColors.cardWhite,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: activeFilterCount > 0 ? AppShadows.button : AppShadows.card,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: activeFilterCount > 0 ? Colors.white : AppColors.slateGray,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    activeFilterCount > 0 ? 'Filters • $activeFilterCount' : 'Filters',
                    style: GoogleFonts.dmSans(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: activeFilterCount > 0 ? Colors.white : AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext ctx) {
    final bloc    = ctx.read<ExploreBloc>();
    final current = bloc.state is ExploreLoaded
        ? (bloc.state as ExploreLoaded).activeFilters
        : ExploreFilters.empty;

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _FilterBottomSheet(initial: current),
      ),
    );
  }
}

//  FILTER BOTTOM SHEET 

class _FilterBottomSheet extends StatefulWidget {
  final ExploreFilters initial;
  const _FilterBottomSheet({required this.initial});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late ExploreFilters _draft;
  final _durMinCtrl = TextEditingController();
  final _durMaxCtrl = TextEditingController();
  final _altMinCtrl = TextEditingController();
  final _altMaxCtrl = TextEditingController();

  static const _locations   = ['Khumbu', 'Gandaki', 'Mustang', 'Manang', 'Gorkha', 'Rasuwa', 'Dolpo', 'Taplejung'];
  static const _difficulties = ['Easy', 'Moderate', 'Hard', 'Extreme'];
  static const _seasons      = ['Spring', 'Summer', 'Autumn', 'Winter'];

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
    _durMinCtrl.text = '${_draft.durationMin}';
    _durMaxCtrl.text = '${_draft.durationMax}';
    _altMinCtrl.text = '${_draft.altitudeMin}';
    _altMaxCtrl.text = '${_draft.altitudeMax}';
  }

  @override
  void dispose() {
    _durMinCtrl.dispose(); _durMaxCtrl.dispose();
    _altMinCtrl.dispose(); _altMaxCtrl.dispose();
    super.dispose();
  }

  void _toggleList(List<String> list, String item, void Function(List<String>) update) {
    final copy = List<String>.from(list);
    copy.contains(item) ? copy.remove(item) : copy.add(item);
    update(copy);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.glacierWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _draft = ExploreFilters.empty;
                        _durMinCtrl.text = '1';  _durMaxCtrl.text = '30';
                        _altMinCtrl.text = '1000'; _altMaxCtrl.text = '9000';
                      });
                    },
                    child: Text('Reset', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.coral)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            // Scrollable content
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  _FilterSection(title: 'Location',
                      child: _ChipGrid(items: _locations, selected: _draft.locations,
                          onToggle: (item) => setState(() => _toggleList(_draft.locations, item, (v) => _draft = _draft.copyWith(locations: v))))),

                  _FilterSection(title: 'Difficulty',
                      child: _ChipGrid(items: _difficulties, selected: _draft.difficulties,
                          onToggle: (item) => setState(() => _toggleList(_draft.difficulties, item, (v) => _draft = _draft.copyWith(difficulties: v))))),

                  _FilterSection(title: 'Duration (days)',
                      child: Row(children: [
                        Expanded(child: _NumField(controller: _durMinCtrl, label: 'Min', onChanged: (v) => _draft = _draft.copyWith(durationMin: int.tryParse(v) ?? 1))),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('to', style: GoogleFonts.dmSans(color: AppColors.textSub))),
                        Expanded(child: _NumField(controller: _durMaxCtrl, label: 'Max', onChanged: (v) => _draft = _draft.copyWith(durationMax: int.tryParse(v) ?? 30))),
                      ])),

                  _FilterSection(title: 'Max Altitude (m)',
                      child: Row(children: [
                        Expanded(child: _NumField(controller: _altMinCtrl, label: 'Min', onChanged: (v) => _draft = _draft.copyWith(altitudeMin: int.tryParse(v) ?? 1000))),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('to', style: GoogleFonts.dmSans(color: AppColors.textSub))),
                        Expanded(child: _NumField(controller: _altMaxCtrl, label: 'Max', onChanged: (v) => _draft = _draft.copyWith(altitudeMax: int.tryParse(v) ?? 9000))),
                      ])),

                  _FilterSection(title: 'Best Season',
                      child: _ChipGrid(items: _seasons, selected: _draft.seasons,
                          onToggle: (item) => setState(() => _toggleList(_draft.seasons, item, (v) => _draft = _draft.copyWith(seasons: v))))),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Apply button
            Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
              color: AppColors.glacierWhite,
              child: GestureDetector(
                onTap: () {
                  context.read<ExploreBloc>().add(ExploreFiltersAppliedEvent(_draft));
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: AppGradients.saffronAccent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: AppShadows.button,
                  ),
                  child: Center(
                    child: Text('Apply Filters', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      child,
      const SizedBox(height: 20),
      const Divider(height: 1, color: AppColors.divider),
      const SizedBox(height: 20),
    ],
  );
}

class _ChipGrid extends StatelessWidget {
  final List<String>    items;
  final List<String>    selected;
  final void Function(String) onToggle;
  const _ChipGrid({required this.items, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8, runSpacing: 8,
    children: items.map((item) {
      final active = selected.contains(item);
      return GestureDetector(
        onTap: () => onToggle(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.saffron : AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: active ? AppColors.saffron : AppColors.divider),
          ),
          child: Text(item, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.slateGray)),
        ),
      );
    }).toList(),
  );
}

class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final void Function(String) onChanged;
  const _NumField({required this.controller, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      border: Border.all(color: AppColors.divider),
    ),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textLight),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    ),
  );
}

//  TREK OF THE WEEK BANNER 

class TrekOfWeekBanner extends StatelessWidget {
  final ExploreTrek trek;
  const TrekOfWeekBanner({super.key, required this.trek});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRoutes.pushTrekDetail(context, trekId: trek.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.soft,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D1117), Color(0xFF1A3A5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Mountain silhouette painter
              CustomPaint(painter: _MountainPainter()),

              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.saffron.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(color: AppColors.saffron.withOpacity(0.4)),
                            ),
                            child: Text(
                              '🏆 TREK OF THE WEEK',
                              style: GoogleFonts.syne(
                                fontSize: 9, fontWeight: FontWeight.w700,
                                color: AppColors.saffron, letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            trek.title,
                            style: GoogleFonts.syne(
                              fontSize: 17, fontWeight: FontWeight.w800,
                              color: Colors.white, height: 1.15,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${trek.durationDays} days · ${trek.region} · ${trek.difficulty}',
                            style: GoogleFonts.dmSans(
                              fontSize: 11, color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.coral, Color(0xFFFF4757)]),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'Explore →',
                        style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.65, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.35)
      ..lineTo(size.width * 0.85, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.4, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final path2 = Path()
      ..moveTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.85, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.6, size.height)
      ..close();

    canvas.drawPath(path2, paint..color = Colors.white.withOpacity(0.04));
  }

  @override
  bool shouldRepaint(_) => false;
}