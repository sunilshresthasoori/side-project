

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/models/trek_detail_model.dart';

class TabSafety extends StatelessWidget {
  final List<TrekPermit>       permits;
  final List<PackingCategory>  packingList;

  const TabSafety({super.key, required this.permits, required this.packingList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Required Permits 
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const _SectionTitle(icon: Icons.description_outlined, title: 'Required Permits'),
                const SizedBox(height: 16),
                ...permits.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PermitCard(permit: p),
                )),
              ],
            ),
          ),

          const SizedBox(height: 14),

          //  Packing List 
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(icon: Icons.backpack_outlined, title: 'Packing List'),
                const SizedBox(height: 16),
                // 2-column packing categories
                ...List.generate(
                  (packingList.length / 2).ceil(),
                      (rowIdx) {
                    final left  = packingList[rowIdx * 2];
                    final right = rowIdx * 2 + 1 < packingList.length ? packingList[rowIdx * 2 + 1] : null;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _PackingColumn(category: left)),
                          if (right != null) ...[
                            const SizedBox(width: 16),
                            Expanded(child: _PackingColumn(category: right)),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          //  Emergency Contacts 
          const _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(icon: Icons.emergency_rounded, title: 'Emergency Contacts'),
                SizedBox(height: 14),
                _EmergencyRow(label: 'Nepal Police Emergency',   number: '100'),
                SizedBox(height: 8),
                _EmergencyRow(label: 'CAAN Rescue (Himalayan)', number: '+977-1-4111788'),
                SizedBox(height: 8),
                _EmergencyRow(label: 'Khumbu Climbers Center',  number: '+977-38-540280'),
                SizedBox(height: 8),
                _EmergencyRow(label: 'Himalayan Rescue Assoc.', number: '+977-1-4440292'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          //  Altitude Sickness Warning 
          Container(
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.coral.withOpacity(0.06),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.coral.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.coral.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.coral),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Altitude Sickness Warning',
                      style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.coral),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...[
                  'Ascend slowly — no more than 500m elevation gain per day above 3,000m.',
                  'Take acclimatization rest days seriously; don\'t rush the itinerary.',
                  'Learn the symptoms: headache, nausea, fatigue, loss of appetite.',
                  'Descend immediately if symptoms are severe. Never sleep at a higher altitude if you feel ill.',
                  'Diamox (Acetazolamide) can help but is not a substitute for proper acclimatization.',
                ].map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.coral,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(tip, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSub, height: 1.55)),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

//  PERMIT CARD 

class _PermitCard extends StatelessWidget {
  final TrekPermit permit;
  const _PermitCard({required this.permit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: const BoxDecoration(
      border: Border(left: BorderSide(color: AppColors.glacierBlue, width: 3)),
      color: AppColors.snowFog,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppRadius.sm),
        bottomRight: Radius.circular(AppRadius.sm),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(permit.name, style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(permit.description, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textSub, height: 1.4)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('NPR ${permit.priceNPR.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.deepGlacier)),
            Text('(USD ${permit.priceUSD})', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textLight)),
          ],
        ),
      ],
    ),
  );
}

//  PACKING COLUMN 

class _PackingColumn extends StatelessWidget {
  final PackingCategory category;
  const _PackingColumn({required this.category});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.electricTeal),
          const SizedBox(width: 6),
          Text(category.title, style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
      const SizedBox(height: 8),
      ...category.items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 5, height: 5,
              decoration: BoxDecoration(color: AppColors.textLight, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Expanded(child: Text(item, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textSub, height: 1.4))),
          ],
        ),
      )),
    ],
  );
}

//  EMERGENCY ROW 

class _EmergencyRow extends StatelessWidget {
  final String label;
  final String number;
  const _EmergencyRow({required this.label, required this.number});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: AppColors.coral.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.phone_rounded, size: 14, color: AppColors.coral),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSub))),
      Text(number, style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.coral)),
    ],
  );
}

//  SHARED 

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: AppShadows.card,
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 17, color: AppColors.saffron),
      const SizedBox(width: 8),
      Text(title, style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ],
  );
}